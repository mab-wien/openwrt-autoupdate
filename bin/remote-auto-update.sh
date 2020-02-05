#!/bin/bash

if [ "$1" == "" ] || [ "$2" == "" ]  || [ "$3" != "" ]
then
  echo "usage $0 'host1 host2 host3' 'curl tcpdump'"
  exit;
fi

OpenWrtDevices="$1";
USER_PACKAGES="$2";
TMP_FILENAME_PATH="/tmp/openwrt-auto-update.sh";

cd /tmp/ || exit
wget https://raw.githubusercontent.com/mab-wien/openwrt-autoupdate/master/bin/auto-update.sh -O $TMP_FILENAME_PATH
for host in $OpenWrtDevices
do
  ssh -oStrictHostKeyChecking=no "$host" "sh -s $USER_PACKAGES" < $TMP_FILENAME_PATH
done
