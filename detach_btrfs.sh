#!/bin/bash
#

VOLUMEID=("vol-07abfef3a5c35421e vol-012188ec8861d788f vol-0621304b7c812979b vol-0629369e4fe5de38a")

INSTANCEID='i-086ade84a8bfb5feb'

# aws ec2 attach-volume --volume-id vol-07abfef3a5c35421e --instance-id i-086ade84a8bfb5feb --device /dev/sdf
# aws ec2 attach-volume --volume-id vol-012188ec8861d788f --instance-id i-086ade84a8bfb5feb --device /dev/sdg
# aws ec2 attach-volume --volume-id vol-0621304b7c812979b --instance-id i-086ade84a8bfb5feb --device /dev/sdh
# aws ec2 attach-volume --volume-id vol-0629369e4fe5de38a --instance-id i-086ade84a8bfb5feb --device /dev/sdi

for i in $VOLUMEID; do
 aws ec2 detach-volume --volume-id $i
 # echo $i
done
