#!/bin/bash
#

curl -o /dev/null -v http://nginx.liarlee.site/Fedora-Workstation-Live-x86_64-38_Beta-1.3.iso -t -s -w "time_connect: %{time_connect}\ntime_starttransfer: %{time_starttransfer}\ntime_total: %{time_total}\n"
