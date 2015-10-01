# How To Install Nagios 4.1 In Ubuntu 15.04

# by SK
# Nagios logo
# Please shareShare on Facebook0Share on Google+4Tweet about this on Twitter0Share on LinkedIn6Share on Reddit0Digg thisShare on StumbleUpon1Share on VKBuffer this page
# About Nagios
# Nagios is an enterprise class, open source software that can be used for network and infrastructure monitoring. Using Nagios, we can monitor servers, switches, applications and services etc. It alerts the System Administrator when something goes wrong and also alerts back when the issues have been rectified.

# Features
# Using Nagios, you can:

# Monitor your entire IT infrastructure.
# Identify problems before they occur.
# Know immediately when problems arise.
# Share availability data with stakeholders.
# Detect security breaches.
# Plan and budget for IT upgrades.
# Reduce downtime and business losses.
# Scenario
# For the purpose of this tutorial, I will be using the following two systems.

# Nagios server:

# Operating system : Ubuntu 15.04 Server
# IP Address : 192.168.1.102/24
# Nagios client:

# Operating System : Ubuntu 14.04 Server
# IP Address : 192.168.1.103/24
# Hostname : server.unixmen.local
# Prerequisites
# Make sure your server have installed with fully working LAMP stack. If not, follow the below link to install LAMP server.

# Install LAMP Server On Ubuntu
# And, install the following prerequisites too:

sudo apt-get update --fix-missing
sudo apt-get install build-essential libgd2-xpm-dev apache2-utils unzip apache2 gcc php5 xinetd -y
# Create Nagios User And Group
# Create a new nagios user account:

sudo useradd -m nagios
sudo passwd nagios
# Create a new nagcmd group for allowing external commands to be submitted through the web interface. Add both the nagios user and the apache user to the group.

sudo groupadd nagcmd
sudo usermod -a -G nagcmd nagios
sudo usermod -a -G nagcmd www-data
# Download Nagios And Plugins
# Go to the nagios download page, and get the latest version. As of writing this, the latest version was 4.1.0 release candidate 2.


if [ ! -f nagios-4.1.0rc2.tar.gz ];then
	wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.1.0rc2.tar.gz
fi

# And, download nagios plugins too. Nagios plugins allow you to monitor hosts, devices, services, protocols, and applications with Nagios

if [ ! -f nagios-plugins-2.0.3.tar.gz ];then
	wget http://nagios-plugins.org/download/nagios-plugins-2.0.3.tar.gz
fi
# Install Nagios And Plugins
# Install nagios:

# Go to the folder where you’ve downloaded nagios, and extract it using command:
cd /root/nagios
tar xzf nagios-4.1.0rc2.tar.gz
# Change to the nagios directory:

cd nagios-4.1.0rc2/
# Run the following commands one by one from the Terminal to compile and install nagios.

sudo ./configure --with-command-group=nagcmd
sudo make all
sudo make install
sudo make install-init
sudo make install-config
sudo make install-commandmode
# Install Nagios Web interface:

# Enter the following commands to compile and install nagios web interface.

# sudo make install-webconf
# You may get the following error:

# /usr/bin/install -c -m 644 sample-config/httpd.conf /etc/httpd/conf.d/nagios.conf
#  /usr/bin/install: cannot create regular file ‘/etc/httpd/conf.d/nagios.conf’: No such file or directory
#  Makefile:296: recipe for target 'install-webconf' failed
#  make: *** [install-webconf] Error 1
# The above error message describes that nagios is trying to create the nagios.conf file inside the /etc/httpd.conf/directory. But, in Ubuntu systems the nagios.conf file should be placed in /etc/apache2/sites-enabled/directory.

# So, run the following command instead of using sudo make install-webconf.

sudo /usr/bin/install -c -m 644 sample-config/httpd.conf /etc/apache2/sites-enabled/nagios.conf
# Check if nagios.conf is placed in /etc/apache2/sites-enabled directory.

# sudo ls -l /etc/apache2/sites-enabled/
# Sample output:

# total 4
# lrwxrwxrwx 1 root root 35 Aug 4 15:54 000-default.conf -> ../sites-available/000-default.conf
# -rw-r--r-- 1 root root 982 Aug 4 16:19 nagios.conf
# Create a nagiosadmin account for logging into the Nagios web interface. Remember the password you assign to this account. You’ll need it while logging in to nagios web interface..

echo "Create pass for user nagiosadmin on nagios dashboard:"
sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
# Restart Apache to make the new settings take effect.

# In Ubuntu 15.04:

# sudo systemctl restart apache2

# In Ubuntu 14.10 and previous versions:

sudo service apache2 restart
# Install Nagios plugins:

# Go to the directory where you downloaded the nagios plugins, and extract it.

cd /root/nagios
tar xzf nagios-plugins-2.0.3.tar.gz
# Change to the nagios plugins directory:

cd nagios-plugins-2.0.3/
# Run the following commands one by one to compile and install it.

sudo ./configure --with-nagios-user=nagios --with-nagios-group=nagios
sudo make
sudo make install
# Wait, We are not finished yet.

# Configure Nagios
# Nagios sample configuration files will be found in the /usr/local/nagios/etc directory. These sample files should work fine for getting started with Nagios. However, if you want, you’ll need to put your actual email ID to receive alerts.

# To do that, Edit the /usr/local/nagios/etc/objects/contacts.cfg config file with your favorite editor and change the email address associated with the nagiosadmin contact definition to the address you’d like to use for receiving alerts.

# sudo nano /usr/local/nagios/etc/objects/contacts.cfg
# Find the following line and enter the email id:

# [...]
# define contact{
#         contact_name                    nagiosadmin             ; Short name of user
#         use                             generic-contact         ; Inherit default values from generic-contact template (defined above)
#         alias                           Nagios Admin            ; Full name of user

#         email                           sk@unixmen.com  ; <<***** CHANGE THIS TO YOUR EMAIL ADDRESS ******
#         }
# [...]
# Save and close the file.

# Then, Edit file /etc/apache2/sites-enabled/nagios.conf,

# sudo nano /etc/apache2/sites-enabled/nagios.conf
# And edit the following lines if you want to access nagios administrative console from a particular IP series.

# Here, I want to allow nagios administrative access from 192.168.1.0/24 series only.

# [...]
## Comment the following lines ##
#   Order allow,deny
#   Allow from all

## Uncomment and Change lines as shown below ##
# Order deny,allow
# Deny from all
# Allow from 127.0.0.1 192.168.1.0/24
# [...]
# Enable Apache’s rewrite and cgi modules:

sudo a2enmod rewrite
sudo a2enmod cgi
# Restart apache service.

# sudo systemctl restart apache2
# Or,

sudo service apache2 restart
# Check nagios,conf file for any syntax errors:

sudo /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
# If there are no errors, start nagios service and make it to start automatically on every boot.

sudo service nagios start
sudo ln -s /etc/init.d/nagios /etc/rcS.d/S99nagios
# Note: In Ubuntu 15.04, you will see the following error message while starting nagios service.

# Failed to start nagios.service: Unit nagios.service failed to load: No such file or directory.
# Or

# [....] Starting nagios (via systemctl): nagios.serviceFailed to start nagios.service: Unit nagios.service failed to load: No such file or directory.
 # failed!
# To fix this error, copy /etc/init.d/skeleton to /etc/init.d/nagios using the following command:

# sudo cp /etc/init.d/skeleton /etc/init.d/nagios
# Edit file /etc/init.d/nagios:

# sudo nano /etc/init.d/nagios
# Add the following lines:

# DESC="Nagios"
# NAME=nagios
# DAEMON=/usr/local/nagios/bin/$NAME
# DAEMON_ARGS="-d /usr/local/nagios/etc/nagios.cfg"
# PIDFILE=/usr/local/nagios/var/$NAME.lock
# Save and close the file.

# Finally you need to change the permissions of the file

# sudo chmod +x /etc/init.d/nagios
# Now, you can start nagios service using command:

# sudo /etc/init.d/nagios start
# Access Nagios Web Interface
# Open up your web browser and navigate to http://nagios-server-ip/nagios and enter the username as nagiosadmin and its password which we created in the earlier steps.

# 192.168.1.102-nagios - Google Chrome_001

# This is how Nagios administrative console looked:

# Nagios Core - Google Chrome_002

# Click on the “Hosts” section in the left pane of the console. You will see there the no of hosts being monitored by Nagios server. We haven’t added any hosts yet. So it simply monitors the localhost itself only.

# Nagios Core - Google Chrome_003

# Click on the localhost to display more details:

# Nagios Core - Google Chrome_004

# That’s it. We have successfully installed and configure Nagios core in our Ubuntu 15.04 server.

# Add Monitoring targets to Nagios server
# Now, let us add some clients to monitor by Nagios server.

# To do that we have to install nrpe and nagios-plugins in our monitoring targets.

# On CentOS/RHEL/Scientifc Linux clients:

# Add EPEL repository in your CentOS/RHEL/Scientific Linux 6.x or 7 clients to install nrpe package.

# To install EPEL on CentOS 7, run the following command:

# yum install epel-release
# On CentOS 6.x systems, refer the following link.

# Install EPEL Repository On CentOS 6.x
# Install “nrpe” and “nagios-plugins” packages in client systems:

# yum install nrpe nagios-plugins-all openssl
# On Debian/Ubuntu clients:

# sudo apt-get install nagios-nrpe-server nagios-plugins
# Configure Monitoring targets
# Edit /etc/nagios/nrpe.cfg file,

# sudo nano /etc/nagios/nrpe.cfg
# Add your Nagios server ip address:

# [...]
# ## Find the following line and add the Nagios server IP ##
# allowed_hosts=127.0.0.1 192.168.1.102
# [...]
# Start nrpe service on CentOS clients:

# CentOS 7:

# systemctl start nrpe
# chkconfig nrpe on
# CentOS 6.x:

# service nrpe start
# chkconfig nrpe on
# For Debian/Ubuntu Clients, start nrpe service as shown below:

# sudo /etc/init.d/nagios-nrpe-server restart
# Now, go back to your Nagios server, and add the clients ( in the configuration file.

# To do that, Edit “/usr/local/nagios/etc/nagios.cfg” file,

# sudo nano /usr/local/nagios/etc/nagios.cfg
# and uncomment the following lines.

# ## Find and uncomment the following line ##
# cfg_dir=/usr/local/nagios/etc/servers
# Create a directory called “servers” under “/usr/local/nagios/etc/”.

# sudo mkdir /usr/local/nagios/etc/servers
# Create config file to the monitoring target (client):

# sudo nano /usr/local/nagios/etc/servers/clients.cfg
# Add the following lines:

# define host{

# use                             linux-server

# host_name                       server.unixmen.local

# alias                           server

# address                         192.168.1.103

# max_check_attempts              5

# check_period                    24x7

# notification_interval           30

# notification_period             24x7

# }
# Here, 192.168.1.103 is my nagios client IP address and server.unixmen.local is the client system’s hostname.

# Finally, restart nagios service.

# sudo /etc/init.d/nagios restart
# Or

# sudo service nagios restart
# Wait for few seconds, and refresh nagios admin console in the browser and navigate to “Hosts” section in the left pane. Now, You will see the newly added client will be visible there. Click on the host to see if there is anything wrong or any alerts it has.

# Nagios Core - Google Chrome_005

# Click on the monitoring target (client system) to view the detailed output:

# Nagios Core - Google Chrome_006

# Similarly, you can define more clients by creating a separate config files “/usr/local/nagios/etc/servers”directory for each client.

# Define services
# We have just defined the monitoring host. Now, let us add some services of the monitoring host. For example, to monitor the ssh service, add the following lines shown in bold in the“/usr/local/nagios/etc/servers/clients.cfg” file.

# sudo nano /usr/local/nagios/etc/servers/clients.cfg
# Add the following lines shown in bold:

# define host{

# use                             linux-server

# host_name                       server.unixmen.local

# alias                           server

# address                         192.168.1.103

# max_check_attempts              5

# check_period                    24x7

# notification_interval           30

# notification_period             24x7

# }

# define service {
#         use                             generic-service
#         host_name                       server.unixmen.local
#         service_description             SSH
#         check_command                   check_ssh
#         notifications_enabled           0
#         }
# Save and close the file. Restart Nagios.

# sudo /etc/init.d/nagios restart
# Or,

# sudo service nagios restart
# Wait for few seconds (90 seconds by default), and check for the added services (i.e ssh) in the nagios web interface. Navigate to Services section on the left side bar, you’ll see the ssh service there.

# Nagios Core - Google Chrome_007

# To know more about object definitions such as Host definitions, service definitions, contact definitions, please visit here. This page will explain you the description and format of all object definitions.

# Additional Tip:

# I would like to thank our Unixmen reader for this useful tip.

# If you’re trying to use check_http with the -S flag (for https), this guide misses a big step.

# Make sure you install openssl and libssl-dev first. And yes, even if your Nagios server is checking a remote client, you need openssl and libssl-dev locally.

# The when you get to configuring the Nagios plugins, add –with-openssl so you end up with:

# ./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl
# That’s it. Cheers!



#####
#
#
# CHECK_MK
#
#
####

cd /root/nagios
if [ ! -f check_mk-1.2.7i2p3.tar.gz ];then
	wget https://mathias-kettner.de/download/check_mk-1.2.7i2p3.tar.gz --no-check-certificate
fi
tar xvfz check_mk-1.2.7i2p3.tar.gz
cd check_mk-1.2.7i2p3

cp /root/nagios/.check_mk_setup.conf /root/
./setup.sh

tar xvfz agents.tar.gz
dpkg -i check-mk-agent_1.2.7i2p3-1_all.deb

echo 127.0.0.1    nagios >> /etc/hosts
echo "all_hosts = [ 'nagios' ]" >> /etc/check_mk/main.mk

cmk -Ivp
cmk -Rvp

bash ./pnp.sh


#
#
# PNP4NAGIOS
#
#

apt-get install make rrdtool librrds-perl g++ php5-cli php5-gd libapache2-mod-php5 -y


cd /root/nagios

if [ ! -f pnp4nagios-0.6.24.tar.gz ];then
	wget http://downloads.sourceforge.net/project/pnp4nagios/PNP-0.6/pnp4nagios-0.6.24.tar.gz
fi

tar -xzvf pnp4nagios-0.6.24.tar.gz

cd pnp4nagios-0.6.24

./configure --with-nagios-user=nagios --with-nagios-group=nagios
make all
make install
make install-webconf
make install-config
make install-init

update-rc.d npcd defaults
service npcd start


PATH=/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
#Enabling process_performance data
sed -i 's/process_performance_data=0/#process_performance_data=0/g' /usr/local/nagios/etc/nagios.cfg
#Configuring nagios for pnp4nagios
echo '' >> /usr/local/nagios/etc/nagios.cfg
echo '#pnp4nagios configuration start' >> /usr/local/nagios/etc/nagios.cfg
echo 'process_performance_data=1' >> /usr/local/nagios/etc/nagios.cfg
echo '' >> /usr/local/nagios/etc/nagios.cfg
echo '#' >> /usr/local/nagios/etc/nagios.cfg
echo '# service performance data' >> /usr/local/nagios/etc/nagios.cfg
echo '#' >> /usr/local/nagios/etc/nagios.cfg
echo 'service_perfdata_file=/usr/local/pnp4nagios/var/service-perfdata' >> /usr/local/nagios/etc/nagios.cfg
echo '' >> /usr/local/nagios/etc/nagios.cfg
echo 'service_perfdata_file_template=DATATYPE::SERVICEPERFDATA\tTIMET::$TIMET$\tHOSTNAME::$HOSTNAME$\tSERVICEDESC::$SERVICEDESC$\tSERVICEPERFDATA::$SERVICEPERFDATA$\tSERVICECHECKCOMMAND::$SERVICECHECKCOMMAND$\tHOSTSTATE::$HOSTSTATE$\tHOSTSTATETYPE::$HOSTSTATETYPE$\tSERVICESTATE::$SERVICESTATE$\tSERVICESTATETYPE::$SERVICESTATETYPE$' >> /usr/local/nagios/etc/nagios.cfg
echo '' >> /usr/local/nagios/etc/nagios.cfg
echo 'service_perfdata_file_mode=a' >> /usr/local/nagios/etc/nagios.cfg
echo '' >> /usr/local/nagios/etc/nagios.cfg
echo 'service_perfdata_file_processing_interval=10' >> /usr/local/nagios/etc/nagios.cfg
echo '' >> /usr/local/nagios/etc/nagios.cfg
echo 'service_perfdata_file_processing_command=process-service-perfdata-file' >> /usr/local/nagios/etc/nagios.cfg
echo '' >> /usr/local/nagios/etc/nagios.cfg
echo '#' >> /usr/local/nagios/etc/nagios.cfg
echo '# host performance data' >> /usr/local/nagios/etc/nagios.cfg
echo '# ' >> /usr/local/nagios/etc/nagios.cfg
echo 'host_perfdata_file=/usr/local/pnp4nagios/var/host-perfdata' >> /usr/local/nagios/etc/nagios.cfg
echo '' >> /usr/local/nagios/etc/nagios.cfg
echo 'host_perfdata_file_template=DATATYPE::HOSTPERFDATA\tTIMET::$TIMET$\tHOSTNAME::$HOSTNAME$\tHOSTPERFDATA::$HOSTPERFDATA$\tHOSTCHECKCOMMAND::$HOSTCHECKCOMMAND$\tHOSTSTATE::$HOSTSTATE$\tHOSTSTATETYPE::$HOSTSTATETYPE$' >> /usr/local/nagios/etc/nagios.cfg
echo '' >> /usr/local/nagios/etc/nagios.cfg
echo 'host_perfdata_file_mode=a' >> /usr/local/nagios/etc/nagios.cfg
echo '' >> /usr/local/nagios/etc/nagios.cfg
echo 'host_perfdata_file_processing_interval=10' >> /usr/local/nagios/etc/nagios.cfg
echo '' >> /usr/local/nagios/etc/nagios.cfg
echo 'host_perfdata_file_processing_command=process-host-perfdata-file' >> /usr/local/nagios/etc/nagios.cfg
echo '' >> /usr/local/nagios/etc/nagios.cfg
echo '#pnp4nagios configuration end' >> /usr/local/nagios/etc/nagios.cfg

cat << EOF >> /usr/local/nagios/etc/objects/commands.cfg

# Bulk with NPCD mode

#

define command {

command_name process-service-perfdata-file

command_line /bin/mv /usr/local/pnp4nagios/var/service-perfdata /usr/local/pnp4nagios/var/spool/service-perfdata.$TIMET$

}

define command {

command_name process-host-perfdata-file

command_line /bin/mv /usr/local/pnp4nagios/var/host-perfdata /usr/local/pnp4nagios/var/spool/host-perfdata.$TIMET$

}

EOF



cat << EOF >> /usr/local/nagios/etc/objects/templates.cfg
define host {

name host-pnp

action_url /pnp4nagios/index.php/graph?host=$HOSTNAME$&srv=_HOST_’ class=’tips’ rel=’/pnp4nagios/index.php/popup?host=$HOSTNAME$&srv=_HOST_

register 0

}

define service {

name srv-pnp

action_url /pnp4nagios/index.php/graph?host=$HOSTNAME$&srv=$SERVICEDESC$’ class=’tips’ rel=’/pnp4nagios/index.php/popup?host=$HOSTNAME$&srv=$SERVICEDESC$

register 0

}

EOF

cp /etc/httpd/conf.d/pnp4nagios.conf /etc/apache2/sites-enabled/

/etc/init.d/nagios restart
/etc/init.d/apache2 restart

rm -rf /usr/local/pnp4nagios/share/install.php
