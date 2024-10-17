FROM nginx:1.21

LABEL maintainer="BaksiLi"

RUN apt-get clean && \
    apt-get update && \
    apt-get install -y nginx-extras apache2-utils certbot python3-certbot-nginx

COPY webdav.conf /etc/nginx/conf.d/default.conf
RUN rm /etc/nginx/sites-enabled/*


RUN mkdir -p "/media/data"
RUN chown -R www-data:www-data "/media/data"
VOLUME /media/data


COPY entrypoint.sh /
RUN chmod +x entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]