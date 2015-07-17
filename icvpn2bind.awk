BEGIN {inbgp=0;}

/^bgp:/ {inbgp=1; next;}

/^[a-z].*:/ {inbgp=0;}

(inbgp==1 && NF==1) {hostname=$1; gsub(":", "", hostname); gsub("_", "-", hostname); hostnames[++numhostnames]=hostname; next;}

(inbgp==1 && NF==2) && /ipv4:/ {numipv4[hostname]++; ipv4[hostname][numipv4[hostname]]=$2; next;}

(inbgp==1 && NF==2) && /ipv6:/ {numipv6[hostname]++; ipv6[hostname][numipv4[hostname]]=$2; next;}

END {
    printf("@ IN SOA mueritz-bgp1.icvpn. wusel.guetersloh.freifunk.net. ( %s 3600 1800 3600000 300 )\n", strftime("%y%m%d%H%M")) > "icvpn.zone";
    printf("\t3600 NS mueritz-bgp1.icvpn.\n\t3600 NS gw04.4830.org.\n\t3600 NS guetersloh4.icvpn.\n\t3600 NS librarian.uu.org.\n") >> "icvpn.zone";
    printf("@ IN SOA mueritz-bgp1.icvpn. wusel.guetersloh.freifunk.net. ( %s 3600 1800 3600000 300 )\n", strftime("%y%m%d%H%M")) > "207.10.in-addr.arpa.zone";
    printf("\t3600 NS mueritz-bgp1.icvpn.\n\t3600 NS gw04.4830.org.\n\t3600 NS guetersloh4.icvpn.\n\t3600 NS librarian.uu.org.\n") >> "207.10.in-addr.arpa.zone";
    for(i=1; i<=numhostnames; i++) {
        hostname=hostnames[i];
        for(j=1; j<=numipv4[hostname]; j++) {
            printf("%s\t3600 IN A %s\n", hostname, ipv4[hostname][j]) >> "icvpn.zone";
            split(ipv4[hostname][j], v4, "\\.");
            if(v4[1]=10 && v4[2]=207) {
                printf("%d.%d\t3600 IN PTR %s.icvpn.\n", v4[4], v4[3], hostname) >> "207.10.in-addr.arpa.zone";
            }
        }
        for(j=1; j<=numipv6[hostname]; j++) {
            printf("%s\t3600 IN AAAA %s\n", hostname, ipv6[hostname][j]) >> "icvpn.zone";
        }
    }
}

