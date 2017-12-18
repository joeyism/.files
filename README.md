# .files
My dot files

`configure_*` can be run in new yum-based instances, to configure it to my liking.

`configure.sh` is without tmux

`configure_general.sh` is with tmux

`run.sh` adds the dot-files and configures vim, but doesn't install anything via yum nor apt

## Instances
These are scripts to run depending on what instances are spun up

(**instances/yum-python-instances.sh**)[https://raw.githubusercontent.com/joeyism/.files/master/instances/yum-python-instances.sh]
* For instances that installs with yum (centos, rhel, ami, etc.)
* installs python35 and necessary tools
* sets up tmux and vim

(**instances/apt-opencv-python-instances-3.sh**)[https://raw.githubusercontent.com/joeyism/.files/master/instances/apt-opencv-python-instances-3.sh]
* For instances that installs with apt (debian-based, ubuntu)
* Installs python35 and additional tools (pip, ipython, numpy, etc.)
* sets up tmux and vim
* sets up OpenCV
* Sets up ffmpeg
