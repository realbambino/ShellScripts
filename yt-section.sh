#!/bin/bash

# Define color escape codes
WHITE='\033[0;37m'
NC='\033[0m' # No Color
YELLOW='\033[0;33m'
RED='\033[0;31m'

# Check if all arguments are provided
if [ $# -ne 3 ]; then
	echo "Usage: $0 <start_time> <end_time> <video_id>"
	echo
	echo NOTE: Start-Time and End-Time must be written in [minutes]:[seconds]
	echo
	echo Example:
	echo
	echo   "#1: $0 00:00 00:30 YouTube_VidID"
	echo   "#2: $0 01:24 01:45 YouTube_VidID"
	echo
	echo Example 1: This will download the first 30 seconds of the video.
	echo Example 2: This will download the video section from 1min:24sec to 1min:45sec.
	exit 1
fi

# Assign arguments to variables
start_time="$1"
end_time="$2"
video_id="$3"
ull_link=""

# Get System Information
mac_version=$(sw_vers -productVersion)
mac_name=$(sw_vers -productName)
mac_build=$(sw_vers -buildVersion)
processor_name=$(sysctl -n machdep.cpu.brand_string)
cpu_core=$(sysctl -n machdep.cpu.core_count)
mac_kernel=$(uname -s)
mac_kernel_version=$(uname -r)
m_arch=$(uname -m)
m_cpu=$(uname -p)

echo -e "${YELLOW}INFO:${NC} Running on ${WHITE}$mac_name $mac_version${NC} on ${WHITE}$m_cpu${NC}"
echo -e "${YELLOW}INFO:${NC} Kernel version: ${WHITE}$mac_kernel ($mac_kernel_version)${NC}"

# Get total amount of RAM using sysctl
ram_info=$(sysctl -n hw.memsize)

# Convert bytes to gigabytes (GB)
ram_gb=$((ram_info / 1024 / 1024 / 1024))

# Print total amount of RAM
echo -e "${YELLOW}INFO:${NC} Current H/W: ${WHITE}$processor_name ($m_arch, $cpu_core core(s))${NC} with ${WHITE}$ram_gb GB${NC} RAM"

# Check if the argument contains the specific string
if [[ "$3" == *"youtube.com"* ]]; then
    # Contains full YouTube link
    echo -e "${YELLOW}INFO:${NC} Full VideoID URL detected: ${WHITE}$video_id${NC}"
    full_link=$3
    echo -e "${YELLOW}INFO:${NC} No additional padding required, full URL is already set"
else
    # No YouTube link, VidID only
    echo -e "${YELLOW}INFO:${NC} Partial VideoID URL detected: ${WHITE}$video_id${NC}"
    full_link="https://www.youtube.com/watch?v="$3
    echo -e "${YELLOW}INFO:${NC} Additional padding required"
    echo -e "${YELLOW}INFO:${NC} Full URL is set to: ${WHITE}'$full_link'${NC}"
fi

# Check for FFMPEG
command_to_check="ffmpeg"

# Check for FFPROBE
command_to_check="ffprobe"
echo -e "${YELLOW}INFO:${NC} Checking for ${WHITE}FFMPEG${NC} & ${WHITE}FFPROBE${NC}"

# Check if the FFMPEG-command is available
if command -v "$command_to_check" &> /dev/null; then
    echo -e "${YELLOW}INFO:${NC} FFMPEG is currently ${WHITE}installed${NC} on this computer"
else
    echo -e "${RED}WARNING:${NC} FFMPEG is currently ${RED}NOT installed${NC} on this computer"
fi

# Check if the FFPROBE-command is available
if command -v "$command_to_check" &> /dev/null; then
    echo -e "${YELLOW}INFO:${NC} FFPROBE is currently ${WHITE}installed${NC} on this computer"
else
    echo -e "${RED}WARNING:${NC} FFPROBE is currently ${RED}NOT installed${NC} on this computer"
fi

# Adding some screen information to the user
echo -e "${YELLOW}INFO:${NC} Set download section from timestamp: ${WHITE}$start_time${NC} and ${WHITE}$end_time${NC}"
echo -e "${YELLOW}INFO:${NC} Loading modules, please wait..."

# Download specific section of the video
yt-dlp --download-sections *0:$start_time-0:$end_time -f "bestvideo[height<=2160][protocol!*=dash]+bestaudio/best[height<=2160]" -o "downloaded_video.%(ext)s" "$full_link"

# Convert the audio to AAC using FFMPEG
echo -e "${YELLOW}INFO:${NC} Converting audio to ${WHITE}AAC${NC}"
ffmpeg -i 'downloaded_video.webm' -c:v copy -c:a aac -loglevel quiet -strict experimental 'downloaded_video.mp4'

# Removing the old video
echo -e "${YELLOW}INFO:${NC} Cleaning up"
rm 'downloaded_video.webm'

# Download completed
echo -e "${YELLOW}INFO:${NC} ${WHITE}Download complete${NC}"
