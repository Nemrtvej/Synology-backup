#!/bin/bash

# Uzivatelske jmeno pro pripojeni se k serveru na zalohovani
REMOTE_SERVER_USER_NAME=
# Heslo pro pripojeni se k serveru na zalohovani
REMOTE_SERVER_USER_PASSWORD=
# IP adresa serveru pro zazalohovani
REMOTE_SERVER_IP=
# Adresar na vzdalenem serveru, ktery se ma zazalohovat.
REMOTE_SERVER_DIRECTORY=data
# Charset filesystemu na vzdalenem serveru
REMOTE_SERVER_FILESYSTEM_CHARSET=utf8

# Lokalni adresar, na ktery se namountuje vzdaleny server.
LOCAL_MOUNTPOINT=/volume1/data/mountserver

# Nazev lokalniho uzivatele, v jehoz domovskem adresari se delaji zalohy.
LOCAL_BACKUP_USER_NAME=server
# Skupina, do ktere tento uzivatel patri.
LOCAL_BACKUP_USER_GROUP=users

# Lokalni adresar, kam se budou dělat zálohy. Zde vznikají adresáře 1, 2, 3...
BACKUP_TARGET_ROOT="/volume1/data/zalohy"

# Dalsi nastaveni SMB pro dany server. Hodnota tohohle pole musi vzdy koncit carkou!
REMOTE_SERVER_SMB_OPTIONS="vers=3.0,"

# konfigurace monitoringu - ponechat beze změn kromě INFLUX_MACHINE_LABEL
INFLUX_USERNAME=stats
INFLUX_PASSWORD=41---------4tY
INFLUX_HOSTNAME=i-------t
INFLUX_DB=tarzi
INFLUX_MACHINE_LABEL=essa_cb
