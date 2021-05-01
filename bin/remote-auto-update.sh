#!/bin/bash

if [ "$1" == "" ] || [ "$2" == "" ] || [ "$4" != "" ]; then
  echo "usage $0 'host1 host2 host3' 'curl tcpdump' ['sleep 30 && reboot'] "
  exit
fi

OpenWrtDevices="$1"
USER_PACKAGES="$2"
EXTRA_COMMAND="$3"
ALLOW_UPDATE_RC="$4";
TMP_FILENAME_PATH="/tmp/openwrt-auto-update.sh"

cd /tmp/ || exit
wget https://raw.githubusercontent.com/easyinternetat/openwrt-autoupdate/master/bin/auto-update.sh -O $TMP_FILENAME_PATH
for host in $OpenWrtDevices; do
  echo "Connect to $host"
  ssh -oStrictHostKeyChecking=no "$host" "sh -s $ALLOW_UPDATE_RC $USER_PACKAGES" <$TMP_FILENAME_PATH
  if [ "$3" != "" ]; then
    ssh -oStrictHostKeyChecking=no "$host" "$EXTRA_COMMAND"
  fi
done
