#!/bin/bash

ICONS="$HOME/.local/share/icons"

name="Custom" # Papirus tweaks ft. Adwaita
color="nordic" # paleorange : #EECA8F

for size in 16x16 22x22 24x24 32x32 48x48 64x64 96x96 128x128; do
    for category in places mimetypes apps devices status; do
        mkdir -p "$ICONS"/"$name"/$category/${size%x*}
        ln -s "$ICONS"/Papirus-Dark/$size/$category/* "$ICONS"/"$name"/$category/${size%x*}/
    done
done

papirus-folders -C $color --theme Papirus-Dark

# Make symbolic folders use generic colored folder
cd "$ICONS"/"$name"/places/16 && rm inode-directory.svg
ln -s "$ICONS"/Papirus-Dark/16x16/places/folder-$color.svg inode-directory.svg
for icon in folder-*.svg; do
    rm "$icon"
    ln -s "$ICONS"/Papirus-Dark/16x16/places/folder-$color.svg "$icon"
done
# sed -i 's/#dfdfdf/#81A1C1/g' user-desktop.svg 

for size in 16 22 24 32 48 64 96 128; do # no folder icons
    cd "$ICONS"/"$name"/places/$size || exit
    
    for icon in folder-*.svg; do
        rm -f "$icon"
        ln -s "inode-directory.svg" "$icon"
    done
done

# Use Adwaita's executable icon
EXEC="/usr/share/icons/Adwaita/scalable/mimetypes/application-x-executable.svg"
fd -t l "(AppImage|application-(default-icon|x(-ms-dos)?-executable))\.svg$" \
        "$ICONS"/"$name" -x rm {} \; -x ln -s "$EXEC" {} \;


gtk-update-icon-cache -f "$ICONS"/"$name"
