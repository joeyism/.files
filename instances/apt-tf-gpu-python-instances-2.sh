export python_version=35

wget https://raw.githubusercontent.com/joeyism/.files/master/run_apt.sh
bash run_apt.sh
rm run_apt.sh

sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test

sudo apt -y install gcc-6 make python3-pip build-essential libelf-dev

# Let gcc to be gcc-6
sudo ln -s /usr/bin/gcc-6 /usr/bin/gcc
sudo ln -s /usr/bin/gcc-ar-6 /usr/bin/gcc-ar
sudo ln -s /usr/bin/gcc-nm-6 /usr/bin/gcc-nm
sudo ln -s /usr/bin/gcc-ranlib-6 /usr/bin/gcc-ranlib

wget https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux-run
sudo sh cuda_9.0.176_384.81_linux-run --override
sudo pip3 install https://github.com/mind/wheels/releases/download/tf1.7-gpu-nomkl/tensorflow-1.7.0-cp${python_version}-cp${python_version}m-linux_x86_64.whl
