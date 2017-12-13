wget -O - https://raw.githubusercontent.com/joeyism/.files/master/run.sh | bash
sudo apt install unzip

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
sudo apt-get install -y libatlas-base-dev numpy gfortran
sudo apt-get install -y python3.5-dev
virtualenv cv
cd cv
source bin/activate
cd ~/opencv-3.2.0/
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
-D CMAKE_INSTALL_PREFIX=/home/$USER/opencv-3.2.0 \
-D INSTALL_C_EXAMPLES=OFF \
-D INSTALL_PYTHON_EXAMPLES=OFF \
-D OPENCV_EXTRA_MODULES_PATH=/home/$USER/opencv_contrib-3.2.0/modules \
-D BUILD_EXAMPLES=OFF \
-D BUILD_opencv_python2=OFF \
-D WITH_FFMPEG=1 \
-D WITH_CUDA=0 \
-D PYTHON3_EXECUTABLE=/home/$USER/cv/bin/python \
-D PYTHON_INCLUDE_DIR=/home/$USER/cv/include/python3.5m \
-D PYTHON_INCLUDE_DIR2=/home/$USER/cv/include/python3.5m \
-D PYTHON_LIBRARY=/home/$USER/cv/lib/libpython3.5m.so \
-D PYTHON3_PACKAGES_PATH=/home/$USER/cv/lib/python3.5 \
-D PYTHON3_NUMPY_INCLUDE_DIRS=/home/$USER/cv/lib/python3.5/site-packages/numpy/core/include ..
sudo make -j8
sudo make install
sudo ldconfig
sudo cp /usr/local/lib/python3.5/site-packages/cv2.cpython-35m-x86_64-linux-gnu.so /usr/local/lib/python3.5/site-packages/cv2.so
cd ~/.virtualenvs/cv/lib/python3.5/site-packages/
ln -s /usr/local/lib/python3.5/site-packages/cv2.so cv2.so
