#!/bin/bash

WHITE='\033[0;37m'
NC='\033[0m' # No Color
YELLOW='\033[0;33m'

echo -e "${YELLOW}INFO:${NC} Opening download list"
echo -e "${YELLOW}INFO:${NC} Preparing to download"
echo -e "${YELLOW}INFO:${NC} Loading modules, please wait..."
yt-dlp -a download.txt -f "bestvideo[height<=1080][vcodec^=hevc]/bestvideo[height<=1080][vcodec^=avc1]+bestaudio[acodec^=mp4a]/best[height<=1080]" --sub-langs all,-live_chat --embed-subs --embed-chapters --sponsorblock-mark all --merge-output-format mkv --audio-quality 0 -o "%(title)s (1080p).%(ext)s"
echo -e "${YELLOW}INFO:${NC} ${WHITE}Download complete${NC}"
