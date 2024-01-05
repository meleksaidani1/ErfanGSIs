#!/bin/bash

alias umount="busybox umount"

# ... [rest of your script remains unchanged]
# Project OEM-GSI Porter by Erfan Abdi <erfangplus@gmail.com>

usage() {
    echo "Usage: $0 <Path to Firmware partitions> <Firmware type> <Output type> [Output Dir]"
    echo -e "\tPath to Firmware partitions: Mounted system or all partitions mount point"
    echo -e "\tFirmware type: Firmware mode"
    echo -e "\tOutput type: AB or Aonly"
    echo -e "\tOutput Dir: set output dir"
}

if [ "$3" == "" ]; then
    echo "ERROR: Enter all needed parameters"
    usage
    exit 1
fi

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
    if [[ -e "$sourcepath/mounted.txt" ]]; then
        while IFS= read -r p; do
            [[ $p = system ]] && continue
            [[ $p = vendor ]] && continue
            if [[ -L "$systemdir/system/$p" ]]; then
                rm -rf "$systemdir/system/$p"
                mkdir "$systemdir/system/$p"
                rm -rf "$systemdir/$p"
                ln -s "/system/$p" "$systemdir/$p"
                ( cd "$sourcepath/$p" ; tar cf - . ) | ( cd "$systemdir/system/$p" ; tar xf - )
            fi
        done < "$sourcepath/mounted.txt"
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
