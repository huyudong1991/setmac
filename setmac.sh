#!/bin/bash
while true; do
for ((i=1;i<=10;++i));do
echo -e "\033[40;37mattempt:$i\033[0m"

#ipnow=$(curl -s http://members.3322.org/dyndns/getip)
ipnow=`LANG=C ifconfig enp3s0 | grep 'inet' | awk -F'[ :]+' '{print $3 }'  | awk 'gsub(/^ *| *$/,"")'`
echo '目前的ip：'$ipnow

#设置新mac
newmac="00:"$(od /dev/urandom -w5 -tx1 -An|sed -e 's/ //' -e 's/ /:/g'|head -n 1)


#重启网卡
cd /etc/sysconfig/network-scripts
cat <<EOF> ifcfg-enp3s0
MACADDR=$newmac
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=dhcp
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=enp3s0
UUID=b76d7132-3817-45c2-b9b2-47819adde888
DEVICE=enp3s0
ONBOOT=yes
EOF
echo "Changing Mac and Restart Network"
service network restart >/dev/null 2>&1
echo "Getting ip ..."
sleep 10

#macnow=$(cat /sys/class/net/enp3s0/address )
#echo '目前的mac:'$macnow
ipnew=`LANG=C ifconfig enp3s0 | grep 'inet' | awk -F'[ :]+' '{print $3 }'  | awk 'gsub(/^ *| *$/,"")'`
echo -e "\033[43;34mnewip：$ipnew\033[0m"

echo 'Update ip data'


#curl --connect-timeout 10 -s "https://your domin name/hkt?ip=$ipnew&cishu=$i" #用于接受新ip信息
sleep 2


# declare ip
IFS=. DIRS=($ipnew)
declare -p DIRS >/dev/null 2>&1

if [ $DIRS == 112 ]
then
echo "Checking rules not fit:"$DIRS
else
echo "Checking rules fit:"$DIRS
echo "Program pause for 2h."
sleep 7200
fi

#echo $DIRS;
echo "--------------------"
done
echo "Program pause for 5min."
sleep 300
done
