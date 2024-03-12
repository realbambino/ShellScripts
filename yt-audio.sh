#!/bin/bash

echo Downloading files, please wait...
yt-dlp -a download.txt -x -f "bestaudio" --audio-format mp3 --audio-quality 192K -o "%(title)s.%(ext)s" 
echo
echo Download complete.