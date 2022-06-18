#!/bin/bash
 
CPUS=`cat /proc/cpuinfo| grep "processor"| wc -l`
RPS_LOW_BIT="ffffffff"
RFS_MAX="32768"
is_start_irqbalance=0
SYSTEM=`rpm -q centos-release|cut -d- -f3`
 
#根据CPU数确定 RPS设置的CPU掩码
if [ $CPUS  -ge 32 ];then
    RPS_LOW_BIT="ffffffff"         #经测验，命令行方式设置RPS最大支持32的。32位以上机器需要确认一下是否需要手动设置RPS
else
    num=$(((1<<$CPUS)-1))          #根据CPUS计算CPU掩码 十进制 CPUS超过64无法计算
    RPS_LOW_BIT=$(printf %x $num)  #转换为十六进制
fi
 
 
# check for irqbalance running
IRQBALANCE_ON=`ps ax | grep -v grep | grep -q irqbalance; echo $?`
if [ "$IRQBALANCE_ON" == "0" ];then
        systemctl stop irqbalance
fi
 
 
#设置网卡多队列、接受queuei的开启数为当前机器支持的最大数
function set_multiple_queues(){
    dev=$1
    checks=('RX' 'TX' 'Other' 'Combined')
    for check in ${checks[@]}
    do
        pre_num=`ethtool -l ${dev}|grep "${check}"|sed -n 1p|grep -Eo '([0-9]+)' 2>/dev/null`
        cur_num=`ethtool -l ${dev}|grep "${check}"|sed -n 2p|grep -Eo '([0-9]+)' 2>/dev/null`
        if [ $cur_num -eq $CPUS ];then
           echo "Dev:${dev} $check 等于当前CPU数 不设置" 
           continue
        fi
        set_num=$((pre_num>CPUS?CPUS:pre_num)) #处理队列数>CPU数
        set_mode=`echo $check|tr 'A-Z' 'a-z'`
        if [ $pre_num -ne $cur_num ];then
            ethtool -L ${dev} ${set_mode} ${set_num}
            if [ $? -eq 0 ];then
                echo -e "Dev:${dev} ${set_mode} ${set_num} 设置成功\n 'ethtool -L ${dev} ${set_mode} ${set_num}'"
            else
                echo -e "Dev:${dev} ${set_mode} ${set_num} 设置失败\n 'ethtool -L ${dev} ${set_mode} ${set_num}'"
            fi
            ethtool -l ${dev}
        else
            echo "Dev:${dev} $check 当前开启的多队列数和允许队列数一致 不设置"
        fi
    done
 
    pre_rx_queues=`ethtool -g ${dev}|grep "RX:"|sed -n 1p|grep -Eo '([0-9]+)' 2>/dev/null`
    cur_rx_queues=`ethtool -g ${dev}|grep "RX:"|sed -n 2p|grep -Eo '([0-9]+)' 2>/dev/null`
    set_rx_num=$((pre_rx_queues>=cur_rx_queues ?pre_rx_queues:cur_rx_queues))
    echo "设置 Dev:${dev} Rx queue"
    if [ $pre_rx_queues -ne $cur_rx_queues ];then
         ethtool -G ${dev} rx $set_rx_num
         if [ $? -eq 0 ];then
             echo -e "Dev:${dev} RX queue ${set_rx_num} 设置成功\n 'ethtool -G ${dev} rx $set_rx_num'"
         else
             echo -e "Dev:${dev} RX queue ${set_rx_num} 设置失败\n 'ethtool -G ${dev} rx $set_rx_num'"
         fi
     else
         echo -e "Dev:${dev} RX queue ${set_rx_num} 已经最大 不设置"
     fi    
}
 
 
#设置网卡的RPS、RFS属性 --- 软中断 cat /proc/softirqs
function set_rps_and_rfs()
{  
    # $1 dev $2 irq_nums
    dev=$1
    irq_num=$(($2!=0 ? $2:$CPUS)) #处理无硬件中断，但支持多队列属性的网卡
    irqs=`expr $irq_num - 1`
    rfs_num=`expr $RFS_MAX / $irq_num` #这里取irq_nums的主要目的是为了处理队列数>CPU数的问题
    echo $RFS_MAX > /proc/sys/net/core/rps_sock_flow_entries
    printf "%s %s %s %s\n" "Dev:$dev" "$RFS_MAX" "to" "/proc/sys/net/core/rps_sock_flow_entries"
    for i in `seq 0 $irqs`
    do
        rps_file="/sys/class/net/$dev/queues/rx-$i/rps_cpus"
        rfs_file="/sys/class/net/$dev/queues/rx-$i/rps_flow_cnt"
        echo $RPS_LOW_BIT > $rps_file
        echo $rfs_num > $rfs_file
        printf "%s %s %s %s\n" "Dev:$dev" "$RPS_LOW_BIT" "to" "$rps_file"
        printf "%s %s %s %s\n" "Dev:$dev" "$rfs_num" "to" "$rfs_file"
    done
}
 
net_devs=`ls /sys/class/net/|grep -v 'lo|bond'`
 
for dev in `echo $net_devs`
do
    ifconfig |grep $dev >>/dev/null
    if [ $? -eq 0 ];then #只针启用的网卡设置多队列属性
         echo "1、设置Dev:$dev 的多队列数值"
         ethtool -l ${dev} >>/dev/null 2>&1
         if [ $? -eq 0 ];then
             set_multiple_queues ${dev}
         else
             echo "Dev:$dev 不支持ethtool查看多队列"
         fi
    else
        echo "Dev:${dev} 未启用 不设置"
        continue
    fi
    echo "2、设置Dev:${dev} RSS属性"
    irq_nums=`grep "${dev}-" /proc/interrupts|wc -l`
    if [ $irq_nums -eq 0 ];then
       echo "Dev:${dev} 不支持RSS属性 不设置"
       let is_start_irqbalance=$is_start_irqbalance+1
    fi
    set_cpu=0
    for devseq in `grep "${dev}-" /proc/interrupts |awk '{print $1}'|sed -e 's/://g'`
    do
        #设置网卡的RSS属性(硬中断),实现队列和cpu一一绑定，如果队列数小于cpu数，则绑定前面的几核
        echo $set_cpu >/proc/irq/${devseq}/smp_affinity_list
        #设置cpu亲和性，smp_affinity_list支持十进制,smp_affinity需要CPU 掩码设置。修改smp_affinity_list成功会改变smp_affinity
        printf "%s %s %s %s\n" "设置Dev:$dev RSs亲和性" "$set_cpu" "for" "/proc/irq/${devseq}/smp_affinity_list"
        let set_cpu=$set_cpu+1
        let is_start_irqbalance=$is_start_irqbalance-10 #如果有一个支持则不开启irqbanlance
    done
    echo "3、设置Dev:${dev} RPS、RFS属性"
    set_rps_and_rfs $dev $irq_nums
done
 
if [ ${is_start_irqbalance} -gt 0 ];then
    echo "4、执行托底操作开启irqbanlance"
    #is_start_irqbalance 如果此参数大于0，表明所有支持多队列的网卡都无法通过`grep "${dev}-" /proc/interrupts`获取到硬件中断信息，目前解决方式是开启irqbanlance服务
    yum install -y irqbalance >/dev/null
    if [ "$SYSTEM" == "6" ];then
        /etc/init.d/irqbalance start
    elif [ "$SYSTEM" == "7" ];then
        systemctl start irqbalance
    else
        echo "系统版本获取错误,请检查" && exit 1
    fi
    IRQBALANCE_ON=`ps ax | grep -v grep | grep -q irqbalance; echo $?`
    if [ "$IRQBALANCE_ON" -eq "0" ];then
        echo "托底操作 irqbalance 开启服务 成功"
    else
        echo "托底操作 irqbalance 开启服务 失败"
    fi  
else
    echo "4、无需执行托底操作"
fi
