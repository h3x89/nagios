# based on :
# https://www.digitalocean.com/community/tutorials/how-to-install-nagios-4-and-monitor-your-servers-on-ubuntu-14-04
#
# TO-DO
# add check_mk server with client
#


useradd nagios
groupadd nagcmd
usermod -a -G nagcmd nagios

sudo apt-get update

sudo apt-get install apache2 build-essential libgd2-xpm-dev openssl libssl-dev xinetd apache2-utils wget php5 libapache2-mod-php5 curl -y
----------------

cd ~

curl -L -O https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.1.1.tar.gz

tar xvfz nagios-4.1.1.tar.gz

cd nagios-4.1.1


#Before building Nagios, we must configure it. If you want to configure it to use postfix (which you can install with apt-get), add -–with-mail=/usr/sbin/sendmail to the following command:

./configure --with-nagios-group=nagios --with-command-group=nagcmd 

make all
make install
make install-commandmode
make install-init
make install-config
#make install-webconf
sudo /usr/bin/install -c -m 644 sample-config/httpd.conf /etc/apache2/sites-available/nagios.conf

sudo usermod -G nagcmd www-data

#PLUGINS

cd ~
curl -L -O http://nagios-plugins.org/download/nagios-plugins-2.1.1.tar.gz

tar xvf nagios-plugins-2.1.1.tar.gz

cd nagios-plugins-2.1.1
./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl
make
sudo make install

#NRPE
cd ~
curl -L -O http://downloads.sourceforge.net/project/nagios/nrpe-2.x/nrpe-2.15/nrpe-2.15.tar.gz

tar xvf nrpe-2.15.tar.gz

cd nrpe-2.15
./configure --enable-command-args --with-nagios-user=nagios --with-nagios-group=nagios --with-ssl=/usr/bin/openssl --with-ssl-lib=/usr/lib/x86_64-linux-gnu

make all
sudo make install
sudo make install-xinetd
sudo make install-daemon-config

sudo service xinetd restart



#APACHE2

sudo a2enmod rewrite
sudo a2enmod cgi

sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
sudo ln -s /etc/apache2/sites-available/nagios.conf /etc/apache2/sites-enabled/

sudo service nagios start
sudo service apache2 restart

sudo ln -s /etc/init.d/nagios /etc/rcS.d/S99nagios

chown nagios:nagios /usr/local/nagios/var


chown nagios:nagios /usr/local/nagios/var/spool/checkresults/
chmod 777 /usr/local/nagios/var/spool/checkresults/

