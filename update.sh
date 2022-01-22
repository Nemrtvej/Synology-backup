#!/bin/bash

set -e

DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

wget -O "${DIR}/backup-server.sh" https://raw.githubusercontent.com/Nemrtvej/Synology-backup/master/backup-server.sh
wget -O "${DIR}/config.sh.tpl" https://raw.githubusercontent.com/Nemrtvej/Synology-backup/master/config.sh.tpl
wget -O "${DIR}/backup.sh" https://raw.githubusercontent.com/Nemrtvej/Synology-backup/master/backup.sh.tpl


DEFINED_VARIABLES="$(cat "${DIR}/config.sh" | grep -v "^#" | grep '=' | awk -F= '{print $1}')"
TEMPLATE_VARIABLES="$(cat "${DIR}/config.sh.tpl" | grep -v "^#" | grep '=' | awk -F= '{print $1}')"

DIFF_RESULT="$(diff <(echo "${DEFINED_VARIABLES}") <(echo "${TEMPLATE_VARIABLES}"))"

if [ "$?" -ne 0 ]; then
    echo "New version contains changes in config vars. Make sure to adjust your config properly".
    echo "${DIFF_RESULT}"
fi


echo "Update finished."
