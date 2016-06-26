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

echo "Deleting folders for $SITE"
sudo rm -rf $SITE

echo "Deleting database for $SITE"
mysql -u root -p -e "DROP DATABASE site_$SITE"

echo "Deleting apache conf for $SITE"
a2dissite $SITE
rm /etc/apache2/sites-available/$SITE.conf

