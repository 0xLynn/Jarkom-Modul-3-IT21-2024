echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update
apt-get install bind9 -y 

echo ' 
zone "atreides.it21.com" {
    type master;
    file "/etc/bind/sites/atreides.it21.com";
};

zone "harkonen.it21.com" {
    type master;
    file "/etc/bind/sites/harkonen.it21.com";
};
' > /etc/bind/named.conf.local

rm -rf /etc/bind/sites
mkdir /etc/bind/sites
cp /etc/bind/db.local /etc/bind/sites/atreides.it21.com
cp /etc/bind/db.local /etc/bind/sites/harkonen.it21.com

echo '
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     atreides.it21.com. root.atreides.it21.com. (
                            2           ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      atreides.it21.com.
@       IN      A       10.74.4.2       ; IP LB Stilgar
www     IN      CNAME   atreides.it21.com.' > /etc/bind/sites/atreides.it21.com

echo '
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     harkonen.it21.com. root.harkonen.it21.com. (
                           3            ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      harkonen.it21.com.
@       IN      A       10.74.4.2       ; IP LB Stilgar
www     IN      CNAME   harkonen.it21.com.' > /etc/bind/sites/harkonen.it21.com

echo 'options {
      directory "/var/cache/bind";

      forwarders {
              192.168.122.1;
      };

      allow-query{any;};
      auth-nxdomain no;
      listen-on-v6 { any; };
}; ' >/etc/bind/named.conf.options

service bind9 restart