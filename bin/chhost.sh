#! /bin/sh

set -e

# 第一个参数是IP，第二个参数是域名或主机名
IP=$1
HOST=$2

if [[ x$HOST != x ]]; then
    sed -i "/$HOST/d" /etc/hosts
fi

if [[ x$IP != x && x$HOST != x ]]; then
    echo "$IP   $HOST"
fi
