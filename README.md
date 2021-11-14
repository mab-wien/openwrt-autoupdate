# openwrt-autoupdate [deprecated] (closed)
Automatic update of OpenWrt firmware image and packages.
## See
- http://downloads.openwrt.org/releases/
- https://openwrt.org/docs/guide-user/installation/sysupgrade.cli
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
## OpenWrt 19.XX
- 19.07.0
- 19.07.1
- 19.07.2
- 19.07.3
- 19.07.4
- 19.07.5
- 19.07.6
- 19.07.7
## OpenWrt 21.02.0.rcX
- 21.02.0-rc1 (use Param ALLOW_UPDATE_RC)
  - D-Link DIR-860L B1 not work => from 19.07.7  (See https://git.openwrt.org/?p=openwrt/openwrt.git;a=commit;h=494f12c52df6767ec0fabf2b2fac8f453323a4c5, Image version mismatch: image 1.1, device 1.0. Please wipe config during upgrade (force required) or reinstall. Reason: Config cannot be migrated from swconfig to DSA)
  - TP-Link Archer C7 v2 (OK from 19.07.7)
  - TP-Link Archer C7 v4 (OK from 19.07.7)
- 21.02.0-rc3 (from 21.02.0-rc1)
## OpenWrt 21.XX
- 21.02.1
# Notice
## ssh
use authorized_keys
