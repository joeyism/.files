wget https://raw.githubusercontent.com/joeyism/.files/master/instances/yum-python-instances.sh
bash yum-python-instances.sh
rm yum-python-instances.sh

sudo yum groupinstall "Development Tools"
sudo yum install gcc cmake git gtk2-devel pkgconfig numpy ffmpeg
sudo mkdir /opt/working
cd /opt/working
sudo git clone https://github.com/Itseez/opencv.git
cd opencv
sudo mkdir release
cd release
sudo cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local ..
sudo make
sudo make install

pip3 install --user opencv-python
