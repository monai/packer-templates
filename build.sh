#!/bin/sh

set -e

#export PACKER_LOG=1

NAME='trusty64'
TYPE="virtualbox-iso"

rm -f packer_${TYPE}_virtualbox.box
rm -rf output-${TYPE}
packer build -only $TYPE trusty64.json
mv packer_${TYPE}_virtualbox.box ${NAME}.box
vagrant box remove $NAME || true
vagrant box add $NAME ${NAME}.box
