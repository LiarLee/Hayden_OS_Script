#!/bin/bash
#
# This is for test the ingres controller and use the client to curl the elb address.

while true;
do
  curl --connect-timeout 0.5 http://k8s-istiosys-istioing-70e14f892f-fc1139a735d6d8f9.elb.cn-north-1.amazonaws.com.cn:30080/ 2>&1 >> /dev/null
done
