# Vehicle-Digital-Twin-Solution
MongoDB and AWS integration for connected vehicles.


# Intro
A connected vehicle platform opens a window of analytical data that manufacturers can use to provide recommendations for safer, more efficient and improved driving experiences. Personalized driving experiences are made possible through bidirectional information exchange between applications in the car, mobile, webapps and machine learning interfaces in the cloud. 

However, creating such a cutting edge connected vehicle platform requires the best-in-class foundation. With MongoDB Atlas and the AWS ecosystem, you are provided with such building blocks. MongoDB is your end-to-end data layer for efficient bidirectional data exchange, ensuring consistency on a mobile device, vehicle, and the cloud. AWS, including SageMaker and its integration capabilities, is your public cloud infrastructure allowing you to gain value out of your data and produce the right recommendations for enhanced driving experiences. 

With these tools in mind, let’s begin creating a cutting edge connected vehicle platform! 


# Architecture
![image](https://user-images.githubusercontent.com/114057324/199659004-49177737-3e80-4656-9a5b-e219dbedc296.png)

# Step-by-step instructions

## Create a MongoDB Atlas cluster
Please follow the [link](https://www.mongodb.com/docs/atlas/tutorial/deploy-free-tier-cluster) to setup a free cluster in MongoDB Atlas.

Configure the database for [network security](https://www.mongodb.com/docs/atlas/security/add-ip-address-to-list/) and [access](https://www.mongodb.com/docs/atlas/tutorial/create-mongodb-user-for-cluster/).

##  Vehichle Setup

Connected Vehichle simulation can be setup using the below link, this enables to simulate battery voltage and current for a given Vehichle Identification Number (VIN).

https://github.com/mongodb-industry-solutions/Connected-Devices/blob/aws-connected-vehicle/README.md

## Setup Eventbridge triggers form MongoDB Atlas

Follow the below link to set AWS Event triggers:
https://www.mongodb.com/docs/atlas/triggers/eventbridge/

## Setup SageMaker 

Deploy sagemaker model "Predictive Maintenance for Vehicle Fleets" to get the end-point.

![image](https://user-images.githubusercontent.com/114057324/199462770-84305e10-2a3b-4f10-9f56-7a8cd61e8ee3.png)
![image](https://user-images.githubusercontent.com/114057324/199463222-dcacd80d-1e84-494a-99a7-ba2a5a0f7914.png)

## Building the Code
Replace the sagemaker end-point with the one generated above [here](https://github.com/mongodb-partners/Vehicle-Digital-Twin-Solution/blob/main/code/push_to_mdb/write_to_mdb.py#L13).

## Lambda Functions
Create two lambda functions:

1. For pulling the data from MongoDB cluster, refer this [function](https://github.com/mongodb-partners/Vehicle-Digital-Twin-Solution/blob/main/code/pull_from_mdb).
2. For pushing the predicted data back to MongoDB cluster, refer this [function](https://github.com/mongodb-partners/Vehicle-Digital-Twin-Solution/blob/main/code/push_to_mdb).

Please follow this [guide](https://docs.aws.amazon.com/lambda/latest/dg/images-create.html).

## Create Rules for AWS Eventbus
### 1. Eventbus for capturing MongoDB changes

Add the rule name, description and the eventbus from the dropdown.

![image](https://user-images.githubusercontent.com/114057324/199439272-e4cfa58b-aebb-4bdc-af69-246ef44b80fa.png)

Select the first option for Event source to pull data from MongoDB.

![image](https://user-images.githubusercontent.com/114057324/199439653-511f20ec-020d-4aad-ac1e-d253d04aa56c.png)

Select options for Event source, Partner and type as selected below. 

![image](https://user-images.githubusercontent.com/114057324/199439699-d740bfde-7f25-41ad-b9df-a3667abf4cba.png)

Add previously created Lambda as target and create the rule.

![image](https://user-images.githubusercontent.com/114057324/199439940-f122ef69-b105-40ed-a255-d89e05b91133.png)

### 2. Eventbus for capturing events sent from Lambda function  

This rule is created to move data between lambda functions.
![image](https://user-images.githubusercontent.com/114057324/214270431-89650ccf-63d1-43a5-916f-88fa3f97f147.png)

Select other when selecting event source.
![image](https://user-images.githubusercontent.com/114057324/214270442-c722e775-082f-4f60-862a-bef7d5bcebac.png)

Add below event pattern to be able to send data using python function.
```
{
    "source": ["user-event"],
    "detail-type": ["user-preferences"]
}
```
![image](https://user-images.githubusercontent.com/114057324/214270448-4651a768-4c43-4cb6-95cb-6b0044c517ee.png)

## Sample output
On simulating the connected vehichle application the volatage and current of the vehichle are analysed for percentage of failure. The inference is stored back in MongoDB Atlas.

![image](https://user-images.githubusercontent.com/114057324/199904767-1fb432dc-af21-44aa-a236-31d84ad031f2.png)


# Conclusion
This gives a working template to setup an end-to-end flow for connected vehicles, to analyse its telemetric data using MongoDB Atlas and AWS Services. 

For any further information, please contact partners@mongodb.com

<standard>
