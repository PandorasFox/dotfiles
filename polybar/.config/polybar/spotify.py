#!/bin/python

import sys
import dbus
import argparse


parser = argparse.ArgumentParser()
parser.add_argument(
    '-t',
    '--trunclen',
    type=int,
    metavar='trunclen'
)
parser.add_argument(
    '-f',
    '--format',
    type=str,
    metavar='custom format',
    dest='custom_format'
)
parser.add_argument(
    '--font',
    type=str,
    metavar='the index of the font to use for the main label',
    dest='font'
)


args = parser.parse_args()

def fix_string(string):
    # corrects encoding for the python version used
    if sys.version_info.major == 3:
        return string
    else:
        return string.encode('utf-8')

SPOTIFY_GREEN = "#1DB954"

# Default parameters
output = fix_string(u'{play_pause} {artist} | {album}: {song}')
trunclen = 50
play_pause = fix_string(u'\uf04b,\uf04c') # first character is play, second is paused

label_with_font = '%{{T{font}}}{label}%{{T-}}'
font = args.font

# parameters can be overwritten by args
if args.trunclen is not None:
    trunclen = args.trunclen
if args.custom_format is not None:
    output = args.custom_format

try:
    session_bus = dbus.SessionBus()
    spotify_bus = session_bus.get_object(
        'org.mpris.MediaPlayer2.spotify',
        '/org/mpris/MediaPlayer2'
    )

    spotify_properties = dbus.Interface(
        spotify_bus,
        'org.freedesktop.DBus.Properties'
    )

    metadata = spotify_properties.Get('org.mpris.MediaPlayer2.Player', 'Metadata')
    status = spotify_properties.Get('org.mpris.MediaPlayer2.Player', 'PlaybackStatus')

    # Handle play/pause label

    if status == 'Playing':
        play_pause = f"%{{B{SPOTIFY_GREEN}}}%{{F#ffffff}}"
        powerline_start = f"%{{B{SPOTIFY_GREEN}}}%{{F#222222}}%{{B- F-}}"
        powerline_end = f"%{{B#222222}}%{{F{SPOTIFY_GREEN}}}%{{B- F-}}"
    elif status == 'Paused':
        play_pause = f"%{{B#222222}}%{{F{SPOTIFY_GREEN}}}"
        powerline_start = f"%{{B#222222}}%{{F{SPOTIFY_GREEN}}}%{{B- F-}}"
        powerline_end = f"%{{B#222222}}%{{F{SPOTIFY_GREEN}}}%{{B- F-}}"
    else:
        play_pause = str()

    # Handle main label

    artist = fix_string(metadata['xesam:artist'][0]) if metadata['xesam:artist'] else ''
    album = fix_string(metadata['xesam:album']) if metadata['xesam:album'] else ''
    song = fix_string(metadata['xesam:title']) if metadata['xesam:title'] else ''

    if not artist and not song and not album:
        print('')
    else:
        if len(song) > trunclen:
            song = song[0:trunclen]
            song += '...'
            if ('(' in song) and (')' not in song):
                song += ')'

        if font:
            artist = label_with_font.format(font=font, label=artist)
            song = label_with_font.format(font=font, label=song)
            album = label_with_font.format(font=font, label=album)

        spotify_logo = " ".format("utf-8")
        reset_color = "%{B- F-}"
        text = (powerline_start +
                output.format(
                    artist=artist,
                    song=song,
                    album=album,
                    play_pause=play_pause
                ) +
                spotify_logo + " " +
                reset_color +
                powerline_end
        )
        
        print(text)

except Exception as e:
    if isinstance(e, dbus.exceptions.DBusException):
        print('')
    else:
        print(e)

