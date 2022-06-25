#!/bin/bash
# Simple script that reads hardware resources information and logs to a file
while :
do
        mem_used=$(free -m | awk 'NR==2{printf "%s\n", $3 }')
        mem_all=$(free -m | awk 'NR==2{printf "%s\n", $2 }')

        disk_used=$(df -h | awk '$NF=="/"{printf "%d \n", $3}')
        disk_all=$(df -h | awk '$NF=="/"{printf "%d \n", $2}')

        cpu=$(top -bn1 | grep 'Cpu(s)' | sed 's/.*, *\([0-9.]*\)%* id.*/\1/' | awk '{print 100 - $1}')

        json_str='{"mem_used (MB)":%e, "mem_all (MB)":%e, "disk_used (GB)": %e, "disk_all (GB)":%e, "cpu_perc": %e }\n'
        json_injected="$(printf "$json_str" $mem_used $mem_all $disk_used $disk_all $cpu)"
        echo $json_injected | jq -c >> /var/log/hw_resources.log
        sleep 1
done
