FROM alpine:3.22.1

LABEL maintainer="fkropfhamer"

ENV USERNAME=user
ENV PASSWORD=changeme

RUN apk add --no-cache lighttpd lighttpd-mod_webdav lighttpd-mod_auth apache2-utils

RUN mkdir -p /var/www/html/webdav \
    && chown -R lighttpd:lighttpd /var/www/html/webdav

COPY lighttpd.conf /etc/lighttpd/lighttpd.conf

EXPOSE 80

COPY entrypoint.sh /
RUN chmod +x entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
