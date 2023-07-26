from configparser import ConfigParser

CONFIG_PATH="config.ini"

# ConfigParser
def read_config(file_path):
    config_object = ConfigParser()
    config_object.read(file_path)
    config = {}
    # Info about CoAP Server
    SERVERSINFO = config_object["SERVERSINFO"]
    config["servers"] = SERVERSINFO["servers"]
    config["port"] = SERVERSINFO["port"]  
    config["ressource"] = SERVERSINFO["ressource"]

    # Info about AWS IoT core
    AWSINFO = config_object["AWSINFO"]
    config["endpoint"] = AWSINFO["endpoint"]
    config["client_id"] = AWSINFO["client-id"]
    config["certificate"] = AWSINFO["certificate"]
    config["private_key"] = AWSINFO["private-key"]
    config["root_ca1"] = AWSINFO["root-ca1"]
    config["topic"] = AWSINFO["topic"]

    return config