DEVICE_IP="192.168.1.93"
if [[ $# -gt "0" ]]; then
	DEVICE_IP=$1
fi

VERSION=`/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' callkiller-gui/Info.plist`

scp callkiller-${VERSION}.deb root@$DEVICE_IP:/tmp/callkiller.deb
ssh root@$DEVICE_IP <<-'ENDSSH'
    dpkg -i /tmp/callkiller.deb
ENDSSH
