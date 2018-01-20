wget https://raw.githubusercontent.com/joeyism/.files/master/instances/apt-python-instances.sh
bash apt-python-instances.sh
rm apt-python-instances.sh

sudo apt install -y libnss3 gconf2 xvfb 
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i --force-depends google-chrome-stable_current_amd64.deb
sudo apt-get install -f -y
rm google-chrome-stable_current_amd64.deb

echo "export DISPLAY=:0.0" >> ~/.bashrc
