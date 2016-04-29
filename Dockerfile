FROM phusion/baseimage:0.9.18

MAINTAINER Gabriel Glachant <gglachant@gmail.com>

# Remove it. Add it when running apt-get only.
# ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
ENV NGINX_PACKAGE_VERSION 1.8.1-1+trusty0

RUN echo '#!/bin/sh' > /usr/sbin/policy-rc.d \
 && echo 'exit 101' >> /usr/sbin/policy-rc.d \
 && chmod +x /usr/sbin/policy-rc.d \
 \
 && dpkg-divert --local --rename --add /sbin/initctl \
 && cp -a /usr/sbin/policy-rc.d /sbin/initctl \
 && sed -i 's/^exit.*/exit 0/' /sbin/initctl \
 \
 && echo 'force-unsafe-io' > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup \
 \
 && echo 'DPkg::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' > /etc/apt/apt.conf.d/docker-clean \
 && echo 'APT::Update::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' >> /etc/apt/apt.conf.d/docker-clean \
 && echo 'Dir::Cache::pkgcache ""; Dir::Cache::srcpkgcache "";' >> /etc/apt/apt.conf.d/docker-clean \
 \
 && echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/docker-no-languages \
 \
 && echo 'Acquire::GzipIndexes "true"; Acquire::CompressionTypes::Order:: "gz";' > /etc/apt/apt.conf.d/docker-gzip-indexes

# Enable the universe repositories
# RUN sed -i 's/^#\s*\(deb.*universe\)$/\1/g' /etc/apt/sources.list

# Fully update the system
# RUN apt-get update && apt-get -y upgrade && apt-get autoremove && apt-get clean

RUN export DEBIAN_FRONTEND=noninteractive \
 && add-apt-repository -y ppa:nginx/stable \
 && apt-get -qy update \
 && apt-get -qy install nginx-full=$NGINX_PACKAGE_VERSION \
 && apt-get -qy clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY build/service-nginx.sh /etc/service/nginx/run

EXPOSE 80

CMD ["/sbin/my_init"]
