## Backup and Restore Process

### Backup Process

The server is configured to perform weekly backups of all critical data, excluding media files (e.g., media, downloads).
The backup process includes:

1. **SSD Data**: Configuration files stored in `$SSD_PATH` (default: `~/server-files`) are backed up.
2. **HDD Data**: Files stored in `$HDD_PATH` (default: `/mnt/hdd`) are backed up, excluding the `media` and `downloads`
   directories.

#### Customization

You can configure the backup process by editing the following variables in `.env`:

- `SSD_PATH`: The directory containing configuration files (e.g., `~/server-files`).
- `HDD_PATH`: The directory containing media and downloads (e.g., `/mnt/hdd`).
- `BACKUP_DIR`: The directory where backups are stored (e.g., `/mnt/backup`).
- `BACKUP_RETENTION_DAYS`: The number of days to keep backups (e.g., `28`).
- `BACKUP_CHECK_MOUNT`: Set to `false` to skip the check for a mounted backup drive.

---

### Restore Process
``bash
rsync -av /mnt/backup/ssd/ ~/server-files/
``

#### 2. Restore HDD Data

Use `rsync` to restore the HDD data from the backup:
``bash
rsync -av /mnt/backup/hdd/ /mnt/hdd/
``
```bash
./scripts/restore.sh
```

---

### Setting Up the Cron Job

To schedule the backup script to run weekly, follow these steps:

1. Open the crontab editor:
   ``bash
   crontab -e
   ``

2. Add the following line to run the backup script every Sunday at 3 AM:
   ``bash
   0 3 * * 0 /home/ruurd/compose-services/scripts/backup.sh
   ``

3. Save and exit the editor. The cron job is now active.

#### Verify the Cron Job

To verify that the cron job has been set up correctly:

1. List the current cron jobs:
   ``bash
   crontab -l
   ``
2. Ensure the backup job appears in the list.

---

### Testing Backups

To ensure your backups are working correctly:

1. Run the backup script manually:
   ``bash
   ~/compose-services/scripts/backup.sh
   ``
2. Verify the backup files are created in `$BACKUP_DIR`.
3. Test restoring a small subset of data (e.g., a few files from `~/server-files` or `/mnt/hdd`).

---

### Notes

- **Media Files**: Media files (e.g., Plex media, downloads) are excluded from backups due to their size. Ensure these
  are backed up separately if needed.
- **Skip Mount Check**: If `BACKUP_CHECK_MOUNT` is set to `false`, the script will not check if the backup drive is
  mounted. Use this if backups are stored locally or on a network share that doesn't require mounting.
