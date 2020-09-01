#!/bin/bash

# Dependencies: imagemagick, i3lock-color-git, scrot, wmctrl (optional)
set -o errexit -o noclobber -o nounset

hue=(-level "0%,100%,0.6")
effect=(-resize 30% -define "filter:sigma=1" -resize 250%)
# default system sans-serif font
font=$(convert -list font | awk "{ a[NR] = \$2 } /family: $(fc-match sans -f "%{family}\n")/ { print a[NR-1]; exit }")
image=$(mktemp --suffix=.png)
desktop=""
i3lock_cmd=(i3lock -i "$image")
shot_custom=false

cp ~/Pictures/lock-screen.png $image

options="Options:
    -h, --help       This help menu.
    -d, --desktop    Attempt to minimize all windows before locking.
    -g, --greyscale  Set background to greyscale instead of color.
    -p, --pixelate   Pixelate the background instead of blur, runs faster.
    -f <fontname>, --font <fontname>  Set a custom font.
    -t <text>, --text <text> Set a custom text prompt.
    -l, --listfonts  Display a list of possible fonts for use with -f/--font.
                     Note: this option will not lock the screen, it displays
                     the list and exits immediately.
    -n, --nofork     Do not fork i3lock after starting.
    --               Must be last option. Set command to use for taking a
                     screenshot. Default is 'import -window root'. Using 'scrot'
                     or 'maim' will increase script speed and allow setting
                     custom flags like having a delay."

text="Type password to unlock"

bw="white"
icon=~/Pictures/lock.png
param=("--insidecolor=ffffff1c" "--ringcolor=ffffff3e" \
       "--linecolor=ffffff00" "--keyhlcolor=00000080" "--ringvercolor=00000000" \
       "--separatorcolor=22222260" "--insidevercolor=0000001c" \
       "--ringwrongcolor=00000055" "--insidewrongcolor=0000001c" \
       "--verifcolor=00000000" "--wrongcolor=ff000000" "--timecolor=00000000" \
       "--datecolor=00000000" "--layoutcolor=00000000")

convert "$image" "${hue[@]}" "${effect[@]}" -font "$font" -pointsize 26 -fill "$bw" -gravity center \
    -annotate +0+160 "$text" "$icon" -gravity center -composite "$image"

# If invoked with -d/--desktop, we'll attempt to minimize all windows (ie. show
# the desktop) before locking.
${desktop} ${desktop:+-k on}

# try to use i3lock with prepared parameters
if ! "${i3lock_cmd[@]}" "${param[@]}" >/dev/null 2>&1; then
    # We have failed, lets get back to stock one
    "${i3lock_cmd[@]}"
fi

# As above, if we were passed -d/--desktop, we'll attempt to restore all windows
# after unlocking.
${desktop} ${desktop:+-k off}
