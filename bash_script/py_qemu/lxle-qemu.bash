#!/bin/bash
sudo apt-get update
FILE1=/home/zero/qemu-scripts/lxle.img
FILE2=lxle-18043-64.iso
# creates a virtual disk for lxle if there is not one
if [ ! -f "$FILE1" ]
then
    echo "Going to create a lxle virt-disk & download kali iso"
    qemu-img create -f raw lxle.img 20G 
else
    echo "files exists"
fi
# downloads lxle.iso if it does not exist in current directory.
if [ ! -f "$FILE2" ]
then
wget https://sourceforge.net/projects/lxle/files/Final/OS/18.04.3-64/lxle-18043-64.iso
else
    echo "lxle downloaded"
fi
# starts qemu with the iso if it is not installed or starts the vm.
if qemu-img info lxle.img | grep -i "disk size: 4 KiB"
then
    qemu-system-x86_64 -hda lxle.img -boot d \
    -cdrom lxle-18043-64.iso  -m 4096M -cpu host \
    -smp 2 -enable-kvm 
    echo "vm creation successfully completed"
else
    kvm -hda lxle.img -boot d \
    -m 4096M -cpu host \
    -smp 2 -spice port=3001,disable-ticketing=on \
    -vga qxl -enable-kvm 
    echo "starting lxle"
fi 
