#!/bin/bash
CONFIG_PATH="/etc/auto-update.conf"

function checkAndSetConfig() {
  if [ ! -f "$CONFIG_PATH" ]; then
    if [ "$1" == "" ]; then
      echo "Config not found ($CONFIG_PATH)"
      exit
    fi
    echo "Create Config ($CONFIG_PATH)"
    touch $CONFIG_PATH
    # shellcheck disable=SC2145
    echo "USER_PACKAGES=\"$@\"" >>$CONFIG_PATH
    cat $CONFIG_PATH
  fi
  grep -c $CONFIG_PATH /etc/sysupgrade.conf >>/dev/null
  # shellcheck disable=SC2181
  if [ "$?" != "0" ]; then
    echo $CONFIG_PATH >>/etc/sysupgrade.conf
  fi
}

# shellcheck disable=SC2068
checkAndSetConfig $@
. /etc/os-release
# shellcheck disable=SC1090
. $CONFIG_PATH
echo "Hostname: $(grep hostname /etc/config/system | awk '{print $3}')"
echo "System Version: $VERSION"
echo "Target: $OPENWRT_BOARD"
MODEL="$(jsonfilter -e '@.model.id' <"/etc/board.json" | tr ',' '_')"
echo "Model: $MODEL"

opkg update
opkg install libustream-openssl
CURRENT_VERSION="$(wget --no-check-certificate -q https://downloads.openwrt.org/releases/ -O - | grep -E '<a href="[0-9]+.[0-9]+.[0-9]+/">' | awk -F '</a>' '{print $1}' | awk -F '>' '{print $(NF)}' | sort -n -r | head -1)"
# shellcheck disable=SC2181
if [ "$?" != "0" ]; then
  echo "wget error"
  exit
fi
if [ "$CURRENT_VERSION" == "" ]; then
  echo "error: current openwrt version not found"
  exit
fi
echo "Current Release: $CURRENT_VERSION"
if [ "$CURRENT_VERSION" == "$VERSION" ]; then
  echo "System up-to-date"
  if [ "$USER_PACKAGES" != "" ]; then
    #opkg update
    # shellcheck disable=SC2086
    opkg install $USER_PACKAGES
  fi
  opkg list-upgradable
  echo "Packages up-to-date"
  exit
fi
echo "sys-upgrade: $VERSION => $CURRENT_VERSION"

FILENAME="openwrt-$CURRENT_VERSION-$(echo "$OPENWRT_BOARD" | tr '/' '-')-$MODEL-squashfs-sysupgrade.bin"
BASE_LINK="https://downloads.openwrt.org/releases/$CURRENT_VERSION/targets/$(echo "$OPENWRT_BOARD" | tr '-' '/')/"
SHA256SUMS=$(wget --no-check-certificate "$BASE_LINK/sha256sums" -q -O - | grep "$FILENAME" | awk '{print $1}')
TARGET_PATH="/tmp/$FILENAME"
wget --no-check-certificate "$BASE_LINK$FILENAME" -O "$TARGET_PATH"
# shellcheck disable=SC2181
if [ "$?" != "0" ]; then
  echo "download error ($BASE_LINK$FILENAME)"
  exit
fi
sha256sum "$TARGET_PATH" | grep "$SHA256SUMS"
# shellcheck disable=SC2181
if [ "$?" != "0" ]; then
  echo "sha256sum error ($SHA256SUMS)"
  exit
fi

sysupgrade -v "$TARGET_PATH"
