#!/bin/bash
# 

echo f > /sys/class/net/eth0/queues/rx-0/rps_cpus
echo f > /sys/class/net/eth0/queues/rx-1/rps_cpus
echo f > /sys/class/net/eth0/queues/rx-2/rps_cpus
echo f > /sys/class/net/eth0/queues/rx-3/rps_cpus



