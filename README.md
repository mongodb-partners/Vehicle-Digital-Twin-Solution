# Vehicle-Digital-Twin-Solution
MongoDB and AWS integration for connected vehicles


# Intro


# Architecture


# Step-by-step instructions

##  Vehichle Setup
https://github.com/mongodb-industry-solutions/Connected-Devices/blob/aws-connected-vehicle/README.md

## Setup SageMaker 

Deploy sagemaker model "Predictive Maintenance for Vehicle Fleets" to get the end-point

![image](https://user-images.githubusercontent.com/114057324/199462770-84305e10-2a3b-4f10-9f56-7a8cd61e8ee3.png)
![image](https://user-images.githubusercontent.com/114057324/199463222-dcacd80d-1e84-494a-99a7-ba2a5a0f7914.png)

## Building the Code
Replace the sagemaker end-point with the one generated above in python function 

## Setup Eventbridge triggers form MongoDB Atlas

Follow the below link to set AWS Event triggers 
https://www.mongodb.com/docs/atlas/triggers/eventbridge/

## Lambda Functions
Create two lambda functions:

1. For Pulling the data from MongoDB cluster
Select container image and add the ECR URI of your image as below
<img width="1728" alt="Lambda_3" src="https://user-images.githubusercontent.com/114057324/199440133-89626fb6-48ae-4122-8322-0ae19a848161.png">

2. For Pushing the predicted data to MongoDB cluster
<img width="1728" alt="Lambda#2_1" src="https://user-images.githubusercontent.com/114057324/199460640-8e5ad4c9-e89b-4c85-9824-dafd11ddbf5b.png">

## Create Rules for AWS Eventbus
### 1. Eventbus for capturing MongoDB changes
![image](https://user-images.githubusercontent.com/114057324/199439272-e4cfa58b-aebb-4bdc-af69-246ef44b80fa.png)
![image](https://user-images.githubusercontent.com/114057324/199439653-511f20ec-020d-4aad-ac1e-d253d04aa56c.png)
![image](https://user-images.githubusercontent.com/114057324/199439699-d740bfde-7f25-41ad-b9df-a3667abf4cba.png)

Add previously created Lambda as target and create the rule

![image](https://user-images.githubusercontent.com/114057324/199439940-f122ef69-b105-40ed-a255-d89e05b91133.png)

### 2. Eventbus for capturing events sent from Lambda function  
<img width="1728" alt="Eventbridge#2_Rule2" src="https://user-images.githubusercontent.com/114057324/199469002-8ea8e13c-92ac-47a3-bbab-993636017398.png">
<img width="1728" alt="Eventbridge#2_Rule3" src="https://user-images.githubusercontent.com/114057324/199469030-d9aedc95-d8a1-4cb7-b943-6c4de3954300.png">
<img width="1728" alt="Eventbridge#2_Rule4" src="https://user-images.githubusercontent.com/114057324/199469056-2bdc38d7-fddb-4f39-8c0d-fd791694e42b.png">


# Conclusion
For any further information, please contact partners@mongodb.com

<standard>
