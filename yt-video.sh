#!/bin/bash

WHITE='\033[0;37m'
NC='\033[0m' # No Color
YELLOW='\033[0;33m'

echo -e "${YELLOW}INFO:${NC} Opening download list"
echo -e "${YELLOW}INFO:${NC} Preparing to download"
echo -e "${YELLOW}INFO:${NC} Loading modules, please wait..."
yt-dlp -a download.txt -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' --sub-langs all,-live_chat --embed-subs --embed-chapters --sponsorblock-mark all --merge-output-format mkv -o "%(title)s.%(ext)s"
echo -e "${YELLOW}INFO:${NC} ${WHITE}Download complete${NC}"
