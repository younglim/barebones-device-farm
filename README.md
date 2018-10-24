# barebones-device-farm
A barebones android device farm for controlling android devices via the web.

## Requirements
- A Fedora 28 workstation.
- Set up [hats-linux](https://github.com/younglim/hats-linux). 
- hats user with sudo (root without password) access.
- Connect one or more android device locally with USB debugging enabled

## Set-up
- Install `xpra` and `websokify` via `dnf`.
- Install [VirtualHere Client](https://www.virtualhere.com/usb_client_software) by downloading their linux release. Note: Commercial software.
- Copy `vhuit64` and `vhclientx86_64` to `/opt/scripts` .
- Install and run [VirtualHere Server](https://virtualhere.com/content/usb-servers). Note: Commercial software. 
- The server can be run on a separate machine as long as it resides on the same network as VirtualHere Client and the VirtualHere Server has TCP port 7575 or 17575 open.
- Clone this repo to `/opt/scripts`..
- Modify `/opt/scripts/restartLiveView.sh` with android device serial number.
- Copy service script `/opt/scripts/device-farm.service` to `/etc/systemd/system`.
- Run `sudo systemctl daemon-reload`.
- Enable the service `sudo systemctl enable device-farm.service`.
- Start the service: `sudo systemctl start device-farm.service`.
- Allow service to start on boot by running the following as root `if [ -f /etc/systemd/system/*.wants/device-farm.service ]; then echo "On"; else echo "Off"; fi
`
