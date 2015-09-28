    sudo apt-get install build-essential libgd2-xpm-dev apache2-utils unzip
    sudo useradd -m nagios
    sudo passwd nagios
    9  sudo groupadd nagcmd
   10  sudo usermod -a -G nagcmd nagios
   11  sudo usermod -a -G nagcmd www-data
   12  wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.1.0rc2.tar.gz
   13  wget http://nagios-plugins.org/download/nagios-plugins-2.0.3.tar.gz
   14  tar xzf nagios-4.1.0rc2.tar.gz
   15  cd nagios-4.1.0rc2/
   16  sudo ./configure --with-command-group=nagcmd
   17  sudo make all
   18  sudo make install
   19  sudo make install-init
   20  sudo make install-config
   21  sudo make install-commandmode
   22  sudo make install-webconf
   23  ll
   24  sudo /usr/bin/install -c -m 644 sample-config/httpd.conf /etc/apache2/sites-enabled/nagios.conf
   25  apt-get install apache2 -y
   26  sudo /usr/bin/install -c -m 644 sample-config/httpd.conf /etc/apache2/sites-enabled/nagios.conf
   27  sudo ls -l /etc/apache2/sites-enabled/
   28  sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
   29  sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagios
   30  sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
   31  sudo systemctl restart apache2
   32  sudo service apache2 restart
   33  cd ..
   34  tar xzf nagios-plugins-2.0.3.tar.gz
   35  cd nagios-plugins-2.0.3/
   36  sudo ./configure --with-nagios-user=nagios --with-nagios-group=nagios
   37  sudo make
   38  sudo make install
   39  sudo a2enmod rewrite
   40  ubuntu-amd64:/home/ubuntu/nagios-plugins-2.0.3#sudo a2enmod cgi
   41  sudo a2enmod cgi
   42  sudo service apache2 restart
   43  sudo service nagios start
   44  sudo ln -s /etc/init.d/nagios /etc/rcS.d/S99nagios
   45  ifconfig 
   46  reboot
   47  vi nagios.conf 
   48  sudo service apache2 restart
   49  vi nagios.conf 
   50  apt-get install php5
   51  sudo service apache2 restart
   52  cd
   53  wget https://mathias-kettner.de/download/check_mk-1.2.7i2p2.tar.gz
   54  ll
   55  tar xvfz check_mk-1.2.7i2p2.tar.gz 
   56  cd check_mk-1.2.7i2p2
   57  ll
   58  tar xvfz agents.tar.gz 
   59  ll
   60  ./setup.sh 
   61  vi 
   62  vim /root/.check_mk_setup.conf 
   63  ./setup.sh 
   64  cd /etc/check_mk/
   65  ll
   66  find ./
   67  cat main.mk
   68  vi main.mk
   69  cmk -Ivp
   70  cd /root/
   71  ll
   72  cd check_mk-1.2.7i2p2
   73  ll
   74  dpkg -i check-mk-agent_1.2.7i2p2-1_all.deb
   75  apt-get install xinetd
   76  dpkg -i check-mk-agent_1.2.7i2p2-1_all.deb
   77  cmk -Ivp
   78  cmk -Rvp
   79  cd /etc/check_mk/
   80  ll
   81  vi main.mk
   82  cmk -IIvp
   83  cmk -Ivp
   84  vi main.mk
   85  cmk -Ivp
   86  cmk -Rvp
   87  vi main.mk
   88  cmk -Ivp
   89  cmk -Rvp
   90  cd /etc/nanorc 
   91  cd /usr/local/nagios/
   92  ll
   93  cat /root/.check_mk_setup.conf 
   94  vim /root/.check_mk_setup.conf 
   95  cd /usr/local/nagios/etc/
   96  ll
   97  grep -R localhost
   98  mv objects/localhost.cfg objects/localhost.cfg.bak
   99  cmk -Rvp
  100  service nagios restart
  101  mv objects/localhost.cfg.bak objects/localhost.cfg
  102  vi /etc/hosts
  103  vi /etc/check_mk/main.mk
  104  cmk -IIvp
  105  cmk -Rvp
  106  ll
  107  cd objects/
  108  ll
  109  cat localhost.cfg 
  110  vi /etc/check_mk/main.mk
  111  cmk -IIvp
  112  cmk -Rvp
  113  vi /etc/check_mk/main.mk
  114  cmk -IIvp
  115  cmk -Rvp
  116  service nagios restart
  117  reboot
  118  ll
  119  cd /usr/local/nagios/etc/
  120  ll
  121  cat nagios.cfg 
  122  grep log
  123  grep log *
  124  cat /usr/local/nagios/var/nagios.log
  125  ll /usr/lib/check_mk/livestatus.o
  126  vi /usr/lib/check_mk/livestatus.o
  127  ldd /usr/lib/check_mk/livestatus.o
  128  apt-get install -f
  129  apt-get install linux-vdso
  130  rm /usr/lib/check_mk/livestatus.o
  131  cmk -Rvp
  132  cat /usr/local/nagios/var/nagios.log
  133  w
  134  history
