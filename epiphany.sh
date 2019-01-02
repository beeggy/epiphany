#!/bin/bash

if [ $USER != 'root' ]; then
	echo "You must run this as root"
	exit
fi

# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;

if [[ -e /etc/debian_version ]]; then
	#OS=debian
	RCLOCAL='/etc/rc.local'
else
	echo "You are not running this script on Debian OS"
	exit
fi

vps="vps";

if [[ $vps = "vps" ]]; then
	source="https://raw.githubusercontent.com/beeggy/epiphany/master"
else
	source="https://raw.githubusercontent.com/Dreyannz/iephocs/master"
fi

# go to root
cd

MYIP=$(wget -qO- ipv4.icanhazip.com);


#https://github.com/adenvt/OcsPanels/wiki/tutor-debian

clear
echo -e "                                                        "
echo 'echo -e "\e[0;32mBEEGGY"' >> .bashrc
echo 'echo -e "\e[0;33mBEEGGY"' >> .bashrc
echo 'echo -e "\e[0;34mBEEGGY"' >> .bashrc
echo 'echo -e "\e[0;36mBEEGGY"' >> .bashrc
echo 'echo -e "\e[0;37mBEEGGY"' >> .bashrc
echo 'echo -e "\e[0;35mBEEGGY"' >> .bashrc
echo -e "\e[94m.  ---------------------------------------------------------------      "
echo -e "\e[94m        OCS Panel Template by BEEGGY(EPIPHANY)        "
echo -e "\e[94m                                                  "
echo -e "\e[94m              Pre-Installation Setup              "
echo -e "\e[94m                                                  "
echo -e "\e[94m             Default Values Are Given,            "
echo -e "\e[94m             Please Change If You Want            "
echo -e "\e[94m                                                  "
echo -e "\e[94m  What will be the password for MySQL root User?  "
read -p "          Root Password   :  " -e -i beeggy DatabasePass
echo -e "\e[94m                                                  "
echo -e "\e[94m         What will be the DataBase Name?          "
read -p "          Database Name   :  " -e -i OCS_PANEL DatabaseName
echo -e "\e[94m                                                  "
echo -e "\e[94m         Pre-Installation Setup Completed         "
read -n1 -r -p "            Press Enter To Continue"
echo -e "\e[0m                                                  "

#apt-get update
apt-get update -y
apt-get install build-essential expect -y

echo "clear"                                                              >> .bashrc
echo 'echo -e "\e[0;34mBEEGGY"' >> .bashrc
echo 'echo -e "\e[0;34mBEEGGY"' >> .bashrc
echo 'echo -e "\e[0;34mBEEGGY"' >> .bashrc
echo 'echo -e "\e[0;34mBEEGGY"' >> .bashrc
echo 'echo -e "\e[0;34mBEEGGY"' >> .bashrc
echo 'echo -e "\e[0;34mBEEGGY"' >> .bashrc
echo 'echo -e "\e[94m.  ---------------------------------------------------------------      "' >> .bashrc
echo 'echo -e "                                                        "' >> .bashrc
echo 'echo -e "\e[94m        OCS Panel Template by BEEGGY(EPIPHANY)        "' >> .bashrc
echo 'echo -e "\e[0m                                                   "' >> .bashrc

apt-get install -y mysql-server

#mysql_secure_installation
so1=$(expect -c "
spawn mysql_secure_installation; sleep 3
expect \"\";  sleep 3; send \"\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect \"\";  sleep 3; send \"$DatabasePass\r\"
expect \"\";  sleep 3; send \"$DatabasePass\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect eof; ")
echo "$so1"
#\r
#Y
#pass
#pass
#Y
#Y
#Y
#Y

chown -R mysql:mysql /var/lib/mysql/
chmod -R 755 /var/lib/mysql/

apt-get -y install nginx php5 php5-fpm php5-cli php5-mysql php5-mcrypt
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup 
mv /etc/nginx/conf.d/vps.conf /etc/nginx/conf.d/vps.conf.backup 
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/beeggy/epiphany/master/nginx.conf" 
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/beeggy/epiphany/master/vps.conf" 
sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php5/fpm/php.ini 
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf

useradd -m vps
mkdir -p /home/vps/public_html
rm /home/vps/public_html/index.html
echo "<?php phpinfo() ?>" > /home/vps/public_html/info.php
chown -R www-data:www-data /home/vps/public_html
chmod -R g+rw /home/vps/public_html service php5-fpm restart
service php5-fpm restart
service nginx restart

apt-get -y install zip unzip
cd /home/vps/public_html
wget $source/jerz.zip
unzip jerz.zip
rm -f jerz.zip
chown -R www-data:www-data /home/vps/public_html
chmod -R g+rw /home/vps/public_html

#mysql -u root -p
so2=$(expect -c "
spawn mysql -u root -p; sleep 3
expect \"\";  sleep 3; send \"$DatabasePass\r\"
expect \"\";  sleep 3; send \"CREATE DATABASE IF NOT EXISTS $DatabaseName;EXIT;\r\"
expect eof; ")
echo "$so2"
#pass
#CREATE DATABASE IF NOT EXISTS OCS_PANEL;EXIT;

chmod 777 /home/vps/public_html/config
chmod 777 /home/vps/public_html/config/config.ini
chmod 777 /home/vps/public_html/config/route.ini

apt-get -y --force-yes -f install libxml-parser-perl

clear
echo -e "\e[94m                                                  "
echo 'echo -e "\e[0;37mBEEGGY"' >> .bashrc
echo 'echo -e "\e[0;36mBEEGGY"' >> .bashrc
echo 'echo -e "\e[0;34mBEEGGY"' >> .bashrc
echo 'echo -e "\e[0;32mBEEGGY"' >> .bashrc
echo 'echo -e "\e[0;33mBEEGGY"' >> .bashrc
echo 'echo -e "\e[0;35mBEEGGY"' >> .bashrc
echo -e "\e[94m.  ---------------------------------------------------------------      "
echo -e "\e[92m                                                  "
echo -e "\e[93m              PLEASE READ CAREFULLY               "
echo -e "\e[96m                                                  "
echo -e "\e[94m   Open Browser and Access http://$MYIP/          "
echo -e "\e[96m                                                  "
echo -e "\e[93m  Complete The Installation Using The Data Below  "
echo -e "\e[97m                                                  "
echo -e "\e[94m=====================Database====================="
echo -e "\e[93m       Database Host   : localhost                "
echo -e "\e[92m       Database Name   : $DatabaseName            "
echo -e "\e[91m       Database User   : root                     "
echo -e "\e[94m       Database Pass   : $DatabasePass            "
echo -e "\e[95m                                                  "
echo -e "\e[94m====================Admin Login==================="
echo -e "\e[92m       Username        : any username you want    "
echo -e "\e[94m       Password        : any password you want    "
echo -e "\e[95m       Re-Enter Pass   : any username you want    "
echo -e "\e[93m                                                  "
echo -e "\e[94m                      INSTALL                     "
echo -e "\e[92m                                                  "
read -n1 -r -p "      If Youre Done Installing, Press Enter"
echo -e "\e[97m                                                  "
echo -e "\e[94m            Are You Sure You Are Done?            "
read -n1 -r -p "           Press Enter To Continue"
echo -e "\e[93m                                                  "
echo -e "\e[96m    We Will Now Delete The Installation Folder    "
read -n1 -r -p "           Press Enter To Continue"
echo -e "\e[0m                                                  "
rm -R /home/vps/public_html/installation

cd /root
#wget http://www.webmin.com/jcameron-key.asc
#apt-key add jcameron-key.asc
#sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
#service webmin restart

#rm -f /root/jcameron-key.asc

#rm -R /home/vps/public_html/installation

cd
rm -f /root/.bash_history && history -c
echo "unset HISTFILE" >> /etc/profile

chmod 777 /home/vps/public_html/config
chmod 777 /home/vps/public_html/config/config.ini
chmod 777 /home/vps/public_html/config/route.ini

# info
clear
echo 'echo -e "\e[0;32mBEEGGY"' | tee -a log-install.txt
echo 'echo -e "\e[0;33mBEEGGY"'| tee -a log-install.txt
echo 'echo -e "\e[0;34mBEEGGY"'| tee -a log-install.txt
echo 'echo -e "\e[0;37mBEEGGY"' | tee -a log-install.txt
echo 'echo -e "\e[0;31mBEEGGY"' | tee -a log-install.txt
echo 'echo -e "\e[0;32mBEEGGY"' | tee -a log-install.txt
echo -e "\e[92m.  ---------------------------------------------------------------      " | tee -a log-install.txt
echo -e "\e[94m        OCS Panel Template by BEEGGY(EPIPHANY)        " | tee -a log-install.txt
echo -e "\e[94m                                                  " | tee -a log-install.txt
echo -e "\e[93m                                                  " | tee -a log-install.txt
echo -e "\e[95m              Installation Complete               " | tee -a log-install.txt
echo -e "\e[96m                                                  " | tee -a log-install.txt
echo -e "\e[93m             Check Your OCS Panel Now             " | tee -a log-install.txt
echo -e "\e[94m                http://$MYIP                      " | tee -a log-install.txt
echo -e "\e[0m                                                  " | tee -a log-install.txt
cd ~/

#rm -f /root/ocspanel.sh
