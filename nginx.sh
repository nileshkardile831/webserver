#!/bin/bash
#Nginx Web Server Setup

echo "----------------------------------------------------------------" >> /root/dstatus.txt
echo "Setting up Nginx Server dated by `date`" >> /root/dstatus.txt

for i in nginx mysql-server telnet php

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


echo -e "\n\nEnter Domain Name:"
read dname

sudo mkdir -p /var/www/$dname

sudo chown -R www-data:www-data /var/www/$dname

sudo chmod 755 /var/www/

sudo cp /usr/share/nginx/html/index.html /var/www/$dname/

echo -e "127.0.0.1\t$dname" >>  /etc/hosts

echo -e "server {\nlisten 80;\nroot /var/www/$dname/;\nindex index.html index.htm;\nserver_name $dname;\n}" > /etc/nginx/sites-available/$dname.conf

sudo ln -s /etc/nginx/sites-available/$dname.conf /etc/nginx/sites-enabled/$dname.conf

sudo service nginx restart >> /root/dstatus.txt

echo "create database example" | mysql -u root -pleo_123
echo "create user example" | mysql -u root -pleo_123
echo "grant all privileges on example.* to example@'localhost' identified by 'usermypass'" | mysql -u root -pleo_123
echo "flush privileges" | mysql -u root -pleo_123


echo "Nginx Web server has been Setup..!"

echo "------------------------------------------------------------"  >> /root/dstatus.txt

