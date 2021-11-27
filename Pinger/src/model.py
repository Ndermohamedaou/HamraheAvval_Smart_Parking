import config
from typing import Dict
import pymongo as mongo


class MongoDB:
    def __init__(self, connString: str):
        self.connString = connString
        self.client = mongo.MongoClient(self.connString, serverSelectionTimeoutMs=2000)
        self.db = self.client[config.main_config["db"]["db_name"]]
        self.collection = self.db[config.main_config["db"]["collection_name"]]

    def insert_one(self, systemLog: Dict):
        self.collection.insert_one(systemLog)
