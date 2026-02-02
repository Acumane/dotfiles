#!/bin/bash

ICONS="$HOME/.local/share/icons"
PAPIRUS="/usr/share/icons/Papirus-Dark"

name="Custom" # Papirus tweaks ft. Adwaita
color="nordic" # paleorange : #EECA8F

categories=(places mimetypes devices status)
sizes=(16 22 24 32 48 64 96 128)

for size in "${sizes[@]}"; do
    for cat in "${categories[@]}"; do
        mkdir -p "$ICONS"/"$name"/$cat/$size
        ln -s "$PAPIRUS"/${size}x${size}/$cat/* "$ICONS"/"$name"/$cat/$size/
    done
done

papirus-folders -C $color --theme Papirus-Dark

# Make symbolic folders use generic colored folder
cd "$ICONS"/"$name"/places/16 && rm inode-directory.svg
ln -s "$PAPIRUS"/16x16/places/folder-$color.svg inode-directory.svg
for icon in folder-*.svg; do
    rm "$icon"
    ln -s "$PAPIRUS"/16x16/places/folder-$color.svg "$icon"
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

# Generate index.theme
declare -A ctx=([places]=Places [mimetypes]=MimeTypes [devices]=Devices [status]=Status)
dirs=$(for cat in "${categories[@]}"; do printf "$cat/%s," "${sizes[@]}"; done | sed 's/,$//')
{
    cat <<-EOF
	[Icon Theme]
	Name=$name
	Inherits=Adwaita,Papirus-Dark

	Directories=$dirs

	EOF
    for cat in "${categories[@]}"; do
        for size in "${sizes[@]}"; do
            echo -e "[$cat/$size]\nSize=$size\nContext=${ctx[$cat]}\nType=Fixed\n"
        done
    done
} > "$ICONS"/"$name"/index.theme

gtk-update-icon-cache -f "$ICONS"/"$name"
