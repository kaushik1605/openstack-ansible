#!/bin/bash
###################################################
# Wrapper script to Install Ansible and Openstack
###################################################

# Updating Repositories

sudo apt-get update

#Clone openstack ansible code base
cd /tmp

git clone https://github.com/kaushik1605/openstack-ansible.git

# Initiate install of Ansible on Ubuntu machine

cd /tmp/openstack-ansible/scripts

./install.sh

# Run Ansible playbook to install Openstack

cd ../playbooks

ansible-playbook -i "localhost," -c local install_openstack_neutron.yml
