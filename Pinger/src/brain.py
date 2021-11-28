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
    ping -n 1 will use for getting only one replay from ping command.
    Pipe "|" of select-string -pattern only for getting replay of ping.
    """
    try:
        ps_default_path = (
            "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe"
        )
        run = [ps_default_path, f"ping -n 1 {ip} | select-string -pattern 'Reply'"]
        # Decode the output of the command to normal and simple string witout \n\r and etc...
        res = str(subprocess.check_output(run).decode("utf-8"))
        # Will return 128 as ttl and keep that as string, to
        # getting only number of ttl like 64 or 128
        ttl = int(res.split(" ")[5].strip()[4:])  # make it integer
        # Check if ttl is not 0ms or above of 10ms, True is okay, and False is not connected.
        if ttl > 10:
            return True
        else:
            return False

    except Exception as err:
        print(f"Error in ping function: {err}")
        return False


def ping_by_config(config: Dict, srcIP: str):
    """Ping the host by config.py"""

    """Connected to Mongodb with connection string constructor"""
    log = model.MongoDB(main_config["db"]["conn_string"])

    for nodes in config:
        for obj in config[nodes]:
            for node, ip in obj.items():
                # Getting result of ping ip cmd and log it to file or database or somethings else
                ping_result = ps_command(ip)
                print(f"ping n1 src: {srcIP}, dst: {ip}, status: {ping_result}")
                if ping_result == False:
                    print(f"Failed ping n1 src: {srcIP}, dst: {ip}")
                    # More info in insert_one method
                    log.insert_one(
                        {
                            "src": srcIP,
                            "dst": ip,
                            "node": node,
                            "timestamp": int(datetime.now().timestamp()),
                            "dateTime": str(datetime.now()),
                        }
                    )
