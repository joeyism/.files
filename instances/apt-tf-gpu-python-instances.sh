#!/bin/bash

# IF GPU, remove anaconda part
AMI_ID=$(curl http://169.254.169.254/latest/meta-data/ami-id)
if [ $AMI_ID == "ami-eb596e8e" ] || [ $AMI_ID == "ami-7336d50e" ]
then
    head -n -1 ~/.bashrc > temp
fi
cp temp ~/.bashrc

sudo apt-get -y update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get install -y htop
sudo apt-get install -y build-essential autoconf libtool pkg-config qt4-dev-tools qt4-designer libqtgui4 libqtcore4 libqt4-xml libqt4-test libqt4-script libqt4-network libqt4-dbus libgle3 
sudo apt-get install -y build-essential cmake pkg-config virtualenv
sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
sudo apt-get install -y libxvidcore-dev libx264-dev libgtk-3-dev
sudo apt-get install -y libjpeg8-dev libtiff5-dev libjasper-dev libpng12-dev
sudo apt-get install -y libatlas-base-dev numpy gfortran qt5-default htop
pip3 install --user ipython numpy cython h5py keras imageio gpustat
pip3 install --ignore-installed --upgrade --user "https://github.com/mind/wheels/releases/download/tf1.5-gpu-nomkl/tensorflow-1.5.0-cp35-cp35m-linux_x86_64.whl"

# set python to python3 so coco will run
sudo rm /usr/bin/python
sudo ln -s /usr/bin/python3.5 /usr/bin/python

git clone https://github.com/waleedka/coco.git
cd coco/PythonAPI
make
sudo make install
cd -

python3 -c "import imageio; imageio.plugins.ffmpeg.download()"
#git clone git://source.ffmpeg.org/ffmpeg.git ffmpeg
#cd ffmpeg
#./configure --enable-nonfree --enable-pic --enable-shared
#make
#sudo make install

wget https://raw.githubusercontent.com/joeyism/.files/master/run.sh
bash run.sh
rm run.sh

mv anaconda3 anaconda3_bu
