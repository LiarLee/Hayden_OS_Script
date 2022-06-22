#!/bin/bash
#

case $1 in
  clean ) 
    # Write 0 to 3 block ahead of disk.
    dd of=/dev/nvme1n1 if=/dev/zero bs=4096 count=3
    ;;

  w ) 
    # dd of=/dev/nvme1n1 if=/dev/urandom oflag=seek_bytes seek=10240 count=1 bs=8
    echo "Write first 8b ... "
    dd of=/dev/nvme1n1 if=/dev/urandom oflag=seek_bytes count=1 bs=8
    ;;
  show ) 
    echo "Dump 2048b ... "
    hexdump -C -n 2048 /dev/nvme1n1
    ;;
  * ) echo 输入不符合要求
esac
