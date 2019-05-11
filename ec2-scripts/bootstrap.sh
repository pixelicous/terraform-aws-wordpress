HTDOCS_PATH='/opt/bitnami/apps/wordpress/htdocs'
# Backup DB
mkdir ~/backup
cd ~

# Replace password and dump

#/opt/bitnami/mysql/bin/mysqladmin -u $1 -h 127.0.0.1 -p380cccf909 password $2

# TODO: fix password change including hash
#mysql -u $1 $3 -p $2 > SET PASSWORD FOR '$1'@'localhost' = ENCRYPT($2)
#mysql -u $1 -p $2 > flushprivileges

echo "Dumping DB"
mysqldump -u $1 $3 -h 127.0.0.1 -p$2 > backup/db.sql #Must include local ip and not localhost to work

echo "Connect to RDS and copy DB"
# Copy DB to RDS
mysql -u $1 $3 -h $4 -p$2 < backup/db.sql

echo "Stop MySQL"
# Remove local MySql
sudo /opt/bitnami/ctlscript.sh stop mysql
sudo sed -i -r 's/^(\[My|my)/\;\1/g' /opt/bitnami/properties.ini
sudo mv /opt/bitnami/mysql /opt/bitnami/mysql-disabled

sudo cp $HTDOCS_PATH/wp-config.php $HTDOCS_PATH/bp-wp-config.php
sudo sed -i -r 's/(localhost:3306|LOCALHOST:3306)/'$4':3306/g' $HTDOCS_PATH/wp-config.php

# Add rows to use IAM role with WordPress AWS s3 plugin (still need to enable setting in admin dashboard).
sudo sed -i -r  '/(WP_HOME)/ a define\( \x27AS3CF_AWS_USE_EC2_IAM_ROLE\x27, true \)\;' $HTDOCS_PATH/wp-config.php

# Install and activate WordPress AWS S3 Plugin
wp plugin install amazon-s3-and-cloudfront
wp plugin activate amazon-s3-and-cloudfront