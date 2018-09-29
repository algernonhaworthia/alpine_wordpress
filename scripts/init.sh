#!/bin/sh

mysqld_safe &

sleep 20

sed -i -e "s/{db}/$DB_NAME/g" /init.sql &&\
sed -i -e "s/{user}/$DB_USER/g" /init.sql &&\
sed -i -e "s/{db_pass}/$DB_PASSWORD/g" /init.sql &&\ 
mysql < /init.sql

if [ ! -e /var/www/localhost/htdocs/wp-config.php ]; then
    sed -i -e "s/{db}/$DB_NAME/g" /wp-config.php_base
    sed -i -e "s/{user}/$DB_USER/g" /wp-config.php_base
    sed -i -e "s/{db_pass}/$DB_PASSWORD/g" /wp-config.php_base

    for num in `seq 1 8`
    do
        sed -i -e "s/{salt$num}/$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 20 | head -1)/g" /wp-config.php_base
    done

    sed -i -e "s/{WP_DEBUG}/$WP_DEBUG/g" /wp-config.php_base
    
    mv /wp-config.php_base /var/www/localhost/htdocs/wp-config.php
fi

if [ -e $WP_SQL ]; then
    echo "input db from file."
    mysql $DB_NAME < $WP_SQL
fi

if [ "" != $WP_DOMAIN ]; then
    echo "change url from env."
    sed -i -e "s/{url}/https:\/\/$WP_DOMAIN/g" /init2.sql
    mysql $DB_NAME < /init2.sql
fi

"$@"