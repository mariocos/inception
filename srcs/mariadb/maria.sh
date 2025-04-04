#!/bin/bash

if [ ! -d /var/lib/mysql/$WORDPRESS_DB ]; then
    # Start MariaDB in safe mode
    mysqld_safe --skip-networking &
    
    # Wait for MariaDB to start
    echo "Waiting for MariaDB to start..."
    sleep 5
    
    # Create database and set root password
    mysql -u root -e "CREATE DATABASE $WORDPRESS_DB;"
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MARIA_ROOT_PW';"
    
    # Create user and grant privileges
    mysql -u root -p$MARIA_ROOT_PW -e "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_USER_PWD';"
    mysql -u root -p$MARIA_ROOT_PW -e "GRANT ALL PRIVILEGES ON $WORDPRESS_DB.* TO '$DB_USER'@'%';"
    mysql -u root -p$MARIA_ROOT_PW -e "FLUSH PRIVILEGES;"
    
    # Shutdown MariaDB
    mysqladmin -u root -p$MARIA_ROOT_PW shutdown
fi

# Allow connections from anywhere
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf

# Execute command passed to docker run
exec "$@"