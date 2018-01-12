#!/bin/sh

#Environment
HOSTNAME='localhost'
DATE=`date +%Y-%m-%d`

#Server Mysql
MYSQLUSER='root'
MYSQLPASS=''

#Path to backup directory
cd /home/root/backup
mkdir backup_$DATE
cd backup_$DATE

#Dumping every database
for DB in $(mysql -h $HOSTNAME -u $MYSQLUSER --password=${MYSQLPASS} --batch --skip-column-names --execute="show databases");
do
	
	#Ignoring MySQL && Maria DB databases
	if [ "$DB" = "information_schema" ] || [ "$DB" = "performance_schema" ] || [ "$DB" = "sys" ] || [ "$DB" = "mysql" ]; then
        echo "Ignorando information_schema, performance_schema, sys, mysql";
    else
    	echo Backup $DB
        FILENAME=${HOSTNAME}_${DATE}_DB_${DB}.sql
		mysqldump $DB -h $HOSTNAME -u $MYSQLUSER --password=${MYSQLPASS} --triggers --routines > $FILENAME
    fi
done

#Exit of directory
cd ..

#Package the backup in tar.gz
tar -zcf backup_${DATE}.tar.gz backup_$DATE

#Remove the database directory
rm -rf backup_$DATE