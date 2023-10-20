#!/bin/bash

DAY=`date +"%d"`
S3CMD="/usr/local/bin/s3cmd"

# databases
echo "SHOW DATABASES;" | mysql --user=%MYSQL_USER% --password=%MYSQL_PASSWORD% | grep -v -E "^(Database|mysql|sys|information_schema|performance_schema)$" | while read DATABASE; do mysqldump --user=%MYSQL_USER% --password=%MYSQL_PASSWORD% --add-drop-table --extended-insert --single-transaction --skip-comments $DATABASE | gzip -9 | pv -L 1m -q | $S3CMD --acl-private put - s3://rocketeers/backups/%SERVER%/$DATABASE/databases/$DAY.sql.gz; done

# sites
for DIR in /var/www/*; do SITE=$(basename "$DIR"); [[ $SITE = "default" ]] && continue; tar -cf - $DIR/.env $DIR/certs $DIR/conf $DIR/persistent | gzip -9 | pv -L 1m -q | $S3CMD --acl-private put - s3://rocketeers/backups/%SERVER%/$SITE/files/$DAY.tar.gz; done
