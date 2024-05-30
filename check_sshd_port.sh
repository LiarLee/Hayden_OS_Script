#!/bin/bash
#

while true; do

    echo -en  "`date` \t"
    #  nc -vzw 1 52.81.82.79 22;
    ssh -i ~/.ssh/hayden-groupaccount-bjs.pem ec2-user@52.81.82.79 

done




echo "kernel.unknown_nmi_panic = 1" >> /etc/sysctl.conf

grubby --update-kernel=ALL --args="crashkernel=128M systemd.log_level=debug systemd.log_target=kmsg log_buf_len=20M loglevel=8"

yum install -y vim kexec-tools strace perf bpftrace bpftools

systemctl enable kdump

reboot 

