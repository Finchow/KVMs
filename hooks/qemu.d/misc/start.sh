#!/bin/bash
# Helpful to read output when debugging
set -x

systemctl isolate multi-user.target
systemctl stop display-manager.service
killall gdm-wayland-session

sleep 3

echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind

echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

sleep 5

modprobe -r amdgpu snd_hda_intel

# Unbind the GPU from display driver
virsh nodedev-detach pci_0000_03_00_0
virsh nodedev-detach pci_0000_03_00_1

# Load VFIO Kernel Module  
modprobe vfio-pci  
