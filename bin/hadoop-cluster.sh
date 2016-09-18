#! /bin/bash

set -e

s=1
e=3

# 定义容器数组，存放容器名称
declare -a Containers
Containers[0]="master"

if [[ $2 -gt 3 ]]; then
    e=$2
fi

while [[ $s -lt $e ]]; do
    Containers[$s]="slave$s"
    s=$(( $s + 1 ))
done

# 启动/卸载容器
if [[ $1 == "start" ]]; then
    echo "The master container starting ..."
    docker run -itd -p 50070:50070 -p 8088:8088 --name master --hostname master docker-hadoop &> /dev/null
    echo "The master container is Running."

    s=1
    while [[ $s -lt $e ]]; do
        echo "The slave$s container starting ..."
        docker run -itd --name slave$s --hostname slave$s docker-hadoop &> /dev/null
        echo "The slave$s container is Running."
        let s=s+1
    done
    # 修改容器hosts
    `find . -name init-host.sh` ${Containers[*]}

    # 进入master容器
    docker exec -it master bash
elif [[ $1 == "stop" ]]; then
    docker stop master
    docker rm master
    echo "The master container is stopped."

    s=1
    while [[ $s -lt $e ]]; do
        docker stop slave$s
        docker rm slave$s
        echo "The slave$s container is stopped."
        s=$(( $s + 1 ))
    done
fi
