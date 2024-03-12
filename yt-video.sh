#!/bin/bash

echo Downloading files, please wait...
yt-dlp -a download.txt -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' --sub-langs all,-live_chat --embed-subs --embed-chapters --sponsorblock-mark all --merge-output-format mkv -o "%(title)s.%(ext)s"
echo
echo Download complete.
