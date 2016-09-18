#! /bin/bash
set -e

imi=$(docker images | grep docker-hadoop | awk '{print $3}')
if [ $imi ]; then
    docker rmi -f $imi
fi

if [[ x$1 == x ]]; then
    echo "The config file : Dockerfile"
    docker build -t docker-hadoop .
else
    if [[ -f Dockerfile-$1 ]]; then
        echo "Download the package for the image building!"
        if [[ -f jdk1.7.0_60.tar.gz ]]; then
            echo "JDK package have been downloaded"
        else
            echo "jdk1.7.0_60.tar.gz downloading ..."
            wget http://119.254.110.32:8081/download/jdk1.7.0_60.tar.gz
        fi

        if [[ -f hadoop-2.7.2.tar.gz ]]; then
            echo "Hadoop package have been downloaded"
        else
            echo "hadoop-2.7.2.tar.gz downloading ..."
            wget http://mirrors.cnnic.cn/apache/hadoop/common/hadoop-2.7.2/hadoop-2.7.2.tar.gz
        fi
        echo "The config file : Dockerfile-$1"
        docker build -f Dockerfile-$1 -t docker-hadoop .
    else
        echo "The config file : Dockerfile-$1 is not found!"
    fi
fi
