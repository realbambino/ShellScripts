#!/bin/bash

# Define color escape codes
WHITE='\033[0;37m'
NC='\033[0m' # No Color
YELLOW='\033[0;33m'

echo -e "${YELLOW}INFO:${NC} Opening download list"
echo -e "${YELLOW}INFO:${NC} Preparing to download"
echo -e "${YELLOW}INFO:${NC} Loading modules, please wait..."

# Download AAC files, no need to convert. Saving time in the process.
yt-dlp -a download.txt -x -f "bestaudio[acodec^=mp4a]" --audio-format m4a -o "%(title)s.%(ext)s"
echo -e "${YELLOW}INFO:${NC} ${WHITE}Download complete${NC}" 
