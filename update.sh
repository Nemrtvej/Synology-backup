#!/bin/bash

set -e

DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

wget -O "${DIR}/backup-server.sh" https://raw.githubusercontent.com/Nemrtvej/Synology-backup/master/backup-server.sh
wget -O "${DIR}/config.sh.tpl" https://raw.githubusercontent.com/Nemrtvej/Synology-backup/master/config.sh.tpl
wget -O "${DIR}/update.sh" https://raw.githubusercontent.com/Nemrtvej/Synology-backup/master/update.sh


DEFINED_VARIABLES="$(cat "${DIR}/config.sh" | grep -v "^#" | grep '=' | awk -F= '{print $1}')"
TEMPLATE_VARIABLES="$(cat "${DIR}/config.sh.tpl" | grep -v "^#" | grep '=' | awk -F= '{print $1}')"

set +e
DIFF_RESULT="$(diff <(echo "${DEFINED_VARIABLES}") <(echo "${TEMPLATE_VARIABLES}"))"
DIFF_CODE="$?"
set -e 

if [ "${DIFF_CODE}" -ne 0 ]; then
    echo "New version contains changes in config vars. Make sure to adjust your config properly".
    echo "${DIFF_RESULT}"
else 
    echo "Config seems up to date."
fi


echo "Update finished."
