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
ALLOW_UPDATE_RC="yes"
curl -s https://raw.githubusercontent.com/easyinternetat/openwrt-autoupdate/master/bin/auto-update.sh | bash -s $ALLOW_UPDATE_RC $USER_PACKAGES
````
# remote

````
OPENWRT_HOSTS="host1 host2";
USER_PACKAGES="luci-app-upnp luci-app-mwan3 tcpdump snmpd";
EXTRA_COMMAND="sleep 70 && reboot";
ALLOW_UPDATE_RC="yes"
curl -s https://raw.githubusercontent.com/easyinternetat/openwrt-autoupdate/master/bin/remote-auto-update.sh | bash -s "$OPENWRT_HOSTS" "$USER_PACKAGES" "$EXTRA_COMMAND" "$ALLOW_UPDATE_RC"
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
- 19.07.2
- 19.07.3
- 19.07.4
- 19.07.5
- 19.07.6
- 19.07.7

# Notice
## ssh
use authorized_keys
