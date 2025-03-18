#!/bin/bash

# Load environment variables
source ~/ruurd-server-config/.env

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
mkdir -p "$BACKUP_ROOT"/{volumes,hdd}

# 1. Backup the git repository (configs and compose files)
echo "Backing up git repository..."
rsync -av --delete ~/ruurd-server-config/ "$BACKUP_ROOT/ruurd-server-config/"

# 2. Backup Docker volumes (excluding media-related bind mounts)
echo "Backing up Docker volumes..."
VOLUMES=$(docker volume ls -q)
for VOLUME in $VOLUMES; do
    echo "Backing up volume: $VOLUME"
    docker run --rm -v "$VOLUME":/volume -v "$BACKUP_ROOT/volumes":/backup alpine \
        tar -czf "/backup/$VOLUME.tar.gz" -C /volume .
done

# 3. Backup HDD data (excluding media and downloads)
echo "Backing up HDD data..."
rsync -av --delete --exclude='media/' --exclude='downloads/' /mnt/hdd/ "$BACKUP_ROOT/hdd/"

# Clean up old backups
echo "Cleaning up backups older than $RETENTION_DAYS days..."
find "$BACKUP_DIR" -mindepth 1 -maxdepth 1 -type d -ctime +"$RETENTION_DAYS" -exec rm -rf {} \;

echo "Backup completed successfully."
