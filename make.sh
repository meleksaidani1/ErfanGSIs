#!/bin/bash

# ... [rest of your script remains unchanged]

echo "Create Temp dir"
tempdir="/data/data/com.termux/files/home/temp"  # Replace this with your desired temporary directory path in Termux
rm -rf "$tempdir"
mkdir -p "$tempdir"

if [ "$sourcetype" == "Aonly" ]; then
    echo "Warning: Aonly source detected, using P AOSP ramdisk"
    cd "$systemdir"
    tar xf "$prebuiltdir/ABrootDir.tar"
    cd "$LOCALDIR"
    echo "Making copy of source rom to temp"
    ( cd "$systempath" ; tar cf - . ) | ( cd "$systemdir/system" ; tar xf - )
    cd "$LOCALDIR"
    # Modify the following lines to edit build.prop without using sed or modify permissions if possible in Termux
    echo "ro.build.system_root_image=false" >> "$systemdir/system/build.prop"
else
    echo "Making copy of source rom to temp"
    ( cd "$systempath" ; tar cf - . ) | ( cd "$systemdir" ; tar xf - )
    if [[ -e "$sourcepath/mounted.txt" ]]; then
        for p in $(cat "$sourcepath/mounted.txt"); do
            [[ $p = system ]] && continue
            [[ $p = vendor ]] && continue
            if [[ -L "$systemdir/system/$p" ]]; then
                rm -rf "$systemdir/system/$p"
                mkdir "$systemdir/system/$p"
                rm -rf "$systemdir/$p"
                ln -s "/system/$p" "$systemdir/$p"
                ( cd "$sourcepath/$p" ; tar cf - . ) | ( cd "$systemdir/system/$p" ; tar xf - )
            fi
        done
    fi
    cd "$LOCALDIR"
    # Modify the following lines to edit build.prop without using sed or modify permissions if possible in Termux
    echo "ro.build.system_root_image=true" >> "$systemdir/system/build.prop"
fi

# ... [rest of your script remains unchanged]

echo "Patching started..."
# ... [rest of your script remains unchanged]

echo "Remove Temp dir"
rm -rf "$tempdir"
