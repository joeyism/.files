# .files
My dot files

`configure.sh` yum installs git, then customizes to my liking

[`configure_general.sh`](https://raw.githubusercontent.com/joeyism/.files/master/configure_general.sh) yum installs tmux and git, then customizes to my liking

[`run.sh`](https://raw.githubusercontent.com/joeyism/.files/master/run.sh) adds the dot-files and configures vim, but doesn't install anything via yum nor apt

[`run_apt.sh`](https://raw.githubusercontent.com/joeyism/.files/master/run_apt.sh) like `run.sh` above, but apt installs some stuff

`add-swapfiles.sh` adds a swapfile for using, based on code from [here](https://www.cyberciti.biz/faq/linux-add-a-swap-file-howto/)

## Instances
These are scripts to run depending on what instances are spun up

[**instances/yum-python-instances.sh**](https://raw.githubusercontent.com/joeyism/.files/master/instances/yum-python-instances.sh)
* For instances that installs with yum (centos, rhel, ami, etc.)
* installs python35 and necessary tools
* sets up tmux and vim

[**instances/apt-python-instances.sh**](https://raw.githubusercontent.com/joeyism/.files/master/instances/apt-python-instances.sh)
* For instances that installs with apt (debian-based, ubuntu)
* Tested on Ubuntu 16.04 on AWS EC2
* Installs python35 and additional tools (pip, ipython, numpy, etc.)
* sets up tmux and vim

[**instances/apt-python-get-instances.sh**](https://raw.githubusercontent.com/joeyism/.files/master/instances/apt-python-get-instances.sh)
* For instances that installs with apt (debian-based, ubuntu)
* Tested on Ubuntu 16.04 on GCP Compute Engine
* Installs things around python3, but not python3 itself (pip3)
* sets up tmux and vim

[**instances/apt-opencv-python-instances-3.sh**](https://raw.githubusercontent.com/joeyism/.files/master/instances/apt-opencv-python-instances-3.sh)
* For instances that installs with apt (debian-based, ubuntu)
* Tested on Ubuntu 16.04 on AWS EC2
* Installs python35 and additional tools (pip, ipython, numpy, etc.)
* sets up tmux and vim
* sets up OpenCV
* Sets up ffmpeg

[**instances/apt-python-chrome-instances.sh**](https://raw.githubusercontent.com/joeyism/.files/master/instances/apt-python-chrome-instances.sh)
* For instances that installs with apt (debian-based, ubuntu)
* Tested on Ubuntu 16.04 on AWS EC2
* Installs python35 and additional tools (pip, ipython, numpy, etc.)
* sets up tmux and vim
* sets up Chrome for selenium

[**instances/apt-tf-python-instances.sh**](https://raw.githubusercontent.com/joeyism/.files/master/instances/apt-tf-python-instances.sh)
* For instances that installs with apt (debian-based, ubuntu)
* Tested on Ubuntu 16.04 on AWS EC2
* Installs python35 and additional tools (pip, ipython, numpy, etc.)
* sets up tmux and vim
* sets up [coco](https://github.com/waleedka/coco.git)
* sets up ffmpeg
* sets up TensorFlow CPU

[**instances/apt-tf-gpu-python-instances.sh**](https://raw.githubusercontent.com/joeyism/.files/master/instances/apt-tf-gpu-python-instances.sh)
* For instances that installs with apt (debian-based, ubuntu)
* Tested on Ubuntu 16.04 on AWS EC2
* Installs python35 tools, assuming python35 is already installed (pip, ipython, numpy, etc.)
* sets up tmux and vim
* sets up [coco](https://github.com/waleedka/coco.git)
* sets up ffmpeg
* sets up TensorFlow GPU CUDA9 without MKL

[**instances/apt-tf-gpu-python-instances-2.sh**](https://raw.githubusercontent.com/joeyism/.files/master/instances/apt-tf-gpu-python-instances-2.sh)
* For instances that installs with apt (debian-based, ubuntu)
* Tested on Ubuntu 16.04 on Google Cloud
* Installs gcc-6, make, etc.
* sets up my tmux and vim environment
* sets up TensorFlow GPU CUDA9 without MKL
* sets up CUDA raw (from tar)

[**instances/apt-tf-gpu-python-instances-3.sh**](https://raw.githubusercontent.com/joeyism/.files/master/instances/apt-tf-gpu-python-instances-3.sh)
* For instances that installs with apt (debian-based, ubuntu)
* Tested on Ubuntu 16.04 on Google Cloud
* Installs gcc-6, make, etc.
* sets up my tmux and vim environment
* sets up TensorFlow GPU CUDA9 without MKL
* sets up CUDA from deb (apt)

[**instances/apt-docker-instance.sh**](https://raw.githubusercontent.com/joeyism/.files/master/instances/apt-docker-instance.sh)
* For instances that installs with apt (debian-based, ubuntu)
* Installs docker

[**instances/yum-python-pyspark-instance.sh**](https://raw.githubusercontent.com/joeyism/.files/master/instances/yum-python-pyspark-instance.sh)
* For instances that installs with yum (centos, rhel, ami, etc.)
* Installs python35, java8, and pyspark

[**instances/apt-snippet-golang.sh**](https://raw.githubusercontent.com/joeyism/.files/master/instances/apt-snippet-golang.sh)
* Installs latest golang with apt
