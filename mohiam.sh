echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update
apt-get install isc-dhcp-server -y


echo ' 
INTERFACESv4="eth0"
INTERFACESv6=""
' > /etc/default/isc-dhcp-server

echo '
option domain-name "example.org";
option domain-name-servers ns1.example.org, ns2.example.org;

ddns-update-style none;

subnet 10.74.1.0 netmask 255.255.255.0 {
    range 10.74.1.14 10.74.1.28;
    range 10.74.1.49 10.74.1.70;
    option routers 10.74.1.0;
    option broadcast-address 10.74.1.255;
    option domain-name-servers 10.74.3.2;
    default-lease-time 300; # 5 menit
    max-lease-time 5220;     # 87 menit
}

subnet 10.74.2.0 netmask 255.255.255.0 {
    range 10.74.2.15 10.74.2.25;
    range 10.74.2.200 10.74.2.210;
    option routers 10.74.2.0;
    option broadcast-address 10.74.2.255;
    option domain-name-servers 10.74.3.2;
    default-lease-time 1200; # 20 menit
    max-lease-time 5220;     # 87 menit
}

subnet 10.74.3.0 netmask 255.255.255.0 {
}

subnet 10.74.4.0 netmask 255.255.255.0 {
}
' > /etc/dhcp/dhcpd.conf

rm /var/run/dhcpd.pid
service isc-dhcp-server start