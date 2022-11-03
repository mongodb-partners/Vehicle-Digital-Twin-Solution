import pymongo

def handler(event, context):
    try:
        #Read data passed to eventbus (e.g. sagemaker-lambda-partner)
        predicted_value = event['detail']['predicted_value']
        vin = event['detail']['vin']

        # Setup the variables for MongoDB Atlas Connection
        values = {
            "mongo-endpoint": "mongodb+srv://main_user:test123@partnersagemaker.fmxyq.mongodb.net/?retryWrites=true&w=majority",
            "region-name": "us-east-1",
            "model-endpoint": "sagemaker-soln-fpm-js-zhao2m-demo-endpoint",
            "db": "AWS",
            "col": "IoT"
        }
        
        ENDPOINT_NAME= values['model-endpoint'] 
        REGION_NAME = values['region-name']
        MONGO_ENDPOINT = values['mongo-endpoint']
        MONGO_DB = values['db']
        MONGO_COL = values['col']

        #Connect to MongoDB Atlas
        client = pymongo.MongoClient(MONGO_ENDPOINT)
        db = client[MONGO_DB]

        updateResult = db[MONGO_COL].update_one(
            {"vin" : vin},
            {
                "$set": {"prediction": predicted_value, "status": "Success"}
            }
        )
        return "Updated : {} count : {}".format(predicted_value, updateResult.modified_count)
    
    except Exception as e:
        updateResult = db[MONGO_COL].update_one(
            {"vin" : vin},
            {
                "$set": {"error_message": str(e), "status": "Failure"}
            }
        )
        raise e