DAY=`date +"%d"`

for DIR in /var/www/!(default)/ do SITE=$(basename "$DIR"); tar -cfz /var/www/$DIR | gzip -9 | s3cmd --acl-private put - s3://%S3_BUCKET%/rocketeers/backups/%SERVER%/$SITE/$DAY.tar.gz; done

echo "SHOW DATABASES;" | mysql --user=%MYSQL_USER% --password=%MYSQL_PASSWORD% | grep -v -E "^(Database|mysql|sys|information_schema|performance_schema)$" | while read DATABASE; do mysqldump --user=%MYSQL_USER% --password=%MYSQL_PASSWORD% $DATABASE | gzip -9 | s3cmd --acl-private put - s3://%S3_BUCKET%/rocketeers/backups/%SERVER%/databases/$DATABASE/$DAY.sql.gz; done
