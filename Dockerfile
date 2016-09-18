FROM ubuntu:16.04
MAINTAINER Darebeat <fengwei2010@126.com>

ADD ./src /
RUN apt-get update
