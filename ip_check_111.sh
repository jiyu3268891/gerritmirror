#!/bin/bash
ip112=`cat /var/lib/dhcpd/dhcpd.leases | grep ^l | sort -u | sed 's/{//g' | grep "10.20.112" | wc -l`
ip113=`cat /var/lib/dhcpd/dhcpd.leases | grep ^l | sort -u | sed 's/{//g' | grep "10.20.113" | wc -l`
ip115=`cat /var/lib/dhcpd/dhcpd.leases | grep ^l | sort -u | sed 's/{//g' | grep "10.20.113" | wc -l`
network1=10.20.112
network2=10.20.113
network3=10.20.115
cd /work
rm -rf 1.txt 
touch 1.txt 
if [ $ip112 -gt 180 ]
 then
 for i in `seq 10 254`
 do
 ping -c1 $network1.$i
 if [[ $? -eq 0 ]]
  then
 echo "range dynamic-bootp $network1.$i $network1.$i;">>1.txt 
 fi
 done
fi

rm -rf dhcpdconfbak
cd /etc/dhcp
mv dhcpd.conf dhcpdconfbak
cp dhcpd112bak dhcpd.conf
echo "subnet 10.20.112.0 netmask 255.255.255.0{
        default-lease-time 28800;
        max-lease-time 28800;">>/etc/dhcp/dhcpd.conf
    cat /work/1.txt >>/etc/dhcp/dhcpd.conf

echo "
       option broadcast-address 10.20.112.255;
       option routers 10.20.112.1;
}">>/etc/dhcp/dhcpd.conf

service dhcpd restart
rm -rf dhcpd.conf
mv dhcpdconfbak dhcpd.conf
service dhcpd restart