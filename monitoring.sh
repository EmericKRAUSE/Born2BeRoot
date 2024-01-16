#!/usr/bin/bash

arch="$(uname -a)"
pcpu=$(grep 'physical id' /proc/cpuinfo | sort | uniq | wc -l)
vcpu=$(grep '^processor' /proc/cpuinfo | wc -l)
uram=$(free -m | grep 'Mem' | awk '{print $3}')
tram=$(free -m | grep 'Mem' | awk '{printf $2}')
pram=$(free -m | grep 'Mem' | awk '{printf "%.2f", $3 * 100 / $2}')
udisk=$(df -h --total --output=used | awk 'END{print$NF}')
tdisk=$(df -h --total --output=size| awk 'END{print$NF}')
pdisk=$(df -h --total | awk 'END{print$(NF - 1)}')
cpul=$(top -bn1 | grep '^%Cpu' | awk '{print $2}')
lb="$(who -b | awk '{print $3, $4}')"
lvml="$(lsblk | grep 'lvm' | wc -l)"
lvm="$(if [ $lvml -eq 0 ]; then echo "no"; else echo "yes"; fi)"
ctcp="$(ss -t -a | grep 'ESTAB' | wc -l)"
ulog="$(users | wc -w)"
ip="$(hostname -I | awk '{print $1}')"
mac="$(ip link | grep 'ether' | awk '{print $2}' | head -n 1)"
sudo="$(grep 'COMMAND=' /var/log/sudo/sudo.log | wc -l)"

wall "
    #Architecture: $arch
    #CPU physical: $pcpu
    #vCPU: $vcpu
    #Memory Usage: ${uram}/${tram}MB ($pram%)
    #Disk Usage: $udisk/$tdisk ($pdisk)
    #CPU load: $cpul%
    #Last boot: $lb
    #LVM use: $lvm
    #Connexions TCP: $ctcp ESTABLISHED
    #User log: $ulog
    #Network: IP $ip ($mac)
    #Sudo: $sudo cmd
"