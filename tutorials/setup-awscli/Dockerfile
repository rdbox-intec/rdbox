FROM ubuntu:16.04

MAINTAINER rdbox <446_rdbox@intec.co.jp>

ENV LANG C.UTF-8

RUN apt-get update && \
    apt-get -y install curl python ssh git dnsutils vim ipcalc && \
    cd /tmp && \
    curl -L -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    pip install awscli && \
    echo "Please install some packages as you like" && \
    echo "e.g. 'apt-get -y install less locate'"


#
