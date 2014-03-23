#!/bin/sh

# Inspired by http://blog.codeship.io/2013/11/07/building-vagrant-machines-with-packer.html

# Updating and Upgrading dependencies
apt-get update -y
apt-get upgrade -y
apt-get install -y linux-headers-$(uname -r) build-essential perl
apt-get install -y dkms
apt-get autoremove -y
apt-get clean -y

# Setup sudo to allow no-password sudo for "admin"
groupadd -r admin
usermod -a -G admin vagrant
cp /etc/sudoers /etc/sudoers.orig
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=admin' /etc/sudoers
sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers

# Install the VirtualBox guest additions
mkdir /mnt/VBoxGuestAdditions
mount /home/vagrant/VBoxGuestAdditions.iso /mnt/VBoxGuestAdditions
sh /mnt/VBoxGuestAdditions/VBoxLinuxAdditions.run

# Remove VirtualBox ISO
umount /mnt/VBoxGuestAdditions
rmdir /mnt/VBoxGuestAdditions
rm /home/vagrant/VBoxGuestAdditions.iso

# Zero out free space to save space in the final image
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
