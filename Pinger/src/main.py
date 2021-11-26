import config
import brain
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-b", "--building", help="Building name: (setare, main")
parser.add_argument("-i", "--ip", help="This system IP")
args = parser.parse_args()


def main(buildingName: str = "huawei", ip: str = "127.0.0.1"):
    print(f"Ping function started in {buildingName} buildign...")

    while True:
        brain.ping_by_config(config.__dict__[buildingName], ip)


if args.building and args.ip:
    main(args.building, args.ip)
else:
    print("Error in args")
