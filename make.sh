#!/bin/bash

# ... [rest of your script remains unchanged]

echo "Create Temp dir"
rm -rf "$tempdir"
mkdir -p "$systemdir"

if [ "$sourcetype" == "Aonly" ]; then
    echo "Warning: Aonly source detected, using P AOSP ramdisk"
    cd "$systemdir"
    tar xf "$prebuiltdir/ABrootDir.tar"
    cd "$LOCALDIR"
    echo "Making copy of source rom to temp"
    ( cd "$systempath" ; tar cf - . ) | ( cd "$systemdir/system" ; tar xf - )
    cd "$LOCALDIR"
    sed -i "/ro.build.system_root_image/d" "$systemdir/system/build.prop"
    sed -i "/ro.build.ab_update/d" "$systemdir/system/build.prop"
    echo "ro.build.system_root_image=false" >> "$systemdir/system/build.prop"
else
    echo "Making copy of source rom to temp"
    ( cd "$systempath" ; tar cf - . ) | ( cd "$systemdir" ; tar xf - )
    cd "$LOCALDIR"
    sed -i "/ro.build.system_root_image/d" "$systemdir/system/build.prop"
    sed -i "/ro.build.ab_update/d" "$systemdir/system/build.prop"
    echo "ro.build.system_root_image=true" >> "$systemdir/system/build.prop"
fi

# ... [rest of your script remains unchanged]

echo "Patching started..."
# ... [rest of your script remains unchanged]

echo "Remove Temp dir"
rm -rf "$tempdir"
