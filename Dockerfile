FROM phusion/baseimage:0.9.16

MAINTAINER Gabriel Glachant <gglachant@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
ENV NGINX_PACKAGE_VERSION 1.6.2-5+trusty0

RUN add-apt-repository -y ppa:nginx/stable && \
 apt-get -qy update && \
 apt-get -qy install nginx-full=$NGINX_PACKAGE_VERSION && \
 apt-get -qy clean && \
 rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY build/service-nginx.sh /etc/service/nginx/run

EXPOSE 80

CMD ["/sbin/my_init"]
