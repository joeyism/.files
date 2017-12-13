wget -O - https://raw.githubusercontent.com/joeyism/.files/master/run.sh | bash
sudo apt install -y unzip

wget https://github.com/opencv/opencv/archive/3.2.0.zip
unzip 3.2.0.zip
wget -O opencv_contrib.zip https://github.com/Itseez/opencv_contrib/archive/3.2.0.zip
unzip opencv_contrib.zip
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get install -y build-essential cmake pkg-config virtualenv
sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
sudo apt-get install -y libxvidcore-dev libx264-dev libgtk-3-dev
sudo apt-get install -y libjpeg8-dev libtiff5-dev libjasper-dev libpng12-dev
sudo apt-get install -y libatlas-base-dev numpy gfortran qt5-default htop
sudo apt-get install -y python3.5-dev
sudo apt-get -y install python3-pip
pip3 install --user ipython numpy

virtualenv cv
cd cv
source bin/activate

git clone git://source.ffmpeg.org/ffmpeg.git ffmpeg
cd ffmpeg
./configure --enable-nonfree --enable-pic --enable-shared
make
sudo make install

cd ~/opencv_contrib-3.2.0/modules/freetype
sed -i '22s/freetype2_LIBRARIES/FREETYPE2_LIBRARIES/' CMakeLists.txt
sed -i '23s/harfbuzz_LIBRARIES/HARFBUZZ_LIBRARIES/' CMakeLists.txt

cd ~/opencv-3.2.0/
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
-D CMAKE_INSTALL_PREFIX=/usr/local \
-D WITH_TBB=ON \
-D BUILD_NEW_PYTHON_SUPPORT=ON \
-D WITH_V4L=ON \
-D INSTALL_C_EXAMPLES=ON \
-D INSTALL_PYTHON_EXAMPLES=ON \
-D BUILD_EXAMPLES=ON \
-D WITH_QT=ON \
-D WITH_OPENGL=ON \
-D OPENCV_EXTRA_MODULES_PATH=/home/$USER/opencv_contrib-3.2.0/modules \
-D BUILD_opencv_python2=OFF \
-D WITH_FFMPEG=1 \
-D WITH_CUDA=0 \
-D PYTHON3_EXECUTABLE=python3 ..
sudo make -j $(nproc --all)
sudo make install
sudo ldconfig
sudo cp lib/python3/cv2.so /usr/local/lib/python3.5/dist-packages/
