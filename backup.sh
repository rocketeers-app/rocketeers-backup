DAY=`date +"%d"`

# sites
for DIR in /var/www/*; do SITE=$(basename "$DIR"); [[ $SITE = "default" ]] && continue; tar -cf - $DIR | gzip -9 | s3cmd --acl-private put - s3://%S3_BUCKET%/rocketeers/backups/%SERVER%/$SITE/files/$DAY.tar.gz; done

# databases
echo "SHOW DATABASES;" | mysql --user=%MYSQL_USER% --password=%MYSQL_PASSWORD% | grep -v -E "^(Database|mysql|sys|information_schema|performance_schema)$" | while read DATABASE; do mysqldump --user=%MYSQL_USER% --password=%MYSQL_PASSWORD% $DATABASE | gzip -9 | s3cmd --acl-private put - s3://%S3_BUCKET%/rocketeers/backups/%SERVER%/$DATABASE/databases/$DAY.sql.gz; done
