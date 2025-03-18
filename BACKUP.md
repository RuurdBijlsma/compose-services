## Backup and Restore Process

### Backup Process
The server is configured to perform weekly backups of all critical data, excluding media files (e.g., Plex media, downloads). The backup process includes:
1. **Configuration Files**: The entire `ruurd-server-config` repository is backed up.
2. **Docker Volumes**: All Docker named volumes are backed up as compressed tarballs.
3. **HDD Data**: Files stored in `/mnt/hdd` are backed up, excluding the `media` and `downloads` directories.

#### Backup Schedule
- Backups run weekly on Sundays at 3 AM via a cron job.
- Backups are stored in `$BACKUP_DIR` (default: `/mnt/backup`).
- Old backups are automatically deleted after `$BACKUP_RETENTION_DAYS` (default: 28 days).

#### Customization
You can configure the backup process by editing the following variables in `.env`:
- `BACKUP_DIR`: The directory where backups are stored (e.g., `/mnt/backup`).
- `BACKUP_RETENTION_DAYS`: The number of days to keep backups (e.g., `28`).
- `BACKUP_CHECK_MOUNT`: Set to `false` to skip the check for a mounted backup drive.

---

### Restore Process

#### 1. Restore Configuration Files
Copy the `ruurd-server-config` directory from the backup to your home directory:
```bash
rsync -av /path/to/backup/ruurd-server-config/ ~/ruurd-server-config/
```
2. Restore Docker Volumes

For each Docker volume in the backup:

1. Create the volume:
```
    docker volume create <volume_name>
```

2. Restore the volume from the backup:
```
    docker run --rm -v <volume_name>:/volume -v /path/to/backup/volumes/<volume_name>.tar.gz:/backup.tar.gz alpine \
        sh -c "tar -xzf /backup.tar.gz -C /volume"
```
 3. Restore HDD Data
Use `rsync`:
```
rsync -av /path/to/backup/hdd/ /mnt/hdd/
```

---

### How to Use
1. Copy the `.env` variables into your `.env` file.
2. Copy the updated `backup.sh` script into `~/ruurd-server-config/scripts/backup.sh`.
3. Copy the README section into your `README.md`.

This setup now includes the `BACKUP_CHECK_MOUNT` environment variable for flexibility and provides clear instructions for backup and restore processes.
