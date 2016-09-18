# docker-hadoop

## 准备软件包
1. [jdk1.7.0_60](http://119.254.110.32:8081/download/jdk1.7.0_60.tar.gz)
2. [hadoop-2.7.2](http://mirrors.cnnic.cn/apache/hadoop/common/hadoop-2.7.2/hadoop-2.7.2.tar.gz)

## 生成镜像
```sh
cd .
# 如果上面文件下载到工程目录，使用本地源生成镜像
# 本地源生成镜像
bin/build.sh local

# 在线生成镜像
bin/build.sh
```
