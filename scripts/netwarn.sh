#!/bin/sh

# Some OS's like Ubuntu with LightDM *IGNORE* the above shebang line when this
# script is invcked from /usr/share/mate/autostart/netwarn-iiab-network.desktop
#
# WHAT HAPPENS: sh (dash) NOT BASH will always be run!  As confirmed by:
#
# ps -p $$    # Whereas 'echo $SHELL' DOES NOT show the actual running shell!
#
# RECAP: We hard-code the above '#!/bin/sh' for uniformity across all distros.

if [ -f /etc/iiab/install-flags/iiab-network-complete ]; then
    exit
fi

zenity --question --width=360 --text="IIAB needs to configure networking:\n\n► Internet must be live before you begin.\n►You might be prompted for your password.\n\nContinue?  (This can take 2-3 minutes)"
rc=$?
if [ "$rc" != "0" ]; then
    exit $rc
fi

x-terminal-emulator -e /usr/local/bin/iiab-network
rc=$?
if [ "$rc" != "0" ]; then
    zenity --warning --width=360 --text="iiab-network exited with error: $rc\n\nPlease review /opt/iiab/iiab/iiab-network.log"
    exit $rc
fi

zenity --question --width=360 --text="iiab-network complete.\n\nWould you like to REBOOT now?  (Recommended)"
if [ "$?" = "0" ]; then
    x-terminal-emulator -e "sudo reboot"
fi
