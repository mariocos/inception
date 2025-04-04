#!/bin/bash

# Change to the WordPress directory
cd /var/www/html

# Counter for connection attempts
I=0

# Try to connect to the database
while [ $I -lt 10 ]; do
    if (nc -w 3 -zv $DB_HOST 3306); then
        echo "Connected to MariaDB, setting up WordPress..."
        
        # Create WordPress config
        wp config create --allow-root \
            --dbname=$WORDPRESS_DB \
            --dbhost=$DB_HOST \
            --dbuser=$DB_USER \
            --dbpass=$DB_USER_PWD
        
        # Install WordPress core
        wp core install --allow-root \
            --url=mamadu.com \
            --title="bepis" \
            --admin_user=$ADMIN_USER \
            --admin_password=$ADMIN_PWD \
            --admin_email=$ADMIN_EMAIL
        
        # Create additional user
        wp user create --allow-root \
            $WP_USER $WP_USER_EMAIL \
            --user_pass=$WP_USER_PWD
        
        break
    else
        echo "Waiting for database connection... Attempt $((I+1))/10"
        sleep 1
        ((I++))
    fi
done

if [ $I -eq 10 ]; then
    echo "Server connection timed out" >&2
    exit 1
else
    echo "WordPress setup complete, starting PHP-FPM"
    exec "$@"
fi