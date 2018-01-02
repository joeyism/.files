# .files
My dot files

`configure.sh` yum installs git, then customizes to my liking

`configure_general.sh` yum installs tmux and git, then customizes to my liking

`run.sh` adds the dot-files and configures vim, but doesn't install anything via yum nor apt

`add-swapfiles.sh` adds a swapfile for using, based on code from [here](https://www.cyberciti.biz/faq/linux-add-a-swap-file-howto/)

## Instances
These are scripts to run depending on what instances are spun up

[**instances/yum-python-instances.sh**](https://raw.githubusercontent.com/joeyism/.files/master/instances/yum-python-instances.sh)
* For instances that installs with yum (centos, rhel, ami, etc.)
* installs python35 and necessary tools
* sets up tmux and vim

[**instances/apt-opencv-python-instances-3.sh**](https://raw.githubusercontent.com/joeyism/.files/master/instances/apt-opencv-python-instances-3.sh)
* For instances that installs with apt (debian-based, ubuntu)
* Tested on Ubuntu 16.04 on AWS EC2
* Installs python35 and additional tools (pip, ipython, numpy, etc.)
* sets up tmux and vim
* sets up OpenCV
* Sets up ffmpeg
