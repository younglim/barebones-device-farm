DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd $DIR
sudo dnf install xpra python2-websockify -y
brew install scrcpy
touch .vhui
wget http://www.virtualhere.com/sites/default/files/usbserver/vhusbdx86_64
wget https://www.virtualhere.com/sites/default/files/usbclient/vhclientx86_64
wget https://www.virtualhere.com/sites/default/files/usbclient/vhuit64
chmod +x vhusbdx86_64
chmod +x vhclientx86_64
chmod +x vhuit64
