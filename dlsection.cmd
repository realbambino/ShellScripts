@echo off
echo Downloading video...
echo.
yt-dlp --download-sections "*0:%1-0:%2" -f "bestvideo[height<=2160][vcodec^=avc1][protocol!*=dash]+bestaudio[acodec^=mp4a]/best[height<=2160]" --merge-output-format mp4 --audio-quality 0 -o "%(title)s.%(ext)s" %3
echo.
echo Download completed.
