#!/bin/sh
exec /sbin/setuser root /usr/sbin/nginx -g "daemon off;" >> /var/log/nginx.log 2>&1
