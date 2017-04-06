#!/bin/bash

LOGFILE=/tmp/install.log

init() {
#########################################
#Sourcing the Install Config Parameters##
#########################################

source install.conf

########################
#Check for Ansible Home#
########################

if [ ! -d $ANSIBLE_INSTALL_DIR ]; then
	echo "Error - Ansible Installation directory does not exist.. Exiting"
	exit -1
else
	cd $ANSIBLE_INSTALL_DIR 
	mkdir $ANSIBLE_HOME 
fi

}
cleanup(){

###############################
#Remove any pre-existing files#
###############################

if [ -f ansible*.tar.gz ]; then
	rm -rf ansible*.tar.gz 
fi

}

pre-req() {

#######################################################
#Construct Ansible URL using Ansible Install Variables
#######################################################
 
ANSIBLE_URL=$ANSIBLE_SOURCE"ansible-"$ANSIBLE_VERSION".tar.gz"

echo "Ansible Download URL - "$ANSIBLE_URL  
wget $ANSIBLE_URL 

tar -zxvf ansible*.tar.gz -C $ANSIBLE_HOME --strip-components=1

}


main() {

################################
# Identify the OS Distribution
################################

if [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    OS=$DISTRIB_ID
elif [ -f /etc/redhat-release ]; then
	OS=`cat /etc/redhat-release | awk -F " " '{print $1}'`
else [ -f /etc/os-release ] 
	. /etc/os-release
	OS=$NAME
fi


case $OS in 
  "Ubuntu")
	echo "OS is - "$OS
	sudo apt-get update 	
	sudo apt-get install libffi6
	sudo apt-get install libffi-dev
	sudo apt-get install libssl-dev
	sudo apt-get install python-dev
    sudo apt-get install python-setuptools
;;
  "CentOS")	
 	echo "OS is - "$OS	
	sudo yum update 
	sudo yum install gcc
	sudo yum install python-devel
	sudo yum install python-setuptools
;;
  "Amazon Linux AMI")
	echo "OS is - "$OS
	sudo yum update
	sudo yum install gcc
	sudo yum install python-devel
	sudo yum install python-setuptools
esac

#Install Ansible
cd $ANSIBLE_INSTALL_DIR/ansible
python setup.py install 

}

#########################################
# Main Execution Block
########################################

echo "Starting ansible installation  for `date`" >> "$LOGFILE"

echo "Intializing the Install" >> "$LOGFILE"
init

echo "Begin Cleanup Activities" >> "$LOGFILE"
cleanup

echo "Prepping for the Install" >> "$LOGFILE"
pre-req

echo "Begin Installation" >> "$LOGFILE"
main


