echo 'nameserver 10.74.3.2' > /etc/resolv.conf
apt-get update
apt-get install apache2-utils -y
apt-get install nginx -y
apt-get install lynx -y

service nginx stop

echo ' 
upstream worker {
    server 10.74.1.1;
    server 10.74.1.2;
    server 10.74.1.3;
}

server {
    listen 80;

    location / {
        proxy_pass http://worker/index.php;
    }
} ' > /etc/nginx/sites-available/default

service nginx start

echo "=====nginx benchmark====="

ab -n 500 -c 50 http://10.74.4.2/

echo ' 
upstream worker {
    least_conn;
    server 10.74.1.1;
    server 10.74.1.2;
    server 10.74.1.3;
}

server {
    listen 80;

    location / {
        proxy_pass http://worker/index.php;
    }
} ' > /etc/nginx/sites-available/default

service nginx restart

echo "=====nginx least connection====="
ab -n 500 -c 50 http://10.74.4.2/

echo ' 
upstream worker {
    ip_hash;
    server 10.74.1.1;
    server 10.74.1.2;
    server 10.74.1.3;
}

server {
    listen 80;

    location / {
        proxy_pass http://worker/index.php;
    }
} ' > /etc/nginx/sites-available/default

service nginx restart

echo "=====nginx ip hash====="
ab -n 500 -c 50 http://10.74.4.2/

echo ' 
upstream worker {
    hash $request_uri consistent;
    server 10.74.1.1;
    server 10.74.1.2;
    server 10.74.1.3;
}

server {
    listen 80;

    location / {
        proxy_pass http://worker/index.php;
    }
} ' > /etc/nginx/sites-available/default

service nginx restart

echo "=====nginx generic hash====="
ab -n 500 -c 50 http://10.74.4.2/

echo ' 
upstream worker {
    least_conn;
    server 10.74.1.1;
    server 10.74.1.2;
    server 10.74.1.3;
}

server {
    listen 80;

    location / {
        proxy_pass http://worker/index.php;
    }
} ' > /etc/nginx/sites-available/default

service nginx restart

echo "=====nginx least connection 3 Worker====="
ab -n 1000 -c 10 http://10.74.4.2/

echo ' 
upstream worker {
    least_conn;
    server 10.74.1.2;
    server 10.74.1.3;
}

server {
    listen 80;

    location / {
        proxy_pass http://worker/index.php;
    }
} ' > /etc/nginx/sites-available/default

service nginx restart

echo "=====nginx least connection 2 Worker====="
ab -n 1000 -c 10 http://10.74.4.2/

echo ' 
upstream worker {
    least_conn;
    server 10.74.1.3;
}

server {
    listen 80;

    location / {
        proxy_pass http://worker/index.php;
    }
} ' > /etc/nginx/sites-available/default

service nginx restart

echo "=====nginx least connection 1 Worker====="
ab -n 1000 -c 10 http://10.74.4.2/

rm -rf /etc/nginx/supersecret
mkdir /etc/nginx/supersecret
htpasswd -c /etc/nginx/supersecret/htpasswd secmart

echo '
upstream worker {
    least_conn;    
    server 10.74.1.1;
    server 10.74.1.2;
    server 10.74.1.3;
}

server {
    listen 80;

    location / {
        proxy_pass http://worker/index.php;
        auth_basic "Restricted Content";
        auth_basic_user_file /etc/nginx/supersecret/htpasswd;
        allow 10.74.1.37;
        allow 10.74.1.67;
        allow 10.74.2.203;
        allow 10.74.2.207;
        deny all;
    }
   
    location /dune {
        proxy_pass https://www.dunemovie.com.au/;
        proxy_set_header Host www.dunemovie.com.au;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
' > /etc/nginx/sites-available/default 

service nginx restart