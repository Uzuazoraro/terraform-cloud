#!/bin/bash/
mkdir /var/www/
sudo mount -t efs -o tls,accesspoint=fsap-0b8830fec3ed3e860 fs-03f85bf06fe118121:/ /var/www/
yum install -y httpd
systemctl start httpd
systemctl enable httpd
yum module reset php -y
yum module enable php:remi-7.4 -y
yum install -y php php-common php-mbstring php-opcache php-intl php-xml php-gd php-curl php-mysqlnd php-fpm php-json
systemctl start fpm
systemctl enable fpm
wget <http://wordpress.org/latest.tar.gz>
tar xzvf latest.tar.gz
rm -rf latest.tar.gz
cp wordpress/wp-config-sample.php wordpress/wp-config.php
mkdir /var/www/html/
cp -R /wordpress/* /var/www/html/
cd /var/www/html/
touch healthstatus
sed -i "s/localhost/micolo-database.ccztgcogh9jc.us-east-1.rds.amazonaws.com/g" wp-config.php
sed -i "s/username_here/MicoloAdmin/g" wp-config.php
sed -i "s/password_here/passWord.1/g" wp-config.php
sed -i "s/database_name_here/wordpressdb/g" wp-config.php
chcon -t httpd_sys_rw_content_t /var/www/html/ -R
systemctl restart httpd