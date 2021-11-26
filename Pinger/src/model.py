import pymongo as mongo


class SystemLog:
    def __init__(self, src: str, dst: str, node: str, timestamp: int, dateTime: str):
        self.src = src
        self.dst = dst
        self.node = node
        self.timestamp = timestamp
        self.dateTime = dateTime
