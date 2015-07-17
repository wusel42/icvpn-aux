# icvpn-aux

Checkout in $HOME. Add contend of file in $HOME/icvpn-aux/cron to your cron.

Wait until the next full hour, $HOME/icvpn-aux/icvpn-meta should be checked out.

Wait another hour, $HOME/icvpn-aux/icvpn.zone and $HOME/icvpn-aux/207.10.in-addr.arpa.zone should exist and be copied to /etc/bind/zones/ as well.

You should have something like this somewhere in your BIND configuration (e. g. /etc/bind/named.conf.icvpn-aux and have that included from /etc/bind/named.conf):

zone "207.10.in-addr.arpa" {
	type master;
	also-notify { 10.207.0.134; 10.207.0.138; 130.185.104.56; 192.251.226.254; };
	file "/etc/bind/zones/207.10.in-addr.arpa.zone";
};

zone "icvpn" {
	type master;
	also-notify { 10.207.0.134; 10.207.0.138; 130.185.104.56; 192.251.226.254; };
	file "/etc/bind/zones/icvpn.zone";
};

