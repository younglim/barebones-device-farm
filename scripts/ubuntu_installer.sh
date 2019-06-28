echo -e "\n=============================="
echo -e "hats for Ubuntu Web Installer"
echo -e "==============================\n"

original_directory=`pwd`
installer_directory="$original_directory/barebones-device-farm"

touch ~/.bash_profile

sudo apt install git python3 python3-pip -y
pip3 install ansible 
export PATH="~/.local/bin:$PATH"

git clone https://github.com/younglim/barebones-device-farm.git

cd "$installer_directory/scripts"

ansible-playbook -i "localhost," -c local ansible-playbook-run-tasks.yml

cd $original_directory
rm -rf $installer_directory

. ~/.bash_profile