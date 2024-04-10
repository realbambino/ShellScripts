#!/bin/bash

WHITE='\033[0;37m'
NC='\033[0m' # No Color
YELLOW='\033[0;33m'

echo -e "${YELLOW}INFO:${NC} Opening download list"
echo -e "${YELLOW}INFO:${NC} Preparing to download"
echo -e "${YELLOW}INFO:${NC} Loading modules, please wait..."
yt-dlp -a download.txt -f "bestvideo[height<=2160]+bestaudio[acodec^=mp4a]/best[height<=2160]" --merge-output-format mkv --audio-quality 0 --sub-langs all,-live_chat --embed-subs --embed-chapters --sponsorblock-mark all --merge-output-format mkv -o "%(title)s (4K).%(ext)s"
echo -e "${YELLOW}INFO:${NC} ${WHITE}Download complete${NC}" 
