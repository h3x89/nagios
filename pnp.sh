apt-get install make rrdtool librrds-perl g++ php5-cli php5-gd libapache2-mod-php5 -y


cd /root/nagios

wget http://downloads.sourceforge.net/project/pnp4nagios/PNP-0.6/pnp4nagios-0.6.24.tar.gz
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

cat << EOF >> test

define command{
       command_name    process-service-perfdata-file
       command_line    /usr/local/pnp4nagios/libexec/process_perfdata.pl --bulk=/usr/local/pnp4nagios/var/service-perfdata
}
 
define command{
       command_name    process-host-perfdata-file
       command_line    /usr/local/pnp4nagios/libexec/process_perfdata.pl --bulk=/usr/local/pnp4nagios/var/host-perfdata
}

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


cp /etc/httpd/conf.d/pnp4nagios.conf /etc/apache2/sites-enabled/

/etc/init.d/nagios restart
/etc/init.d/apache2 restart

rm -rf /usr/local/pnp4nagios/share/install.php
