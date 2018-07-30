LDID_PATH=`which ldid`
if [[ $LDID_PATH = "" ]]; then
	echo "ldid not installed"
	exit 0
fi

DPKG_PATH=`which dpkg-deb`
if [[ $DPKG_PATH = "" ]]; then
	echo "dpkg-deb not installed"
	exit 0
fi

rm -fr DerivedData/callkiller/Build/Products/Release-iphoneos/*
xcodebuild -project callkiller.xcodeproj -scheme callkiller -configuration Release clean
xcodebuild -project callkiller.xcodeproj \
		   -scheme callkiller \
		   -configuration Release \
		   MonkeyDevDeviceIP="" \
		   MonkeyDevInstallOnAnyBuild=NO \
		   VALIDATE_PRODUCT=NO \
		   build

if [[ $? -ne "0" ]]; then
	echo "callkiller build failed"
	exit 0
fi

xcodebuild -project callkiller.xcodeproj -scheme callkiller-gui -configuration Release clean
xcodebuild -project callkiller.xcodeproj \
		   -scheme callkiller-gui \
		   -configuration Release \
		   MonkeyDevDeviceIP="" \
		   MonkeyDevInstallOnAnyBuild=NO \
		   VALIDATE_PRODUCT=NO \
		   build

if [[ $? -ne "0" ]]; then
	echo "callkiller-gui build failed"
	exit 0
fi

sudo rm -fr dpkg-tmp
mkdir -p dpkg-tmp/var/mobile/callkiller
cp -r callkiller/Package/* dpkg-tmp/
cp phone-*.dat dpkg-tmp/var/mobile/callkiller/
rm -f dpkg-tmp/Library/.DS_Store
rm -f dpkg-tmp/Library/.gitignore
rm -f dpkg-tmp/Library/MobileSubstrate/.DS_Store
rm -f dpkg-tmp/Library/MobileSubstrate/.gitignore
rm -f dpkg-tmp/Library/MobileSubstrate/DynamicLibraries/.gitignore
rm -f dpkg-tmp/Library/MobileSubstrate/DynamicLibraries/.DS_Store
cp -f DerivedData/callkiller/Build/Products/Release-iphoneos/callkiller.dylib dpkg-tmp/Library/MobileSubstrate/DynamicLibraries/
mkdir -p dpkg-tmp/Applications
cp -fr DerivedData/callkiller/Build/Products/Release-iphoneos/callkiller-gui.app dpkg-tmp/Applications/
rm -f dpkg-tmp/Applications/callkiller-gui.app/embedded.mobileprovision

ldid -Scallkiller-gui/entitlements.xml dpkg-tmp/Applications/callkiller-gui.app/callkiller-gui

sudo chown -R root:wheel dpkg-tmp/Applications/callkiller-gui.app

rm -fr dpkg-tmp/DEBIAN/*
VERSION=`/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' callkiller-gui/Info.plist`
echo "Package: com.laoyur.callkiller" > dpkg-tmp/DEBIAN/control
echo "Name: CallKiller" >> dpkg-tmp/DEBIAN/control
echo "Version: ${VERSION}" >> dpkg-tmp/DEBIAN/control
cat >> dpkg-tmp/DEBIAN/control <<EOF
Description: kill the fvcking annoying spamming calls
Section: System
Pre-Depends: 
Depends: firmware (>= 10.0), mobilesubstrate
Conflicts: 
Replaces: 
Priority: optional
Architecture: iphoneos-arm
Author: laoyur
dev: 
Homepage: 
Depiction: 
Maintainer: laoyur
Icon: file:///Applications/callkiller-gui.app/AppIcon60x60@2x.png

EOF

cat > dpkg-tmp/DEBIAN/postinst << EOF
#!/bin/sh
chown -R mobile:mobile /var/mobile/callkiller
chmod -R 755 /var/mobile/callkiller
if [[ -e /var/mobile/callkiller-pref.json ]]; then
	chown mobile:mobile /var/mobile/callkiller-pref.json
	chmod 755 /var/mobile/callkiller-pref.json
fi
uicache
exit 0
EOF

cat > dpkg-tmp/DEBIAN/postrm << EOF
#!/bin/sh
uicache
exit 0
EOF

chmod a+x dpkg-tmp/DEBIAN/postinst
chmod a+x dpkg-tmp/DEBIAN/postrm

dpkg-deb -Z gzip --build dpkg-tmp callkiller-${VERSION}.deb
sudo rm -fr dpkg-tmp
