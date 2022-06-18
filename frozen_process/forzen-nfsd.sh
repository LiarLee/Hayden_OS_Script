#!/bin/bash
#


# for forzen process nfsd into UNINTERRPTABLE status.
PID=`pgrep nfsd`

for i in $PID;
do
  echo $i > /sys/fs/cgroup/freezer/frozen/tasks
done
