#!/bin/bash

haproxy -f /etc/haproxy/haproxy.cfg -D

/bin/consul-template -consul ${CONSUL_ADDR:-consul}:${CONSUL_PORT:-8500} \
    -template /etc/haproxy/haproxy.ctmpl:/etc/haproxy/haproxy.cfg:/usr/local/sbin/hp_reinit.sh