#!/bin/bash
# 

bpftrace -e 'kfunc:io_schedule { @[comm] = count(); }'
