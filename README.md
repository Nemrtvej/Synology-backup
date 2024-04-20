# Usage

Insert following value to the Synology task scheduler:

```bash
set -o pipefail
/volume1/data/script/backups/backup-server.sh 2>&1 > /volume1/data/script/backups/last_run.log
```


Where `/volume1/data/script/backups` is the directory where the backup-server.sh resides.
