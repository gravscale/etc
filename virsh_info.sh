#!/bin/bash


# show stats about vms

sizeTotal=0
vmsTotal=0
ramTotal=0
vcpuTotal=0

for vm in $(virsh list | tail -n +3 | head -n -1 | awk '{ print $2}'); do
  for disk in $(virsh dumpxml $vm | grep "/dev/mapper/"  | awk -F"'" '{print $2}'); do
    #echo $disk
    size=$(fdisk -l $disk | grep "Disk /" | awk '{ print $5 }')
    let "sizeTotal+=size"

  done;

  let "vmsTotal+=1"

  ram=$(virsh dumpxml $vm | grep currentMemory | awk -F">" '{print $2}' | awk -F"<" '{print $1}')
  let "ramTotal += ram"

  vcpu=$(virsh dumpxml $vm | grep vcpu | awk -F">" '{print $2}' | awk -F"<" '{print $1'})
  let "vcpuTotal += vcpu"

done; 

let "sizeTotal = sizeTotal / 1024 / 1024 / 1024"
let "ramTotal = ramTotal / 1024 / 1024"



echo "Volumes: $sizeTotal GB"
echo "vms: $vmsTotal"
echo "RAM: $ramTotal"
echo "VCPU: $vcpuTotal"
