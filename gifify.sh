#!/bin/bash
# Create high-quality GIFs from MP4 movies.
# usage gifify.sh <original_movie_file.mp4>

# This line creates a new sped-up video
# This part "setpts=1.0*PTS" scales the speed of the video with 1.0 being original speed and 0.5 being twice as fast.
# Use this to speed up videos so they fit in the 15MB Twitter limit, or to do time lapses from your source video.
#ffmpeg -y -ss 0:00:04 -t 00:00:23 -i "$1" -an -filter:v "setpts=1.0*PTS" "$1_gif.mp4" 

# fps=50 is because that's the fastest framerate Twitter or Chrome on mobile can render GIFS
# we scale to 480 width for Twitter
# This line generates an optimal palette for the GIF as a PNG from the sped up video.
# ffmpeg -y -i "$1_gif.mp4" -vf fps=50,scale=480:-1:flags=lanczos,palettegen "$1_palette.png"
# ffmpeg -y -i "$1_gif.mp4" -vf fps=40,scale=480:-1:flags=lanczos,palettegen "$1_palette.png"
# ffmpeg -y -i "$1_gif.mp4" -vf fps=50,scale=480:-1:flags=lanczos,palettegen  "$1_palette.png"
ffmpeg -y -i "$1" -filter_complex "fps=50,scale=480:-1:flags=lanczos,palettegen"  "$1_palette.png"

# This line creates the final GIF from from the sped up video and the palette PNG
ffmpeg -y -i "$1" -i "$1_palette.png" -filter_complex "fps=50,scale=480:-1:flags=lanczos [x]; [x][1:v] paletteuse"  "$1.gif"