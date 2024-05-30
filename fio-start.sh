#!/bin/bash
#

fio --directory=/mnt --name fio_test_file --ioengine=libaio --direct=1 --rw=read --rate_iops=3000 --bs=16k --size=1G --iodepth=1 --numjobs=1 --time_based --runtime=600 --group_reporting --norandommap
