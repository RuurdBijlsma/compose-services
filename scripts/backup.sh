#!/bin/bash

# Load environment variables
source ~/compose-services/.env

# Backup configuration
BACKUP_DIR="${BACKUP_DIR:-/mnt/backup}"  # Default to /mnt/backup if not set
DATE=$(date +%Y-%m-%d)
BACKUP_ROOT="$BACKUP_DIR/$DATE"
RETENTION_DAYS="${BACKUP_RETENTION_DAYS:-28}"  # Default to 28 days if not set
CHECK_MOUNT="${BACKUP_CHECK_MOUNT:-true}"  # Default to true if not set

# Check if backup drive is mounted (if enabled)
if [ "$CHECK_MOUNT" = "true" ] && ! mountpoint -q "$BACKUP_DIR"; then
    echo "Backup drive not mounted. Aborting."
    exit 1
fi

# Create backup directories
mkdir -p "$BACKUP_ROOT"

# 1. Backup SSD data (configuration files)
echo "Backing up SSD data from $SSD_PATH..."
rsync -av --delete "$SSD_PATH/" "$BACKUP_ROOT/ssd/"

# 2. Backup HDD data (excluding media and downloads)
echo "Backing up HDD data from $HDD_PATH..."
rsync -av --delete --exclude='media/' --exclude='downloads/' "$HDD_PATH/" "$BACKUP_ROOT/hdd/"

# Clean up old backups
echo "Cleaning up backups older than $RETENTION_DAYS days..."
find "$BACKUP_DIR" -mindepth 1 -maxdepth 1 -type d -ctime +"$RETENTION_DAYS" -exec rm -rf {} \;

echo "Backup completed successfully."
