#!/bin/bash
# from https://stackoverflow.com/questions/8087184/problems-installing-python3-on-rhel
wget https://www.python.org/ftp/python/3.4.3/Python-3.4.3.tar.xz
tar xf Python-3.*
cd Python-3.*
./configure
make
make install
