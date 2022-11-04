# Vehicle-Digital-Twin-Solution
MongoDB and AWS integration for connected vehicles


# Intro
A connected vehicle platform opens a window of analytical data that manufacturers can use to provide recommendations for safer, more efficient and improved driving experiences. Personalized driving experiences are made possible through bidirectional information exchange between applications in the car, mobile, webapps and machine learning interfaces in the cloud. 

However, creating such a cutting edge connected vehicle platform requires the best-in-class foundation. With MongoDB Atlas and the AWS ecosystem, you are provided with such building blocks. MongoDB is your end-to-end data layer for efficient bidirectional data exchange, ensuring consistency on a mobile device, vehicle, and the cloud. AWS, including SageMaker and its integration capabilities, is your public cloud infrastructure allowing you to gain value out of your data and produce the right recommendations for enhanced driving experiences. 

With these tools in mind, let’s begin creating a cutting edge connected vehicle platform! 


# Architecture
![image](https://user-images.githubusercontent.com/114057324/199659004-49177737-3e80-4656-9a5b-e219dbedc296.png)

# Step-by-step instructions

##  Vehichle Setup
https://github.com/mongodb-industry-solutions/Connected-Devices/blob/aws-connected-vehicle/README.md

## Setup SageMaker 

Deploy sagemaker model "Predictive Maintenance for Vehicle Fleets" to get the end-point

![image](https://user-images.githubusercontent.com/114057324/199462770-84305e10-2a3b-4f10-9f56-7a8cd61e8ee3.png)
![image](https://user-images.githubusercontent.com/114057324/199463222-dcacd80d-1e84-494a-99a7-ba2a5a0f7914.png)

## Building the Code
Replace the sagemaker end-point with the one generated above [here](https://github.com/mongodb-partners/Vehicle-Digital-Twin-Solution/blob/aea66805a27d2367d405c45b17951442485bd6b7/code/push_to_mdb/write_to_mdb.py#L13)

## Setup Eventbridge triggers form MongoDB Atlas

Follow the below link to set AWS Event triggers 
https://www.mongodb.com/docs/atlas/triggers/eventbridge/

## Lambda Functions
Create two lambda functions:

1. For pulling the data from MongoDB cluster
2. For pushing the predicted data back to MongoDB cluster

Please follow this [guide](https://docs.aws.amazon.com/lambda/latest/dg/images-create.html)

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
This gives a working demo on how to setup MongoDB Atlas to EventBridge. And taking the inference from Sagemaker to MongoDB Atlas. 

For any further information, please contact partners@mongodb.com

<standard>
