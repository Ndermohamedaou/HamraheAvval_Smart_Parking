import config
import brain
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-b", "--building", help="Building name: (setare, main")
args = parser.parse_args()


def main(buildingName: str = "huawei"):
    print(f"Ping function started in {buildingName} buildign...")

    while True:
        brain.ping_by_config(config.__dict__[buildingName])


if args.building:
    main(args.building)
else:
    print("Error in args")
