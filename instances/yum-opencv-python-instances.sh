# python and stuff
wget https://raw.githubusercontent.com/joeyism/.files/master/instances/yum-python-instances.sh
bash yum-python-instances.sh
rm yum-python-instances.sh

# dependencies
sudo yum install -y glibc gcc gcc-c++ autoconf automake libtool git make nasm pkgconfig
sudo yum install -y SDL-devel a52dec a52dec-devel alsa-lib-devel faac faac-devel faad2 faad2-devel
sudo yum install -y freetype-devel giflib gsm gsm-devel imlib2 imlib2-devel lame lame-devel libICE-devel libSM-devel libX11-devel
sudo yum install -y libXau-devel libXdmcp-devel libXext-devel libXrandr-devel libXrender-devel libXt-devel
sudo yum install -y libogg libvorbis vorbis-tools mesa-libGL-devel mesa-libGLU-devel xorg-x11-proto-devel zlib-devel
sudo yum install -y libtheora theora-tools
sudo yum install -y ncurses-devel
sudo yum install -y libdc1394 libdc1394-devel
sudo yum install -y amrnb-devel amrwb-devel opencore-amr-devel 

sudo yum install -y cmake
sudo yum install -y python-devel numpy
sudo yum install -y gcc gcc-c++
sudo yum install -y gtk2-devel
sudo yum install -y libdc1394-devel
sudo yum install -y libv4l-devel
sudo yum install -y ffmpeg-devel
sudo yum install -y gstreamer-plugins-base-devel
sudo yum install -y libpng-devel
sudo yum install -y libjpeg-turbo-devel
sudo yum install -y jasper-devel
sudo yum install -y openexr-devel
sudo yum install -y libtiff-devel
sudo yum install -y libwebp-devel
sudo yum install -y tbb-devel
sudo yum install -y doxygen


# opencv
sudo yum groupinstall "Development Tools"
sudo yum install -y gcc cmake git gtk2-devel pkgconfig numpy ffmpeg
sudo mkdir /opt/working
cd /opt/working
sudo git clone https://github.com/Itseez/opencv.git
cd opencv
sudo mkdir release
cd release
sudo cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local ..
sudo make
sudo make install

# video codecs
cd /opt
sudo git clone git://git.videolan.org/x264.git
cd x264
sudo ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static --disable-asm
sudo make
sudo make install

cd /opt
sudo git clone git://source.ffmpeg.org/ffmpeg.git
cd ffmpeg
git checkout release/2.5
PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig"
export PKG_CONFIG_PATH
sudo ./configure --prefix="$HOME/ffmpeg_build" --extra-cflags="-I$HOME/ffmpeg_build/include" --extra-ldflags="-L$HOME/ffmpeg_build/lib" --bindir="$HOME/bin" \
--extra-libs=-ldl --enable-version3 --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libvpx --enable-libfaac \
--enable-libmp3lame --enable-libtheora --enable-libvorbis --enable-libx264 --enable-libvo-aacenc --enable-libxvid --disable-ffplay \
--enable-gpl --enable-postproc --enable-nonfree --enable-avfilter --enable-pthreads
sudo make
sudo make install

pip3 install --user opencv-python
