#!/bin/bash

alias umount="busybox umount"

# ... [rest of your script remains unchanged]

echo "Create Temp dir"
tempdir="/path/to/temp_directory"  # Replace this with your desired temporary directory path
rm -rf "$tempdir"
mkdir -p "$systemdir"

if [ "$sourcetype" == "Aonly" ]; then
    echo "Warning: Aonly source detected, using P AOSP ramdisk"
    cd "$systemdir"
    fakeroot tar xf "$prebuiltdir/ABrootDir.tar"
    cd "$LOCALDIR"
    echo "Making copy of source rom to temp"
    ( cd "$systempath" ; fakeroot tar cf - . ) | ( cd "$systemdir/system" ; fakeroot tar xf - )
    cd "$LOCALDIR"
    sed -i "/ro.build.system_root_image/d" "$systemdir/system/build.prop"
    sed -i "/ro.build.ab_update/d" "$systemdir/system/build.prop"
    echo "ro.build.system_root_image=false" >> "$systemdir/system/build.prop"
else
    echo "Making copy of source rom to temp"
    ( cd "$systempath" ; fakeroot tar cf - . ) | ( cd "$systemdir" ; fakeroot tar xf - )
    if [[ -e "$sourcepath/mounted.txt" ]]; then
        for p in $(cat "$sourcepath/mounted.txt"); do
            [[ $p = system ]] && continue
            [[ $p = vendor ]] && continue
            if [[ -L "$systemdir/system/$p" ]]; then
                fakeroot rm -rf "$systemdir/system/$p"
                mkdir "$systemdir/system/$p"
                fakeroot rm -rf "$systemdir/$p"
                ln -s "/system/$p" "$systemdir/$p"
                ( cd "$sourcepath/$p" ; fakeroot tar cf - . ) | ( cd "$systemdir/system/$p" ; fakeroot tar xf - )
            fi
        done
    fi
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
