#!/bin/bash

#argumant variables
LOOP=false
INTERVAL=30
UNIT=m

show_help() {
    echo "Options:"
    echo "  -l                             Make it loop forever."
    echo "  -i                             If looping, then how long to wait, for it to change. Default is 30."
    echo "  -u                             The unit to use for how long to wait. Accepted units are s, m, h, and d Default is m."
    echo "  -h                             Show this help message and exit"
    exit 0
}

#get the argumenets provided and assign them
while getopts 'hli:u:' flag; do
  case "${flag}" in
    l) LOOP=true ;;
    i) INTERVAL="${OPTARG}" ;;
    u) UNIT="${OPTARG}" ;;
    h | *)
        show_help
        exit 0
        ;;
  esac
done

change_wallpaper() {
    # Set the path to the wallpapers directory
    wallpapersDir="$HOME/Pictures/wallpapers"

    # Get a list of all image files in the wallpapers directory
    wallpapers=("$wallpapersDir"/*)

    # Check if the wallpapers array is empty
    if [ ${#wallpapers[@]} -eq 0 ]; then
        # If the array is empty, refill it with the image files
        wallpapers=("$wallpapersDir"/*)
    fi

    # Select a random wallpaper from the array
    wallpaperIndex=$(( RANDOM % ${#wallpapers[@]} ))
    selectedWallpaper="${wallpapers[$wallpaperIndex]}"

    # Update the lockscreen wallpwper
    cp "$selectedWallpaper" "$HOME/.config/hypr/.wallpaper_current"
}

if [ "$LOOP" = true ] ; then
    while true; do
        change_wallpaper
        sleep "$INTERVAL""$UNIT"
    done
else
    #just change the wallpaper once
    change_wallpaper
fi