echo 'nameserver 10.74.3.2' > /etc/resolv.conf
apt-get update
apt-get install -y wget
apt-get install -y unzip
apt-get install -y apache2
apt-get install apache2-utils -y
apt-get install -y php
apt-get install libapache2-mod-php7.3 -y
apt-get install lynx -y

service apache2 restart

wget --no-check-certificate "https://drive.google.com/uc?export=download&id=1lmnXJUbyx1JDt2OA5z_1dEowxozfkn30" -O harkonen.zip

unzip harkonen.zip
mv /root/modul-3/* /var/www/html
rm /var/www/html/harkonen.zip
cd
service apache2 restart