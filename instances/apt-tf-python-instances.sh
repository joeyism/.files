#!/bin/bash
sudo apt-get -y update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get install -y python3-dev htop
sudo apt-get install -y build-essential autoconf libtool pkg-config python-opengl python-imaging python-pyrex python-pyside.qtopengl idle-python2.7 qt4-dev-tools qt4-designer libqtgui4 libqtcore4 libqt4-xml libqt4-test libqt4-script libqt4-network libqt4-dbus python-qt4 python-qt4-gl libgle3 python-dev
sudo apt-get install -y build-essential cmake pkg-config virtualenv
sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
sudo apt-get install -y libxvidcore-dev libx264-dev libgtk-3-dev
sudo apt-get install -y libjpeg8-dev libtiff5-dev libjasper-dev libpng12-dev
sudo apt-get install -y libatlas-base-dev numpy gfortran qt5-default htop
sudo apt-get install -y python3.5-dev python3.5-tk 
sudo apt-get -y install python3-pip
pip3 install --user ipython numpy cython h5py keras imageio
pip3 install --ignore-installed --upgrade "https://github.com/lakshayg/tensorflow-build/raw/master/tensorflow-1.4.0-cp35-cp35m-linux_x86_64.whl"

# set python to python3 so coco will run
sudo rm /usr/bin/python
sudo ln -s /usr/bin/python3 /usr/bin/python

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
