import json
import AWSIoTPythonSDK.MQTTLib as AWSIoTPyMQTT
import asyncio
from aiocoap import *
from config import *
#import logging
#logging.basicConfig(level=logging.INFO)

# Send a CoAP request to SERVER
@asyncio.coroutine
def coap_request(server,config):
    protocol = yield from Context.create_client_context()
    request = Message(code=GET)
    print("sending request to:"+str(server+"for "+str(config["ressource"])))
    request.set_request_uri('coap://[{}]:{}/{}'.format(server,config["port"],config["ressource"]))
    try:
        response = yield from protocol.request(request).response
        response_str= response.payload.decode("utf-8")
        yield from protocol.shutdown()
        return response_str
    except Exception as e:
        print('Failed to fetch resource:')
        print(e)
        return None 

# Connect to AWS 
def connect_to_aws(config):
    myAWSIoTMQTTClient = AWSIoTPyMQTT.AWSIoTMQTTClient(config["client_id"])
    myAWSIoTMQTTClient.configureEndpoint(config["endpoint"], 8883)
    myAWSIoTMQTTClient.configureCredentials(config["root_ca1"],config["private_key"],config["certificate"])
    if myAWSIoTMQTTClient.connect():
        print("Connected to AWS")
        return myAWSIoTMQTTClient
    else: 
        return 

# Push the payload into AWS
def publish_to_aws_mqtt(AWSIoTMQTTClient,payload,config):
    AWSIoTMQTTClient.publish(config["topic"], json.dumps(payload),1)
    print("Data published into the Cloud")
    
def main():
    myAWSIoTMQTTClient = connect_to_aws(config)
    if myAWSIoTMQTTClient:
        for server in config["servers"].split():
            coap_response = yield from coap_request(server, config)
            if coap_response:
                print("Received a CoAP response sending it to AWS...")
                publish_to_aws_mqtt(myAWSIoTMQTTClient, coap_response, config)

    
if __name__ == "__main__":
    config= read_config(CONFIG_PATH)
    asyncio.get_event_loop().run_until_complete(main())


