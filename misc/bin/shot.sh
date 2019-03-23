#!/bin/zsh

set -e # so it doesn't copy a bad url if you cancel an area select

#FNAME=$1
MODE=$1 #m(onitor), s(election), w(indow), maybe d(isplay)
UUID=$(uuidgen -r | cut -c1-6) # 6 digit uuid so people can't easily guess file urls. Don't use -t or else they'll know the uuid based on the time!
#DOMAIN=techfo.xyz # domain
#USER=arcana # ...
#REMOTE_PATH=/var/www/html/i/ # path to drop the file into
#REMOTE_URL=http://$DOMAIN/i/ # the url of where the file is on front-facing web
DATE=$(date +%F_%T) # date in the filename
FNAME=$DATE\-$UUID.png # filename = date+uuid
SS_DIR=~/Screenshots/ # local ss dir
SS=${SS_DIR}${FNAME} # full path

if [ -z "$MODE" ]
  then echo "no argument passed, doing default..."
  maim $SS
elif [ $MODE = "m" ]
  then
  # do some math, get which monitor the cursor is on, grab that monitor
  MOUSE_X=$(xdotool getmouselocation | awk '{ print $1 }' | cut -c3-6)
  if (( $MOUSE_X > 3439 ))
    then maim -g 2560x1440+3440+0  $SS
  else
    maim -g 3440x1440+0+0 $SS
  fi
elif [ $MODE = "sw" ]
  # requires that slop is compiled with opengl support and that you have a compositor such as compton
  then maim -s -b 1 $SS
elif [ $MODE = "s" ]
  # requires that slop is compiled with opengl support and that you have a compositor such as compton
  # grabs the full screen, then pops it open in feh     then moves feh to be displayed over all the windows
  # then we do a selection on *that*, to keep popups from closing
  # then we send a 'q' to close feh =)
  then maim | feh - -no-screen-clipping --no-xinerama & xdotool search --class --sync feh windowmove --sync 0 0 & maim -s -b 1 $SS && xdotool key q
elif [ $MODE = "w" ] || [ $MODE = "sw" ]
  then if [ $MODE = "w" ]
    then xwininfo -id $(xdotool getactivewindow) > /tmp/winfo
    else xwininfo > /tmp/winfo
  fi
  WIN_ID=$(cat /tmp/winfo | grep 'Window id' | awk '{ print $4 }')
  WIN_W=$(cat /tmp/winfo | grep 'Width' | awk '{ print $2 }')
  WIN_H=$(cat /tmp/winfo | grep 'Height' | awk '{ print $2 }')
  WIN_X=$(cat /tmp/winfo | grep 'Absolute upper-left X' | awk '{ print $4 }')
  WIN_Y=$(cat /tmp/winfo | grep 'Absolute upper-left Y' | awk '{ print $4 }')

  maim -g ${WIN_W}x${WIN_H}+${WIN_X}+${WIN_Y} $SS
elif [ $MODE = "h" ]
  then echo "modes: m = monitor, s = selection, w = window, sw = select window, nothing/other = default/all"
else
  echo "unknown mode, doing default..."
  maim $SS
fi

#scp  $SS $USER@$DOMAIN:$REMOTE_PATH &&

TYPE=$(file -b --mime-type "$SS") # if you want to copy the file to the clipboard instead of a url, comment that stuff out and use this instead
cat $SS | xclip -selection clipboard -t "$TYPE"

# I tried going through hell to figure out a way to get i3 to run this script with my ssh-agent loaded or something to that effect (my key has a passphrase). Apparently it's impossible to run this script outside a terminal if you use a key with a passphrase. Maybe I'm just terrible.

#echo "${REMOTE_URL}${FNAME}" | tr -d "\n" | xclip -i -selection clipboard
paplay /usr/share/sounds/freedesktop/stereo/bell.oga # aplay doesn't like to work if the device is being used at all

