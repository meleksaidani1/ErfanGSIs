#!/bin/bash

echo "Create Temp dir"
tempdir="/data/data/com.termux/files/home/temp_directory"  # Replace this with your desired temporary directory path
rm -rf "$tempdir"
mkdir -p "$systemdir"

if [ "$sourcetype" == "Aonly" ]; then
    echo "Warning: Aonly source detected, using P AOSP ramdisk"
    cd "$systemdir"
    # Replace the following line with the appropriate extraction command compatible with Termux
    # fakeroot tar xf "$prebuiltdir/ABrootDir.tar"
    cd "$LOCALDIR"
    echo "Making copy of source rom to temp"
    # Replace the following line with the appropriate copy command compatible with Termux
    # ( cd "$systempath" ; fakeroot tar cf - . ) | ( cd "$systemdir/system" ; fakeroot tar xf - )
    cd "$LOCALDIR"
    # Replace the following lines with the appropriate sed commands compatible with Termux
    # sed -i "/ro.build.system_root_image/d" "$systemdir/system/build.prop"
    # sed -i "/ro.build.ab_update/d" "$systemdir/system/build.prop"
    # echo "ro.build.system_root_image=false" >> "$systemdir/system/build.prop"
else
    echo "Making copy of source rom to temp"
    # Replace the following line with the appropriate copy command compatible with Termux
    # ( cd "$systempath" ; fakeroot tar cf - . ) | ( cd "$systemdir" ; fakeroot tar xf - )
    if [[ -e "$sourcepath/mounted.txt" ]]; then
        for p in $(cat "$sourcepath/mounted.txt"); do
            [[ $p = system ]] && continue
            [[ $p = vendor ]] && continue
            if [[ -L "$systemdir/system/$p" ]]; then
                # Replace the following lines with the appropriate file manipulation commands compatible with Termux
                # fakeroot rm -rf "$systemdir/system/$p"
                # mkdir "$systemdir/system/$p"
                # fakeroot rm -rf "$systemdir/$p"
                # ln -s "/system/$p" "$systemdir/$p"
                # ( cd "$sourcepath/$p" ; fakeroot tar cf - . ) | ( cd "$systemdir/system/$p" ; fakeroot tar xf - )
            fi
        done
    fi
    cd "$LOCALDIR"
    # Replace the following lines with the appropriate sed commands compatible with Termux
    # sed -i "/ro.build.system_root_image/d" "$systemdir/system/build.prop"
    # sed -i "/ro.build.ab_update/d" "$systemdir/system/build.prop"
    # echo "ro.build.system_root_image=true" >> "$systemdir/system/build.prop"
fi

# ... [rest of your script remains unchanged]

echo "Patching started..."
# ... [rest of your script remains unchanged]

echo "Remove Temp dir"
rm -rf "$tempdir"
