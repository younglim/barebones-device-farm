# barebones-device-farm
A barebones android device farm for controlling android devices via a web browser.

## Screenshot

![Screenshot of multiple devices displayed on web brpwser](https://raw.githubusercontent.com/younglim/barebones-device-farm/master/device-farm-screenshot.png)

## Setting up

### Pre-requisites
- A [Centos 7 / Fedora 28 Workstation](https://getfedora.org/en/workstation/download) or [Ubuntu 18.04 Deskop](http://releases.ubuntu.com/18.04).
- Install `kernel-modules-extra` via `sudo dnf install kernel-modules-extra -y` .
- `hats` user with sudo ([root without password](https://www.digitalocean.com/community/tutorials/how-to-create-a-sudo-user-on-centos-quickstart)) access. 
```
sudo useradd -m hats
sudo usermod -aG wheel hats
echo 'hats ALL=(ALL) NOPASSWD: ALL' | sudo tee -a /etc/sudoers
```

- Set up hats-linux for [Centos 7 / Fedora ](https://github.com/younglim/hats-linux/blob/master/centos-7/INSTALL.md) or [Ubuntu](https://github.com/younglim/hats-linux/blob/master/ubuntu/INSTALL.md). 
- Ensure environment variables to `linuxbrew`, `npm` (for appium) and `android-sdk` are properly configured in `/home/hats/.bashrc`.

### Set-up USB Server
- Go to [VirtualHere Server](https://virtualhere.com/content/usb-servers) and download VirtualHere Server. 
- You can run VirtualHere Server on a separate machine. This machine will act as the USB Server
- A VirtualHere license is required to connect more than 1 android device.
- Ensure VirtualHere USB Server process / service is running.
- Refer to VirtualHere Server documentation for more information on setting up USB Server.

### Set-up USB Client
- Clone or download this repo and copy it's contents to `/opt/scripts`.
- On the Fedora workstation, install [VirtualHere Client](https://www.virtualhere.com/usb_client_software) by downloading their linux release. Note: Commercial software.
- Copy `vhuit64` and `vhclientx86_64` to `/opt/scripts` .
- Ensure the USB Client can access the USB Server running VirtualHere Server. TCP port 7575 or 17575 must be open.
- Within a Desktop Environment, run `/opt/scripts/runVhui.sh` . Choose the USB Server and device(s) you want to attach to the USB Client.

### Set-up barebones-device-farm
- Install `xpra` and `websokify` by using `sudo dnf install xpra python2-websockify -y` (Fedora) or `sudo apt install xpra python-websockify -y` (Ubuntu).
- Additionally, for Ubuntu, apply the following fixes:
  ```
  echo "allowed_users=anybody" | sudo tee --append /etc/X11/Xwrapper.config
  wget https://raw.githubusercontent.com/younglim/hats-linux/master/binaries/usr-share-xpra-www.zip
  sudo unzip usr-share-xpra-www.zip -d /usr/share/xpra/
  ```

- For Fedora, install `scrcpy` via linuxbrew by using `brew install scrcpy`.

- For Ubuntu,
  ```
  wget https://raw.githubusercontent.com/younglim/hats-linux/master/binaries/scrcpy.zip
  sudo unzip scrcpy.zip -d /usr/local/share
  echo "export PATH=$PATH:/usr/local/share/scrcpy" >> ~/.bashrc
  source ~/.bashrc
   ```
  
## Set up auto-start service script
- Copy service script `sudo cp device-farm.service /etc/systemd/system` .
- Run `sudo systemctl daemon-reload`.
- Enable the service `sudo systemctl enable device-farm.service`.
- Allow service to start on boot by running the following as root `if [ -f /etc/systemd/system/*.wants/device-farm.service ]; then echo "On"; else echo "Off"; fi`

## Run
- Start the service by using `sudo systemctl start device-farm.service`.
- Check service is running `sudo systemctl status device-farm.service`.
- Browse and control your android device `http://localhost:14500`.

## Other Usage
- Set up your own CI tool such as [GoCD](https://www.gocd.org) or [Bamboo](https://www.atlassian.com/software/bamboo) and run appium / robot framework tests.
- Check the [xpra.org](https://www.xpra.org) website for more information on usage scenarios and configuring display client.
