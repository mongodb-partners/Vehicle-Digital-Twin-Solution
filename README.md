# Vehicle-Digital-Twin-Solution
MongoDB and AWS integration for connected vehicles


# Intro


# Architecture


# Step-by-step instructions

##  Vehichle Setup
https://github.com/mongodb-industry-solutions/Connected-Devices/blob/aws-connected-vehicle/README.md

## Setup Eventbridge triggers form MongoDB Atlas

Follow the below link to set AWS Event triggers 
https://www.mongodb.com/docs/atlas/triggers/eventbridge/

## Create Lambda functions for handling MongoDB operations

Select container image and add the ECR URI of your image as below
<img width="1728" alt="Lambda_3" src="https://user-images.githubusercontent.com/114057324/199440133-89626fb6-48ae-4122-8322-0ae19a848161.png">

## Create Rules for AWS Eventbus
![image](https://user-images.githubusercontent.com/114057324/199439272-e4cfa58b-aebb-4bdc-af69-246ef44b80fa.png)
![image](https://user-images.githubusercontent.com/114057324/199439653-511f20ec-020d-4aad-ac1e-d253d04aa56c.png)
![image](https://user-images.githubusercontent.com/114057324/199439699-d740bfde-7f25-41ad-b9df-a3667abf4cba.png)

Add Lambda as target and create the rule

![image](https://user-images.githubusercontent.com/114057324/199439940-f122ef69-b105-40ed-a255-d89e05b91133.png)



<standard>
