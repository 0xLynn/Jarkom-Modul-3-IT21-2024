iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.74.0.0/16
apt-get update 
apt install isc-dhcp-relay -y

echo '
SERVERS="10.74.3.1"

INTERFACES="eth1 eth2 eth3 eth4"

OPTIONS=""
' > /etc/default/isc-dhcp-relay

service isc-dhcp-relay start 

echo 'net.ipv4.ip_forward=1' > /etc/sysctl.conf