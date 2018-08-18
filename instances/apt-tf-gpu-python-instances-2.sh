export python_version=35

# My stuff
wget https://raw.githubusercontent.com/joeyism/.files/master/run_apt.sh
bash run_apt.sh
rm run_apt.sh

# Install dependencies (gcc-6, g++-6, etc.)
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
sudo apt -y update
sudo apt -y install gcc-6 make python3-pip build-essential libelf-dev g++-6 nvidia-384 nvidia-modprobe


# Let gcc to be gcc-6
sudo rm /usr/bin/gcc /usr/bin/gcc-ar /usr/bin/gcc-nm /usr/bin/gcc-ranlib
sudo ln -s /usr/bin/gcc-6 /usr/bin/gcc
sudo ln -s /usr/bin/gcc-ar-6 /usr/bin/gcc-ar
sudo ln -s /usr/bin/gcc-nm-6 /usr/bin/gcc-nm
sudo ln -s /usr/bin/gcc-ranlib-6 /usr/bin/gcc-ranlib
sudo ln -s /usr/bin/g++-6 /usr/bin/g++

# Install CUDA
wget https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux-run
sudo bash cuda_9.0.176_384.81_linux-run
sudo bash cuda_9.0.176_384.81_linux-run --override --extract=$HOME
sudo bash cuda-linux.9.0.176-22781540.run
sudo bash NVIDIA-Linux-x86_64-384.81.run
sudo pip3 install https://github.com/mind/wheels/releases/download/tf1.7-gpu-nomkl/tensorflow-1.7.0-cp${python_version}-cp${python_version}m-linux_x86_64.whl

# Add path stuff
echo 'export CUDA_HOME=/usr/local/cuda-9.0' >> ~/.bashrc
echo 'export PATH="$PATH:/usr/local/cuda-9.0/bin"' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH="/usr/local/cuda-9.0/lib64"' >> ~/.bashc
source ~/.bashrc

# Clean up
rm -f cuda_9.0.176_384.81_linux-run cuda-samples.9.0.176-22781540-linux.run cuda-linux.9.0.176-22781540.run NVIDIA-Linux-x86_64-384.81.run

# Remind to install cudnn
echo "Go to https://developer.nvidia.com/cudnn and download and install cuDNN v7.0.5 (Dec 5, 2017), for CUDA 9.0"
