#!/bin/bash

#Nginx Web Server Setup

echo "Setting up Nginx Server dated by `date`" > /root/dstatus.txt

for i in nginx mysql-server mysql zip php5* php5-fpm php5-mysql
do
status=`dpkg -l | grep -i $i |tr -s ' '|cut -d ' ' -f2| head -1`

if [ "$status" != '$i' ]; then
sudo apt-get install $i -y

elif [ "$status" = '$i' ]; then
echo "$i Packages is already installed..!"

else
echo "No Package available"

fi
done

echo "\n\nEnter Domain Name:"
read dname

sudo mkdir -p /var/www/$dname

sudo chown -R root:www-data /var/www/$dname

sudo echo -e "127.0.0.1 \t $dname" >>  /etc/hosts

echo "\n\nDownloading Wordpress source code\n"

wget -P /var/www/$dname/  http://wordpress.org/latest.zip

echo "\n\n Extracting Wordpress source code\n"

unzip /var/www/$dname/latest.zip -d /var/www/$dname/

sudo chmod -R 755 /var/www/$dname/

sudo echo -e "server {\nlisten 80;\nroot /var/www/$dname/wordpress;\nindex index.php index.html index.htm;\nserver_name $dname;\nlocation ~ \.php$ {\n#try_files $uri =404;\nfastcgi_split_path_info ^(.+\.php)(/.+)$;\nfastcgi_pass unix:/var/run/php5-fpm.sock;\nfastcgi_index index.php;\ninclude fastcgi_params;\n}\n}" > /etc/nginx/sites-available/$dname.conf

sudo ln -s /etc/nginx/sites-available/$dname.conf /etc/nginx/sites-enabled/$dname.conf

sudo echo "create database example_com_db" | mysql -u root -pleo_123

sudo echo "create user example_com_db" | mysql -u root -pleo_123

sudo echo "grant all privileges on example_com_db.* to example_com_db@'%' identified by 'leo_123'" | mysql -u root -pleo_123

sudo echo "flush privileges" | mysql -u root -pleo_123

cp /var/www/$dname/wordpress/wp-config-sample.php /var/www/$dname/wordpress/wp-config.php

sed -i "s/'DB_NAME', '.*'/'DB_NAME', 'example_com_db'/g"  /var/www/$dname/wordpress/wp-config.php
sed -i "s/'DB_USER', '.*'/'DB_USER', 'example_com_db'/g"  /var/www/$dname/wordpress/wp-config.php
sed -i "s/'DB_PASSWORD', '.*'/'DB_PASSWORD', 'leo_123'/g"  /var/www/$dname/wordpress/wp-config.php

sudo service mysql restart >> /root/dstatus.txt

sudo service nginx restart >> /root/dstatus.txt

sudo service php5-fpm start >> /root/dstatus.txt

dstatus=`service nginx status | grep -c running`
if [ $dstatus -eq 1 ] ; then
echo "Nginx Web server is installed successfully.! Check site example.com in browser"

else
echo "Nginx Web server is not Setup..!"
fi
