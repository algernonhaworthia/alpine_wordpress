FROM alpine

RUN apk --no-cache add php7 php7-mbstring php7-mysqli php7-opcache php7-xml php7-apache2 curl \
 mariadb mariadb-client \
 apache2 apache2-ssl sed ;\
 mysql_install_db --user=mysql ;\
 mkdir /run/apache2 ;\
 sed -i -e "s/AllowOverride None/AllowOverride ALL/" /etc/apache2/httpd.conf ;\
 echo "LoadModule rewrite_module modules/mod_rewrite.so" >> /etc/apache2/httpd.conf
 
ENV WORDPRESS_VERSION 5.1.1
ENV WORDPRESS_SHA1 f1bff89cc360bf5ef7086594e8a9b68b4cbf2192

RUN set -ex; \
	curl -o wordpress.tar.gz -fSL "https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz"; \
	echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c -; \
# upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
	mkdir /usr/src ;\
    tar -xzf wordpress.tar.gz -C /usr/src/; \
	rm wordpress.tar.gz; \
	mv /usr/src/wordpress /usr/src/htdocs ;\
    rm -r /var/www/localhost/htdocs ;\
    mv /usr/src/htdocs /var/www/localhost/htdocs ;\
    chown -R apache:apache /var/www/localhost/htdocs

EXPOSE 443 80

ENV DB_USER=user DB_PASSWORD=password DB_NAME=wordpress WP_DEBUG=false WP_SQL="/wp.sql" WP_DOMAIN=""

COPY scripts /

RUN chmod +x /init.sh ;\
 chmod +x /start.sh ;\
 apk del curl

ENTRYPOINT [ "/init.sh" ]
CMD ["/start.sh"]