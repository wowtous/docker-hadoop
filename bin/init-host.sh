#! /bin/bash

set -e

Containers=$@
ST=true
script=/chhost.sh
getContainerIp="docker inspect -f {{.NetworkSettings.IPAddress}}"
getContainerStatus="docker inspect -f {{.State.Running}}"

isContainerRunning(){
    if [[ x$1 != x ]]; then
        STATE=`$getContainerStatus $1`
        f=0
        if [[ $STATE ]]; then
            echo "The container : $1 is Running."
            return 0
        else
            while [[ f < 5 ]]; do
                echo "The container : $1 starting ..."
                sleep 10
                STATE=`$getContainerStatus $1`
                if [[ $STATE ]]; then
                    return 0
                    break
                fi
                let f=f+1
            done
        fi
    fi
    return 1
}

# 读取容器配置表
if [[ $1 == '-f' ]]; then
    Containers=`cat $2`
fi


for c in $Containers
do
    if !(isContainerRunning $c) ; then
        ST=false
        t=0
        while [[ t < 5 ]]; do
            sleep 10
            if isContainerRunning $c ; then
                break
            fi
            let t=t+1
        done
    fi
done

# 替换hosts
if [[ $ST ]]; then
    for i in $Containers
    do
        ip=`$getContainerIp $i`
        for j in $Containers
        do
            docker exec -it $j $script $ip $i
            echo "$j: $ip $i have updated."
        done
    done
fi
