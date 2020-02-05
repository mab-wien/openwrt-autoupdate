#!/bin/sh
CONFIG_PATH="/etc/auto-update.conf";

function checkAndSetConfig {
  if [ ! -f "$CONFIG_PATH" ]; then
      if [ "$1" == "" ]; then
        echo "Config not found ($CONFIG_PATH)";
        exit;
      fi
      echo "Create Config ($CONFIG_PATH)"
      touch $CONFIG_PATH;
      echo USER_PACKAGES=\"$@\" >> $CONFIG_PATH;
      cat $CONFIG_PATH;
  fi
  grep -c $CONFIG_PATH /etc/sysupgrade.conf >> /dev/null
  if [ "$?" != "0" ]
  then
    echo $CONFIG_PATH >> /etc/sysupgrade.conf;
  fi
}

checkAndSetConfig $@;
. /etc/os-release
. $CONFIG_PATH;
echo "System Version: $VERSION";
echo "Target: $OPENWRT_BOARD";
MODEL="$(cat /etc/board.json  |jsonfilter -e '@.model.id' | tr ',' '_')"
echo "Model: $MODEL";

CURRENT_VERSION="$(wget -q http://downloads.openwrt.org/releases/ -O - |grep -E '<a href="[0-9]+.[0-9]+.[0-9]+/">'|awk -F '</a>' '{print $1}'|awk -F '>' '{print $(NF)}'|sort -n -r|head -1)";
if [ "$CURRENT_VERSION" == "$VERSION" ]
then
  if [ "$USER_PACKAGES" != "" ]
  then
    opkg update
    opkg install $USER_PACKAGES;
  fi
  opkg list-upgradable;
  echo "System is up to date";
	exit;
fi
echo "Current Realease: $CURRENT_VERSION";


FILENAME="openwrt-$CURRENT_VERSION-$(echo $OPENWRT_BOARD | tr '/' '-' )-$MODEL-squashfs-sysupgrade.bin"
BASE_LINK="http://downloads.openwrt.org/releases/$CURRENT_VERSION/targets/$(echo $OPENWRT_BOARD | tr '-' '/' )/";
SHA256SUMS=$(wget $BASE_LINK/sha256sums -q -O -|grep $FILENAME | awk '{print $1}')
TARGET_PATH="/tmp/$FILENAME";
wget $BASE_LINK$FILENAME -O $TARGET_PATH
if [ "$?" != "0" ]
then
	echo "download error ($BASE_LINK$FILENAME)";
	exit;
fi
sha256sum $FILENAME | grep $SHA256SUMS
if [ "$?" != "0" ]
then
	echo "sha256sum error ($SHA256SUMS)";
	exit;
fi

sysupgrade -v $FILENAME;
