#!/bin/bash

set -e

wget -O backup-server.sh https://raw.githubusercontent.com/Nemrtvej/Synology-backup/master/backup-server.sh
wget -O config.sh.tpl https://raw.githubusercontent.com/Nemrtvej/Synology-backup/master/config.sh.tpl


DEFINED_VARIABLES="$(cat config.sh | grep -v "^#" | grep '=' | awk -F= '{print $1}')"
TEMPLATE_VARIABLES="$(cat config.sh.tpl | grep -v "^#" | grep '=' | awk -F= '{print $1}')"

DIFF_RESULT="$(diff <(echo "${DEFINED_VARIABLES}") <(echo "${TEMPLATE_VARIABLES}"))"

if [ "$?" -ne 0 ]; then
    echo "New version contains changes in config vars. Make sure to adjust your config properly".
    echo "${DIFF_RESULT}"
fi


echo "Update finished."
