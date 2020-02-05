# openwrt-autoupdate
Automatic update of OpenWrt firmware image  and packages.
See http://downloads.openwrt.org/releases/
# Install

## First run
Create configuration with user packages, example

``
USER_PACKAGES="luci-app-upnp luci-app-mwan3 tcpdump snmpd luci-app-openvpn openvpn-openssl";
sh <(wget -O - https://raw.githubusercontent.com/mab-wien/openwrt-autoupdate/master/bin/auto-update.sh $USER_PACKAGES)
``

# Tested on
## Devices
- TP-Link Archer C7 v2
- TP-Link Archer C7 v4
- TP-Link Archer C7 v5
- D-Link DIR-860L B1
## OpenWrt
- 19.07.0
- 19.07.1
