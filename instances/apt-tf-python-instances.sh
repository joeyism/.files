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
sudo apt-get install -y python3.5-dev
sudo apt-get -y install python3-pip
pip3 install --user ipython numpy
pip3 install --ignore-installed --upgrade "https://github.com/lakshayg/tensorflow-build/raw/master/tensorflow-1.4.0rc1-cp36-cp36m-linux_x86_64.whl"

virtualenv cv
cd cv
source bin/activate

git clone git://source.ffmpeg.org/ffmpeg.git ffmpeg
cd ffmpeg
./configure --enable-nonfree --enable-pic --enable-shared
make
sudo make install

wget https://raw.githubusercontent.com/joeyism/.files/master/configure_general.sh
bash configure_general.sh
rm configure_general.sh
