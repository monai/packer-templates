#!/bin/bash

set -e

# Update and upgrade dependencies
apt-get update -y -qq > /dev/null
apt-get upgrade -y -qq > /dev/null
apt-get autoremove -y -qq > /dev/null

# Install necessary libraries for guest additions and Vagrant NFS Share
apt-get -y -qq install build-essential dkms nfs-common > /dev/null

# NOPASSWD sudo for group "admin"
groupadd -r admin
usermod -a -G admin vagrant
cp /etc/sudoers /etc/sudoers.back
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=admin' /etc/sudoers
sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers

# Install Puppet
apt-get -y -qq install puppet > /dev/null

# Install Guest Additions
VERSION="$(cat .vbox_version)"
MPOINT="/mnt/cdrom"
mkdir -p $MPOINT
mount -o loop VBoxGuestAdditions_${VERSION}.iso $MPOINT
# Suppress "Could not find the X.Org or XFree86 Window System, skipping."
sh ${MPOINT}/VBoxLinuxAdditions.run 2>&1 > /dev/null || true
umount $MPOINT
rm -rf $MPOINT
