#!/bin/bash

# Load environment variables
source ~/compose-services/.env

# Usage check: require a date in YYYY-MM-DD format as the first argument
if [ -z "$1" ]; then
    echo "Usage: $0 <backup_date (YYYY-MM-DD)>"
    exit 1
fi

RESTORE_DATE="$1"
BACKUP_ROOT="$BACKUP_DIR/$RESTORE_DATE"

# Check if the backup for the specified date exists
if [ ! -d "$BACKUP_ROOT" ]; then
    echo "Backup for date $RESTORE_DATE not found at $BACKUP_ROOT"
    exit 1
fi

echo "Restoring backup from $RESTORE_DATE..."
echo

# 1. Restore SSD data (configuration files)
if [ -z "$SSD_PATH" ]; then
    echo "SSD_PATH is not defined. Please check your environment configuration."
    exit 1
fi
echo "Restoring SSD data to $SSD_PATH..."
rsync -av "$BACKUP_ROOT/ssd/" "$SSD_PATH/"

# 2. Restore HDD data
if [ -z "$HDD_PATH" ]; then
    echo "HDD_PATH is not defined. Please check your environment configuration."
    exit 1
fi
echo "Restoring HDD data to $HDD_PATH..."
rsync -av "$BACKUP_ROOT/hdd/" "$HDD_PATH/"

echo
echo "Restore completed successfully."
