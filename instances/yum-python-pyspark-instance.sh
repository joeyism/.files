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

# Spark
cd /opt
wget http://www-eu.apache.org/dist/spark/spark-2.2.1/spark-2.2.1-bin-hadoop2.7.tgz
tar -xzf spark-2.2.1-bin-hadoop2.7.tgz
ln -s /opt/spark-2.2.1-bin-hadoop2.7 /opt/spark

export PYSPARK_PYTHON=python3 
export PYSPARK_DRIVER_PYTHON=ipython 
export PYSPARK_DRIVER_PYTHON_OPTS="notebook" 
export SPARK_HOME=/opt/spark
export PATH=$SPARK_HOME/bin:$PATH




# Customize
wget https://raw.githubusercontent.com/joeyism/.files/master/configure_general.sh
bash configure_general.sh
rm configure_general.sh
printf '\nexport SPARK_HOME=/opt/spark\nexport PATH=$SPARK_HOME/bin:$PATHPYSPARK_PYTHON=python3\nPYSPARK_DRIVER_PYTHON=ipython\nPYSPARK_DRIVER_PYTHON_OPTS="notebook"' >> ~/.bash_rc
