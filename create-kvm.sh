#!/bin/bash 

################################
### Creator: Paul Ooi
### Email: paul@takizo.com 
### Description: A quick and easy script to create new kvm machine 
################################

IMGDIR=/opt/vm
KVMNAME=$1
IMGSIZE=$2 
MEMORYSIZE=$3 
ISOIMGNAME=$4 

if [ -z ${IMGSIZE} ]
then
	echo "Usage: create-vm.sh <name> <size> <memorysize> <isoimg>"
	exit 0 
fi 

if [ -z ${MEMORYSIZE} ]
then
	echo "Usage: create-vm.sh <name> <size> <memorysize> <isoimg>"
	exit 0
fi 

if [ -z ${KVMNAME} ]
then
	echo "Usage: create-vm.sh <name> <size> <memorysize> <isoimg>"
	exit 0
fi 

if [ -z ${ISOIMGNAME} ]
then
	echo "Usage: create-vm.sh <name> <size> <memorysize> <isoimg>"
	exit 0
fi 

KVMIMG=${IMGDIR}/${KVMNAME}.qcow2
ISOIMG=/opt/ISO/${ISOIMGNAME}

if [ -e ${KVMIMG} ]
then
	echo "sorry, disk image already exist"
	exit 0
fi

if [ ! -e ${ISOIMG} ]
then 
	echo 'sorry, ISO image not found'
	exit 0  
fi 

echo "Creating image.... "
qemu-img create -f qcow2 -o preallocation=metadata ${KVMIMG} ${IMGSIZE}G

CREATEIMGSTATUS=$?

if [ ${CREATEIMGSTATUS} != 0 ]
then 
	echo 'sorry image creation failed'
	exit 0 
fi 


virt-install -n ${KVMNAME} -r ${MEMORYSIZE} --os-variant=rhel6 --vcpus=1 -v -c ${ISOIMG} -w bridge:br0 --vnc --disk path=${KVMIMG},format=qcow2 --noautoconsole

CREATEVMSTATUS=$? 

if [ ${CREATEVMSTATUS} != 0 ]
then
        echo 'sorry KVM creation failed'
        exit 0
fi

echo 'Here is your VNC Display Port'
virsh vncdisplay ${KVMNAME}
