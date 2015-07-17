#!/bin/sh
#
# To be run by cron. Supposed to be located in $HOME/icvpn-aux/scripts.
# Supposed to be run as root, otherwise add sudo as applicable.
# Add paths to git, cat, sort, grep, awk, rndc below.
# If you don't use BIND, adjust accordingly. Don't forget to enable the zones
# in BIND's config otherwise ;)

PATH=$PATH:/usr/bin:/usr/sbin/

if [ ! -e ${HOME}/icvpn-aux/icvpn-meta ]; then
 (cd ${HOME}/icvpn-aux && git clone https://github.com/freifunk/icvpn-meta.git)
 exit 0
fi

cd ${HOME}/icvpn-aux
(cd ${HOME}/icvpn-aux/icvpn-meta ; git pull) && \
 cat `find icvpn-meta -maxdepth 1 -type f | sort | grep -v README` | \
 awk -f icvpn2bind.awk && \
 cp -p icvpn.zone 207.10.in-addr.arpa.zone /etc/bind/zones/ && \
 rndc reload icvpn && \
 rndc reload 207.10.in-addr.arpa) >/dev/null 2>&1

