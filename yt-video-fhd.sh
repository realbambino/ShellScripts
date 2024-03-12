#!/bin/bash

echo Downloading files, please wait...
yt-dlp -a download.txt -f "bestvideo[height<=1080][vcodec^=hevc]/bestvideo[height<=1080][vcodec^=avc1]+bestaudio[acodec^=mp4a]/best[height<=1080]" --sub-langs all,-live_chat --embed-subs --embed-chapters --sponsorblock-mark all --merge-output-format mkv --audio-quality 0 -o "%(title)s (1080p).%(ext)s"
echo
echo Download complete.