#!/bin/bash

echo Downloading files, please wait...
yt-dlp -a download.txt -f "bestvideo[height<=2160]+bestaudio[acodec^=mp4a]/best[height<=2160]" --merge-output-format mkv --audio-quality 0 --sub-langs all,-live_chat --embed-subs --embed-chapters --sponsorblock-mark all --merge-output-format mkv -o "%(title)s (4K).%(ext)s"
echo
echo Download complete.