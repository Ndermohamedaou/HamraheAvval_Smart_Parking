import config
from typing import Dict
import pymongo as mongo


class MongoDB:
    """MongoDB Class
    Simple class to passing connection string to the constructor
    In the init, connection_string will passing by user that from config-file in db dictionary
    client is instance of mongo to using from that for getting db and collection.
    DB name and collection series name will complete in the config-file.
    """

    def __init__(self, connString: str):
        self.connString = connString
        self.client = mongo.MongoClient(self.connString, serverSelectionTimeoutMs=2000)
        self.db = self.client[config.main_config["db"]["db_name"]]
        self.collection = self.db[config.main_config["db"]["collection_name"]]

    def insert_one(self, systemLog: Dict):
        """Insert_one from the important section.
        That will get system log dictionary and will set in proper collection.
        Dictionary of entry:
        {
            src: string,
            dst: string,
            node: string,
            timestamp: int
            dateTime: string
        }
        """
        self.collection.insert_one(systemLog)
