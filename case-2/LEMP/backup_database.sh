#!/bin/bash

# Set variables
DB_CONTAINER="mariadb"
DB_USER="lempuser"
DB_PASSWORD="lemppassword"
DB_NAME="lempdb"
BACKUP_DIR="/backups"
RETENTION_DAYS=30

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# Backup database
BACKUP_FILE="$BACKUP_DIR/db_backup_$(date +%F_%H-%M-%S).sql.gz"
docker exec $DB_CONTAINER mysqldump -u$DB_USER -p$DB_PASSWORD $DB_NAME | gzip > $BACKUP_FILE
echo "Database backup created: $BACKUP_FILE"

# Retain backups for the last 30 days
find $BACKUP_DIR -type f -name "*.sql.gz" -mtime +$RETENTION_DAYS -exec rm -f {} \;

