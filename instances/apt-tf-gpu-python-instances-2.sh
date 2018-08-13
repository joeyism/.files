export python_version=35

wget https://raw.githubusercontent.com/joeyism/.files/master/run_apt.sh
bash run_apt.sh
rm run_apt.sh

sudo apt -y install gcc make python3-pip build-essential libelf-dev
wget https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux-run
sudo sh cuda_9.0.176_384.81_linux-run --override
sudo pip3 install https://github.com/mind/wheels/releases/download/tf1.7-gpu-nomkl/tensorflow-1.7.0-cp${python_version}-cp${python_version}m-linux_x86_64.whl
