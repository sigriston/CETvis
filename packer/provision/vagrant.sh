#!/bin/sh

# Inspired by http://blog.codeship.io/2013/11/07/building-vagrant-machines-with-packer.html

# Provisioning commands that must be run as 'vagrant' user.

# Installing vagrant keys
mkdir ~/.ssh
chmod 700 ~/.ssh
cd ~/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys
chmod 600 ~/.ssh/authorized_keys
chown -R vagrant ~/.ssh
