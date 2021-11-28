""" Include of this config file:
This is main config file to put some config keys and values.
Why we get IP Address and use it in config,py? in order to get 
ping to insure from connection is okay.

What we will use in this config file:
 - Servers 1..n IP Address.
 - Cameras 1..n IP Address.
 - Gateways 1..n IP Address.
 
 Payattention for dicts name, only use specific name that you want input as option in command line. like this: 
 py /src/main.py <-b or --building> (setare|main|huawei)
"""

time_to_wait = 100

main_config = {
    # Change this string if you want use the replicated Mongos database
    "db": {
        # Loopback DB
        "conn_string": "mongodb://localhost:27017/?readPreference=primary&appname=MongoDB%20Compass&ssl=false",
        "db_name": "CPR_Paya_DB",
        "collection_name": "Syslog",
    }
}

setare = {
    "server": [
        {"server1": "10.99.176.60"},
        {"server2": "10.99.176.61"},
        {"server3": "10.99.176.62"},
    ],
    "camera": [
        {"camera1": "10.99.176.50"},
        {"camera2": "10.99.176.51"},
        {"camera3": "10.99.176.52"},
        {"camera4": "10.99.176.53"},
    ],
    "gateway": [
        {"gateway1": "10.99.176.113"},
        {"gateway2": "10.99.176.114"},
        {"gateway3": "10.99.176.115"},
        {"gateway4": "10.99.176.116"},
        {"gateway5": "10.99.176.117"},
        {"gateway6": "10.99.176.118"},
        {"gateway7": "10.99.176.119"},
    ],
}

# Check and set new values for main building ips.
main = {
    "server": [
        {"server1": "10.99.176.60"},
        {"server2": "10.99.176.61"},
        {"server3": "10.99.176.62"},
    ],
    "camera": [
        {"camera1": "10.99.176.50"},
        {"camera2": "10.99.176.51"},
        {"camera3": "10.99.176.52"},
        {"camera4": "10.99.176.53"},
    ],
    "gateway": [
        {"gateway1": "10.99.176.54"},
        {"gateway2": "10.99.176.55"},
        {"gateway3": "10.99.176.56"},
        {"gateway4": "10.99.176.57"},
        {"gateway5": "10.99.176.58"},
    ],
}

huawei = {
    "server": [
        {"server1": "10.90.0.13"},
        {"server2": "10.90.0.14"},
        {"server3": "10.90.0.15"},
    ],
    "camera": [
        {"camera1": "10.90.0.17"},
        {"camera2": "10.90.0.18"},
        {"camera3": "10.90.0.19"},
        {"camera4": "10.90.0.20"},
    ],
    "gateway": [
        {"gateway1": "10.90.0.21"},
        {"gateway2": "10.90.0.22"},
        {"gateway3": "10.90.0.23"},
        {"gateway4": "10.90.0.24"},
        {"gateway5": "10.90.0.25"},
        {"gateway6": "10.90.0.25"},
    ],
}
