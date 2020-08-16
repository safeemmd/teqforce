#!/bin/bash

sudo yum install java-1.8.0 -y
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
sudo yum install jenkins-2.235.4-1.1 -y

sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum -y install xmlstarlet

sudo yum install -y python2-pip
sudo pip2 install bcrypt

sudo yum install -y nc