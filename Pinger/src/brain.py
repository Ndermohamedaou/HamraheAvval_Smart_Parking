""" Main brain of Pinger Python app.
Use this function to start the app.
Config parameter in ping_by_config is very important because it will specific what is our building location (Setare|Main|Huawei)
"""
from config import main_config
from datetime import datetime
from typing import Dict
import subprocess
import model


def ps_command(ip: str):
    """PS command is command of Windows powershell.
    Using the ps of windows in order to having more script flexibility.
    """
    try:
        ps_default_path = (
            "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe"
        )
        run = [ps_default_path, f"ping -n 1 {ip} | select-string -pattern 'Reply'"]
        # Decode the output of the command to normal and simple string witout \n\r and etc...
        res = str(subprocess.check_output(run).decode("utf-8"))
        # Will return 128 as ttl and keep that as string
        ttl = res.split(" ")[5].strip()[4:]
        # Check if ttl is not 0ms or above of 10ms, True is okay, and False is not connected.
        if ttl > "10":
            return True
        else:
            return False

    except Exception as err:
        # print(f"Error in ping function: {err}")
        return False


def ping_by_config(config: Dict, srcIP: str):
    """Ping the host by config.py"""

    """Connected to Mongodb with connection string constructor"""
    log = model.MongoDB(main_config["db"]["conn_string"])

    for nodes in config:
        for obj in config[nodes]:
            for node, ip in obj.items():
                # Getting result of ping ip cmd and log it to file or database or somethings else
                if not ps_command(ip):
                    print(f"Failed ping n1 src: {srcIP}, dst: {ip}")
                    # Structure of log
                    log.insert_one(
                        {
                            "src": srcIP,
                            "dst": ip,
                            "node": node,
                            "timestamp": int(datetime.now().timestamp()),
                            "dateTime": str(datetime.now()),
                        }
                    )
