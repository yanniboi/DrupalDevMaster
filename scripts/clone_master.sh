#!/bin/sh

set -e

if [ -f master/build/files.tar.gz ];
then
   echo "File files.tar.gz exists."
else
   echo "File files.tar.gz does not exist."
   exit
fi

if [ -f master/build/db.sql.gz ];
then
   echo "File db.sql.gz exists."
else
   echo "File db.sql.gz does not exist."
   exit
fi
if [ $# -eq 0 ]
then
  SITE="test"
else
  SITE="$1"
fi

echo "Building new site directory."
mkdir $SITE
cp -R master/build $SITE/
cd $SITE
tar zxvf build/files.tar.gz
sed "s/master_database/site_$SITE/g" build/conf/settings.php > public_html/sites/default/settings.php
mkdir etc

echo "Cloning new site database."
mysql -u root -p -e "CREATE DATABASE site_$SITE"
gunzip build/db.sql.gz
mysql -u root -p site_$SITE < build/db.sql

echo "Cloning new site apache conf."
sed "s/master/$SITE/g" build/conf/master.conf > /etc/apache2/sites-available/$SITE.conf
a2ensite $SITE
service apache2 restart

rm -rf build
cd public_html
drush vset site_name $SITE

echo "Site complete."

