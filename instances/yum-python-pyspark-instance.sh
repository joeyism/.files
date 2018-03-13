sudo yum update -y

sudo systemclt stop firewall-cmd
sudo setenforce 0

# Python
sudo yum install -y gcc
sudo yum install -y python35 htop
sudo yum install -y python35-setuptools
sudo yum install -y python35-devel

sudo easy_install-3.5 pip
sudo cp /usr/local/bin/pip3 /usr/sbin/
pip3 install --user ipython

# Java8
sudo yum install -y java-1.8.0-openjdk
sudo yum remove -y java-1.7.0-openjdk

# Spark
cd /opt
sudo wget http://www-eu.apache.org/dist/spark/spark-2.2.1/spark-2.2.1-bin-hadoop2.7.tgz
sudo tar -xzf spark-2.2.1-bin-hadoop2.7.tgz
sudo ln -s /opt/spark-2.2.1-bin-hadoop2.7 /opt/spark

export PYSPARK_PYTHON=python3 
export PYSPARK_DRIVER_PYTHON=ipython 
export SPARK_HOME=/opt/spark
export PATH=$SPARK_HOME/bin:$PATH




# Customize
cd ~
wget https://raw.githubusercontent.com/joeyism/.files/master/configure_general.sh
bash configure_general.sh
rm configure_general.sh
printf '\nexport SPARK_HOME=/opt/spark\nexport PATH=$SPARK_HOME/bin:$PATH\nPYSPARK_PYTHON=python3\nPYSPARK_DRIVER_PYTHON=ipython\n' >> ~/.bashrc
