# barebones-device-farm
A barebones android device farm for controlling android devices via the web.

## Requirements
- A Fedora 28 workstation.
- Set up [hats-linux](https://github.com/younglim/hats-linux/blob/master/centos-7/INSTALL.md). 
- hats user with sudo (root without password) access.
- Connect one or more android device locally with USB debugging enabled

## Set-up
- Clone this repo to `/opt/scripts`.

### Additional dependencies
- Set up [hats-linux](https://github.com/younglim/hats-linux/blob/master/centos-7/INSTALL.md). 
- Install `xpra` and `websokify` via `dnf`.

### USB Client and Server
- Install [VirtualHere Client](https://www.virtualhere.com/usb_client_software) by downloading their linux release. Note: Commercial software.
- Copy `vhuit64` and `vhclientx86_64` to `/opt/scripts` .
- Install and run [VirtualHere Server](https://virtualhere.com/content/usb-servers). Note: Commercial software. 
- The server can be run on a separate machine as long as it resides on the same network as VirtualHere Client and the VirtualHere Server has TCP port 7575 or 17575 open.

### Live Control and View Android Device
- Modify `/opt/scripts/restartLiveView.sh` with android device serial number where `MYANDROIDSERIALNUMBER` is your android serial number.
- Copy service script `/opt/scripts/device-farm.service` to `/etc/systemd/system`.
- Run `sudo systemctl daemon-reload`.
- Enable the service `sudo systemctl enable device-farm.service`.
- Start the service: `sudo systemctl start device-farm.service`.
- Allow service to start on boot by running the following as root `if [ -f /etc/systemd/system/*.wants/device-farm.service ]; then echo "On"; else echo "Off"; fi

## Run
- Check service is running `sudo systemctl status device-farm.service`.
- Browse your android device `http://localhost:14500`.
- Set up your own CI tool such as [GoCD](https://www.gocd.org) or [Bamboo](https://www.atlassian.com/software/bamboo) and run appium / robot framework tests.
`
