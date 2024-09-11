#!/usr/bin/env python3

import time
import subprocess


def check_percentage():
    output = subprocess.check_output(["acpi", "-b"]).decode("utf-8").split(",")
    percentage = int(output[1].split("%")[0])
    status = output[0].split(" ")[2]
    return percentage, status


def send_notification(message):
    subprocess.run(["notify-send", message])


def main():
    while True:
        percentage, status = check_percentage()
        if percentage == 100 and status == "Full":
            send_notification(
                "Power overwhelming! Your battery is fully charged and ready to conquer."
            )
            time.sleep(70)
        time.sleep(6000)


if __name__ == "__main__":
    main()
