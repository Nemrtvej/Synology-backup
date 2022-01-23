#!/bin/bash
set -e

DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

source "${DIR}/config.sh"

### Check if properly configured

if [ -z ${REMOTE_SERVER_USER_NAME+x} ]; then echo "Variable 'REMOTE_SERVER_USER_NAME' is not defined! Terminating. "; exit 1; fi
if [ -z ${REMOTE_SERVER_USER_PASSWORD+x} ]; then echo "Variable 'REMOTE_SERVER_USER_PASSWORD' is not defined! Terminating. "; exit 1; fi
if [ -z ${REMOTE_SERVER_IP+x} ]; then echo "Variable 'REMOTE_SERVER_IP' is not defined! Terminating. "; exit 1; fi
if [ -z ${REMOTE_SERVER_DIRECTORY+x} ]; then echo "Variable 'REMOTE_SERVER_DIRECTORY' is not defined! Terminating. "; exit 1; fi
if [ -z ${REMOTE_SERVER_FILESYSTEM_CHARSET+x} ]; then echo "Variable 'REMOTE_SERVER_FILESYSTEM_CHARSET' is not defined! Terminating. "; exit 1; fi
if [ -z ${LOCAL_MOUNTPOINT+x} ]; then echo "Variable 'LOCAL_MOUNTPOINT' is not defined! Terminating. "; exit 1; fi
if [ -z ${LOCAL_BACKUP_USER_NAME+x} ]; then echo "Variable 'LOCAL_BACKUP_USER_NAME' is not defined! Terminating. "; exit 1; fi
if [ -z ${LOCAL_BACKUP_USER_GROUP+x} ]; then echo "Variable 'LOCAL_BACKUP_USER_GROUP' is not defined! Terminating. "; exit 1; fi
if [ -z ${BACKUP_TARGET_ROOT+x} ]; then echo "Variable 'BACKUP_TARGET_ROOT' is not defined! Terminating. "; exit 1; fi
if [ -z ${INFLUX_USERNAME+x} ]; then echo "Variable 'INFLUX_USERNAME' is not defined! Terminating. "; exit 1; fi
if [ -z ${INFLUX_PASSWORD+x} ]; then echo "Variable 'INFLUX_PASSWORD' is not defined! Terminating. "; exit 1; fi
if [ -z ${INFLUX_HOSTNAME+x} ]; then echo "Variable 'INFLUX_HOSTNAME' is not defined! Terminating. "; exit 1; fi
if [ -z ${INFLUX_DB+x} ]; then echo "Variable 'INFLUX_DB' is not defined! Terminating. "; exit 1; fi
if [ -z ${INFLUX_MACHINE_LABEL+x} ]; then echo "Variable 'INFLUX_MACHINE_LABEL' is not defined! Terminating. "; exit 1; fi
if [ -z ${REMOTE_SERVER_SMB_OPTIONS+x} ]; then echo "Variable 'REMOTE_SERVER_SMB_OPTIONS' is not defined! Terminating. "; exit 1; fi

### End check of proper configuration

CURRENT_DAY_NUM="$(date '+%u')"
BACKUP_TARGET_DIRECTORY="${BACKUP_TARGET_ROOT}/$CURRENT_DAY_NUM"


if [ ! -d "${BACKUP_TARGET_DIRECTORY}" ]; then
    mkdir -p "${BACKUP_TARGET_DIRECTORY}"
fi

if grep -qs "${LOCAL_MOUNTPOINT} " /proc/mounts; then
    echo "Mount point already mounted. Trying unmount first."
    umount "${LOCAL_MOUNTPOINT}"
fi

mount \
    -t cifs \
    -o "${REMOTE_SERVER_SMB_OPTIONS}ro,iocharset=${REMOTE_SERVER_FILESYSTEM_CHARSET},username=${REMOTE_SERVER_USER_NAME},password=${REMOTE_SERVER_USER_PASSWORD}" \
    "//${REMOTE_SERVER_IP}/${REMOTE_SERVER_DIRECTORY}" \
    "${LOCAL_MOUNTPOINT}"

rsync -o -g -a "${LOCAL_MOUNTPOINT}/" "${BACKUP_TARGET_DIRECTORY}"
chown -R "${LOCAL_BACKUP_USER_NAME}:${LOCAL_BACKUP_USER_GROUP}" "${BACKUP_TARGET_DIRECTORY}"

umount "${LOCAL_MOUNTPOINT}"

curl \
    --silent \
    -o /dev/null \
    --insecure \
    -i \
    --data-binary "synology_backups,server=${INFLUX_MACHINE_LABEL} finished=1" \
    -XPOST "https://${INFLUX_USERNAME}:${INFLUX_PASSWORD}@${INFLUX_HOSTNAME}/write?db=${INFLUX_DB}"

