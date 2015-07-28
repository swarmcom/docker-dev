#!/bin/bash

epmd -daemon && service freeswitch restart
echo "
global
        log 127.0.0.1   local0
        log 127.0.0.1   local1 notice
        maxconn 4096
        user haproxy
        group haproxy
        stats socket    /tmp/haproxy.sock mode 777
  
defaults
        log global
        mode http
        option httplog
        option dontlognull
        option redispatch
        option httpchk GET /
        option allbackups
        maxconn 2000
        retries 3
        timeout connect 6000ms
        timeout client 12000ms
        timeout server 12000ms
  
listen bigcouch-data 0.0.0.0:15984
  balance roundrobin
    server swarmdev_db1_1.bigcouch.dev.swarm {IP_DB1}5984 check
    server swarmdev_db2_1.bigcouch.dev.swarm {IP_DB2}5984 check
    server swarmdev_db3_1.bigcouch.dev.swarm {IP_DB3}5984 check
  
listen bigcouch-mgr 127.0.0.1:15986
  balance roundrobin
    server swarmdev_db1_1.bigcouch.dev.swarm {IP_DB1}5986 check
    server swarmdev_db2_1.bigcouch.dev.swarm {IP_DB2}5986 check
    server swarmdev_db3_1.bigcouch.dev.swarm {IP_DB3}5986 check
  
listen haproxy-stats 127.0.0.1:22002
  mode http
  stats uri /
" > /etc/haproxy/haproxy.cfg
IPDB1=`ping -c 1 swarmdev_db1_1.bigcouch.dev.swarm | grep "64 bytes from"|awk '{print $4}'`
IPDB2=`ping -c 1 swarmdev_db2_1.bigcouch.dev.swarm | grep "64 bytes from"|awk '{print $4}'`
IPDB3=`ping -c 1 swarmdev_db3_1.bigcouch.dev.swarm | grep "64 bytes from"|awk '{print $4}'`
sed -i 's/{IP_DB1}/'$IPDB1'/g' /etc/haproxy/haproxy.cfg
sed -i 's/{IP_DB2}/'$IPDB2'/g' /etc/haproxy/haproxy.cfg
sed -i 's/{IP_DB3}/'$IPDB3'/g' /etc/haproxy/haproxy.cfg
service haproxy restart
