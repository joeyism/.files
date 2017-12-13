sudo yum install -y gcc
sudo yum install -y python35
sudo yum install -y python35-setuptools
sudo easy_install-3.5 pip
pip3 install --user ipython
wget https://raw.githubusercontent.com/joeyism/.files/master/configure_general.sh
bash configure_general.sh
rm configure_general.sh
