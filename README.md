# .files
My dot files

`configure_*` can be run in new yum-based instances, to configure it to my liking.

`configure.sh` is without tmux

`configure_general.sh` is with tmux

`run.sh` adds the dot-files and configures vim, but doesn't install anything via yum nor apt

## Instances
These are scripts to run depending on what instances are spun up

**instances/yum-python-instances.sh**
* For instances that installs with yum (centos, rhel, ami, etc.)
* installs python35 and necessary tools
* sets up tmux and vim
