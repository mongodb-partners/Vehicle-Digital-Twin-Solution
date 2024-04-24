#!/bin/bash
set -e
trap 'catchError $? $LINENO' ERR

catchError() {
    echo "An error occurred on line $2. Exit status: $1"
    exit $1
}

### Add pre-requisites
# -- Docker
# -- AWS CLI
# -- NodeJS
# -- Python3
# -- Atlas app services CLI


echo "Goto atlas and create API key"
# open "https://www.mongodb.com/docs/atlas/app-services/cli/#generate-an-api-key"
read -p "Enter public key: " apiKey 
read -p "Enter private key: " pvtApiKey
read -p "AWS Account ID: " awsID
read -p "Enter AWS Region: " awsRegion


echo "---------------------- MONGODB ATLAS SETUP ----------------------------"

# Update AWS Account ID
cd ../atlas-backend/Connected-Vehicle/triggers
sed -i 1 "s/<ACCOUNT_ID>/$awsID/" eventbridge_publish_battery_telemetry.json
sed -i 1 "s/<REGION>/$awsRegion/" eventbridge_publish_battery_telemetry.json
rm eventbridge_publish_battery_telemetry.json1  


cd ../../
echo "Logging in to Atlas..."

appservices login --api-key=$apiKey --private-api-key=$pvtApiKey

echo "Pushing Connected-Vehicle app to Atlas...This may take a while!"
#TODO: Fix this for Appservices CLI

app_id_info=$(appservices push --local ./Connected-Vehicle --remote Connected-Vehicle -y | tee output.log | tail -1)
app_id=$(echo $app_id_info | cut -d' ' -f 5)

echo "-------------------------------------------------"
echo "|         App Id: $app_id    |"
echo "-------------------------------------------------"

echo "Creating a user for the app..."
appservices users create --type email --email demo --password demopw --app $app_id

echo "Below are the apps in your account..."
appservices apps list

cd ../vehicle-ts/src/realm
sed -i 1 "s/connected-vehicle-.*/"$app_id"\"/" config.ts
cd ../..
npm install
npm run build
echo "Starting the web-app..."
# nohup npm start > start.log 2>&1 &
# echo "Web-app started successfully!"

echo "---------------------- AWS SETUP ----------------------------"

echo "Setting up AWS services!"
echo "Please enter the following details to setup AWS : "
## Input for Sagemaker Endpoint and MongoDB URI
read -p "Enter Sagemaker Endpoint: " sagemakerEndpoint
read -p "Enter MongoDB URI: " mongoURI

## Create AWS Eventbus 
echo "Associating Eventbus..."

# #Get the trigger ID 
read -p "Enter the trigger ID: " triggerId
aws events create-event-bus --region $awsRegion --event-source-name aws.partner/mongodb.com/stitch.trigger/$triggerId --name aws.partner/mongodb.com/stitch.trigger/$triggerId 

pwd
cd ../aws-sagemaker
## Create AWS ECR Repository 
echo "Creating ECR Repositories..."
aws ecr create-repository --repository-name cli_connected_vehicle_atlas_to_sagemaker --region $awsRegion
aws ecr create-repository --repository-name cli_connected_vehicle_sagemaker_to_atlas --region $awsRegion
echo "ECR Repositories created for storing Lambda functions!"

cd code/pull_from_mdb
## Update the Sagemaker Endpoint and Eventbus
sed -i 1 "s/<SAGEMAKER_ENDPOINT>/$sagemakerEndpoint/" app.py
sed -i 1 "s/<REGION>/$awsRegion/" app.py
rm app.py1
### Update the Sagemaker Endpoint and MongoDB URI and Push to container
# ********** Assuming docker is running ********** 

## Push to ECR - Image 1
echo "Building and pushing the image to ECR..."
aws ecr get-login-password --region $awsRegion | docker login --username AWS --password-stdin $awsID.dkr.ecr.$awsRegion.amazonaws.com
docker build -t cli_connected_vehicle_atlas_to_sagemaker .
docker tag cli_connected_vehicle_atlas_to_sagemaker:latest $awsID.dkr.ecr.$awsRegion.amazonaws.com/cli_connected_vehicle_atlas_to_sagemaker:latest
docker push $awsID.dkr.ecr.$awsRegion.amazonaws.com/cli_connected_vehicle_atlas_to_sagemaker:latest

## Create a role with permissions to access Sagemaker and Lambda
echo "Creating a role with permissions to access Sagemaker and Lambda..."
sed -i 1 "s/<REGION>/$awsRegion/" role-policy.json
sed -i 1 "s/<ACCOUNT_ID>/$awsID/" role-policy.json
rm role-policy.json1
aws iam create-role --role-name cli_connected_vehicle_atlas_to_sagemaker-role --assume-role-policy-document file://role-policy.json --region $awsRegion

# Add a wait for role to be created.
echo "Waiting for the role to be created..."
sleep 10

## Create Lambda Function using ECR Image and Role
echo "Creating Lambda function using the ECR Image..."
aws lambda create-function --function-name sagemaker-pull-partner-cli --role arn:aws:iam::$awsID:role/cli_connected_vehicle_atlas_to_sagemaker-role --region $awsRegion --code ImageUri=$awsID.dkr.ecr.$awsRegion.amazonaws.com/cli_connected_vehicle_atlas_to_sagemaker:latest --package-type Image

# Push to ECR - Image 2
pwd
cd ../push_to_mdb
sed -i 1 "s/<MONGODB_URI>/$mongoURI/" write_to_mdb.py
rm write_to_mdb.py1

echo "Building and pushing second image to ECR..."
docker build -t cli_connected_vehicle_sagemaker_to_atlas .
docker tag cli_connected_vehicle_sagemaker_to_atlas:latest $awsID.dkr.ecr.$awsRegion.amazonaws.com/cli_connected_vehicle_sagemaker_to_atlas:latest
docker push $awsID.dkr.ecr.$awsRegion.amazonaws.com/cli_connected_vehicle_sagemaker_to_atlas:latest

echo "Creating Lambda function using the ECR Image..."
aws lambda create-function --function-name sagemaker-push-partner-cli --role arn:aws:iam::$awsID:role/cli_connected_vehicle_atlas_to_sagemaker-role --region $awsRegion --code ImageUri=$awsID.dkr.ecr.$awsRegion.amazonaws.com/cli_connected_vehicle_sagemaker_to_atlas:latest --package-type Image

# Create Rule for AWS event bus
echo "Creating a rule for the event bus..."
aws events put-rule --name sagemaker-pull \
    --event-pattern '{"source": [{"prefix": "aws.partner/mongodb.com"}]}' \
    --event-bus-name aws.partner/mongodb.com/stitch.trigger/$triggerId \
    --region $awsRegion 

aws events put-targets --rule sagemaker-pull \
    --targets "Id"="1","Arn"="arn:aws:lambda:$awsRegion:$awsID:function:sagemaker-pull-partner-cli" \
    --region $awsRegion \
    --event-bus-name aws.partner/mongodb.com/stitch.trigger/$triggerId



# Create Event bus for Sagemaker to Atlas
echo "Creating Event bus for Sagemaker to Atlas..."
aws events create-event-bus --name cli_pushing_to_mongodb --region $awsRegion  

## Create rule for Sagemaker to Atlas
echo "Creating a rule for Sagemaker to Atlas..."
aws events put-rule --name push_to_lambda \
    --event-pattern '{"source": ["user-event"], "detail-type": ["user-preferences"]}' \
    --event-bus-name cli_pushing_to_mongodb \
    --region $awsRegion

aws events put-targets --rule push_to_lambda \
    --targets "Id"="1","Arn"="arn:aws:lambda:$awsRegion:$awsID:function:sagemaker-push-partner-cli" \
    --region $awsRegion \
    --event-bus-name cli_pushing_to_mongodb

echo "------------------  AWS setup completed successfully!  ------------------"
