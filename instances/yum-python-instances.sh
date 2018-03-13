sudo yum install -y gcc
sudo yum install -y python35 htop
sudo yum install -y python35-setuptools
sudo yum install -y python35-devel

sudo easy_install-3.5 pip
sudo cp /usr/local/bin/pip3 /usr/sbin/
pip3 install --user ipython
wget https://raw.githubusercontent.com/joeyism/.files/master/configure_general.sh
bash configure_general.sh
rm configure_general.sh
