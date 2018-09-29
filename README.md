A simple stand-alone wordpress for developing.
As it is stand-alone, it is easy to run and remove.

### Usage
```sh
docker run -p 443:443 -p 80:80 algernon2haworthia/alpine_wordpress
```
Then access it via "http(s)://{IP address}" in a browser.

### Environment Variables
This image uses some environment variables for the wordpress setting.

## DB_USER, DB_PASSWORD, DB_NAME
The default values are user, password, and wordpress.
The mariadb user, password, and database name for the wordpress.
Used for "wp-config.php" and the sql for the mariadb setup.

## WP_DEBUG
The default value is "false".
Used for the value WP_DEBUG defined in "wp-config.php". 

## WP_SQL
The default value is "/wp.sql".
If this file exists, the mariadb will restore from this file.
If you don't give any sql file, init.sh will do nothing and you can use your wordpress from installing.

## WP_DOMAIN
The default value is ""(blank).
If the file $WP_SQL exists and $WP_DOMAIN is not blank, the wp_options table will be updated.
If you want to change the url from your mysqldump file, use this value.

### Settings
The default apache document root is "/var/www/localhost/htdocs/". And wordpress files are there.
The db data will be stored in "/var/lib/mysql".

### Example
If you do not want to use the port 443.
```sh
docker run -p 943:443 -d \
    -v /sample_wordpress/wp-content:/var/www/localhost/htdocs/wp-content \
    -v /sample-dump.sql:/wp.sql \
    -e "WP_DOMAIN=$host_ip_address:943" \
    algernon2haworthia/alpine_wordpress
```