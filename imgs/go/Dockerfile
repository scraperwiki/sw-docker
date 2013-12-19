FROM scraperwiki/base:precise

ENV DEBIAN_FRONTEND noninteractive
ENV GOPATH /usr

RUN echo deb http://archive.ubuntu.com/ubuntu precise universe > /etc/apt/sources.list.d/universe.list

RUN apt-get update -qq
RUN apt-get install -qqy iptables ca-certificates lxc netcat wget curl git htop less vim lsof

ADD ./dind /usr/local/bin/dind
ADD ./docker-latest /usr/local/bin/docker

ADD go_1.2-godeb1_amd64.deb /tmp/go_1.2-godeb1_amd64.deb
RUN dpkg -i /tmp/go_1.2-godeb1_amd64.deb
RUN rm /tmp/go_1.2-godeb1_amd64.deb

VOLUME /var/lib/docker
