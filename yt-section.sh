#!/bin/bash

# Define color escape codes
WHITE='\033[0;37m'
NC='\033[0m' # No Color
YELLOW='\033[0;33m'

# Check if all arguments are provided
if [ $# -ne 3 ]; then
	echo "Usage: $0 <start_time> <end_time> <video_id>"
	echo
	echo NOTE: Start-Time and End-Time must be written in [minutes]:[seconds]
	echo
	echo Example:
	echo
	echo   "#1: $0 00:00 00:30 YouTubeVidID"
	echo   "#2: $0 01:24 01:45 YouTubeVidID"
	echo
	echo Example 1: This will download the first 30 seconds of the video.
	echo Example 2: This will download the video section from 1min:24sec to 1min:45sec.
	exit 1
fi

# Assign arguments to variables
start_time="$1"
end_time="$2"
video_id="$3"

# Adding some screen information to the user
echo -e "${YELLOW}INFO:${NC} Downloading section from ID: $video_id"
echo -e "${YELLOW}INFO:${NC} Preparing to download"
echo -e "${YELLOW}INFO:${NC} Download section(s) from timestamp ${WHITE}$start_time${NC} and ${WHITE}$end_time${NC}"
echo -e "${YELLOW}INFO:${NC} Loading modules, please wait..."   

# Download specific section of the video
yt-dlp --download-sections *0:$start_time-0:$end_time -f "bestvideo[height<=2160][vcodec^=hevc][protocol!*=dash]/bestvideo[height<=2160][vcodec^=avc1][protocol!*=dash]+bestaudio[acodec^=mp4a]/best[height<=2160]" --merge-output-format mp4 --audio-quality 0 -o "%(title)s.%(ext)s" "https://www.youtube.com/watch?v=$video_id"

