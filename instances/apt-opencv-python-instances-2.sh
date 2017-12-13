wget -O 3.2.0.zip https://github.com/Itseez/opencv/archive/3.2.0.zip
unzip 3.2.0.zip
wget -O opencv_contrib.zip https://github.com/Itseez/opencv_contrib/archive/3.2.0.zip
unzip opencv_contrib.zip
sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade
sudo apt-get install -y build-essential cmake pkg-config virtualenv
sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
sudo apt-get install -y libxvidcore-dev libx264-dev libgtk-3-dev
sudo apt-get install -y libjpeg8-dev libtiff5-dev libjasper-dev libpng12-dev
sudo apt-get install -y libatlas-base-dev numpy gfortran
sudo apt-get install -y python3.5-dev
sudo apt install -y python-vtk
sudo apt install -y libgstreamer1.0-0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-doc gstreamer1.0-tools
virtualenv cv
cd cv
source bin/activate
cd ~/opencv-3.2.0/
mkdir build
cd build
sudo rm /usr/lib/x86_64-linux-gnu/libGL.so
sudo ln -s /usr/lib/libGL.so.1 /usr/lib/x86_64-linux-gnu/libGL.so
sudo cmake -DCMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr/local -DWITH_TBB=ON -DWITH_QT=ON -DWITH_PTHREADS_PF=ON -DWITH_OPENNI2=ON -DBUILD_EXAMPLES=ON -D OPENCV_EXTRA_MODULES_PATH=/home/xisco/CVISION/opencv_contrib-3.2.0/modules -DBUILD_opencv_legacy=ON -DBUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D BUILD_TIFF=ON -D WITH_QT=ON -D WITH_CUDA=ON -D ENABLE_PRECOMPILED_HEADERS=OFF -D USE_GStreamer=ON -D WITH_OPENGL=ON -D CUDA_ARCH_BIN=3.2 -D FORCE_VTK=ON -DWITH_GDAL=ON -DWITH_XINE=ON -D WITH_NVCUVID=ON -D BUILD_EXAMPLES=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D INSTALL_C_EXAMPLES=ON -D INSTALL_PYTHON_EXAMPLES=ON -D BUILD_EXAMPLES=ON -D WITH_OPENNI=ON -D WITH_OPENGL=ON -D WITH_IPP=ON -D WITH_CSTRIPES=ON -D CUDA_ARCH_PTX=3.2 -D CUDA_ARCH_BIN=3.2 -D WITH_CUBLAS=ON -D ENABLE_FAST_MATH=1 -D CUDA_FAST_MATH=1 -DCUDA_NVCC_FLAGS="-D_FORCE_INLINES" -DOPENCV_TEST_DATA_PATH=/home/xisco/CVISION/opencv_extra/testdata -DCMAKE_C_COMPILER=gcc-4.9 -DCMAKE_CXX_COMPILER=g++-4.9 ..
sudo make -j4
sudo make install
sudo ldconfig
sudo mv /usr/local/lib/python3.5/site-packages/cv2.cpython-35m-x86_64-linux-gnu.so /usr/local/lib/python3.5/site-packages/cv2.so
cd ~/.virtualenvs/cv/lib/python3.5/site-packages/
ln -s /usr/local/lib/python3.5/site-packages/cv2.so cv2.so
