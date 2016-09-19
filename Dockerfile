FROM ubuntu:16.04
MAINTAINER Darebeat <fengwei2010@126.com>

ADD ./src /
RUN apt-get update && apt-get install vim openssh-server -y

# java
RUN wget http://119.254.110.32:8081/download/jdk1.7.0_60.tar.gz && \
    tar -xvzf jdk1.7.0_60.tar.gz -C /opt && \
    rm -rf jdk1.7.0_60.tar.gz

# hadoop
RUN wget http://mirrors.cnnic.cn/apache/hadoop/common/hadoop-2.7.2/hadoop-2.7.2.tar.gz && \
    tar -xvzf hadoop-2.7.2.tar.gz -C /opt && \
    rm -rf hadoop-2.7.2.tar.gz

# ENV
ENV JAVA_HOME /opt/jdk1.7.0_60
ENV HADOOP_HOME /opt/hadoop-2.7.2
ENV HADOOP_CONF_DIR $HADOOP_HOME/etc/hadoop
ENV PATH $JAVA_HOME/bin:$HADOOP_HOME/bin:$PATH

RUN cp /opt/config/* $HADOOP_CONF_DIR && rm -rf /opt/config
RUN sed -i '/^export JAVA_HOME/ s:.*:export JAVA_HOME=/opt/jdk1.7.0_60\nexport HADOOP_HOME=/opt/hadoop-2.7.2\n:' /opt/hadoop-2.7.2/etc/hadoop/hadoop-env.sh
RUN chmod +x /opt/hadoop-2.7.2/etc/hadoop/*-env.sh

RUN mkdir -p $HADOOP_HOME/hdfs/namenode && \
    mkdir -p $HADOOP_HOME/hdfs/datanode && \
    mkdir $HADOOP_HOME/logs

# ssh without password
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 600 ~/.ssh/*

# format namenode
RUN $HADOOP_HOME/bin/hdfs namenode -format

WORKDIR /opt/hadoop-2.7.2

CMD [ "sh", "-c", "service ssh start; bash"]
