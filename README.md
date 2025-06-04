# easy_yt-dlp

## 🎯 About This Project

I’m a lazy person who just stumbled upon yt-dlp — and I didn’t want to type commands every time I wanted to download a song, a playlist, or some random YouTube video.  

So, I made this interactive batch tool to make my life easier.

This script is designed for people like me who want to:

- ✅ Paste a YouTube link or playlist and download instantly — no commands needed  
- ✅ Automatically get the **best available video+audio** (e.g. 1080p60, 4K), or manually pick formats  
- ✅ Download full playlists or multiple videos at once  
- ✅ Convert audio to MP3 with one click  
- ✅ Automatically **merge video and audio** using `ffmpeg` when needed  
- ✅ Use **cookie-based login** to access private or age-restricted videos  
- ✅ Choose the **download folder**, with history logging to keep track  
- ✅ Stay **fully portable** — uses a local `ffmpeg_bin` folder with no system install required  

All this — without needing to remember or type any yt-dlp commands. It's simple, fast, and portable — and you don’t need to install anything system-wide.

Enjoy!

---

## ⚙️ Setup Instructions

Follow these steps to get everything working locally:

### 📦 1. Download `yt-dlp.exe`

- Go to [yt-dlp Releases](https://github.com/yt-dlp/yt-dlp/releases/latest)
- Download the `yt-dlp.exe` file
- Place it in the same folder as the `yt-dlp-helper.bat` script

---

### 🎞️ 2. Install `ffmpeg` Locally

This script looks for `ffmpeg` in a folder named `ffmpeg_bin` located **next to the batch script**.

#### 🪜 Steps:
1. Go to the official FFmpeg download page: [https://ffmpeg.org/download.html](https://ffmpeg.org/download.html)
2. Click “Windows” → download a pre-built zip (e.g. from `gyan.dev` or `BtbN`)
3. Extract the `bin/` folder from the zip
4. Rename that `bin` folder to: "ffmpeg_bin"
5. Place the entire `ffmpeg_bin` folder in the same directory as your `.bat` script

---

### 🗂 Folder Structure
Make sure all these files and folders are in the **same main folder**, like `D:\YouTubeDownloader\`:

- `yt-dlp-helper.bat` ← the script
- `yt-dlp.exe` ← download this from yt-dlp GitHub
- `youtube_cookies.txt` ← (optional) exported cookies file
- `ffmpeg_bin\` ← a folder (renamed from `bin`) that contains:
  - `ffmpeg.exe`
  - `ffprobe.exe`
  - `ffplay.exe` (optional)

---

### 🍪 3. (Optional) Use YouTube Cookies for Restricted Videos

Some videos (e.g. age-restricted, unlisted, or private) won’t download unless you're logged in.

You can export your YouTube cookies and use them with this script.

#### 🪜 Steps:

1. Install the browser extension [**Get cookies.txt**](https://chrome.google.com/webstore/detail/get-cookiestxt/lmjnegcaeklhafolokijcfjliaokphfk)
2. Go to `https://www.youtube.com` and make sure you're logged in
3. Click the extension icon → “Export” cookies
4. Save the file as: "youtube_cookies.txt"
5. Place it in the same folder as the `.bat` script

If this file exists, the script will automatically use it to authenticate your session.

---

✅ That’s it! You can now double-click `yt-dlp-helper.bat` and start downloading videos or audio with ease!

---

## 🙏 Credits

- **[yt-dlp](https://github.com/yt-dlp/yt-dlp)** — A powerful YouTube video downloader and fork of `youtube-dl`, maintained by an active open-source community.  
- **[FFmpeg](https://ffmpeg.org/)** — The industry-standard tool for handling audio/video encoding, decoding, transcoding, and merging.
