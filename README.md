# openwrt-autoupdate
Automatic update of OpenWrt firmware image  and packages.
See http://downloads.openwrt.org/releases/
# Install

## First run
Create configuration with user packages, example
# local

````
opkg update
opkg install curl
USER_PACKAGES="curl";
curl -s https://raw.githubusercontent.com/easyinternetat/openwrt-autoupdate/master/bin/auto-update.sh | sh -s $USER_PACKAGES
````
# remote

````
OPENWRT_HOSTS="host1 host2";
USER_PACKAGES="luci-app-upnp luci-app-mwan3 tcpdump snmpd";
EXTRA_COMMAND="sleep 70 && reboot";
curl -s https://raw.githubusercontent.com/easyinternetat/openwrt-autoupdate/master/bin/remote-auto-update.sh | sh -s "$OPENWRT_HOSTS" "$USER_PACKAGES" "$EXTRA_COMMAND"
````

# Tested on
## Devices
- TP-Link Archer C7 v2
- TP-Link Archer C7 v4
- TP-Link Archer C7 v5
- D-Link DIR-860L B1
- GL.iNet GL-B1300 
## OpenWrt
- 19.07.0
- 19.07.1

# Notice
## ssh
use authorized_keys
