# EASY_YT-DLP 🎥🎵

## 🚀 About This Project

I’m a lazy beginner who just discovered `yt-dlp`, and I wanted to make my YouTube downloads as easy as possible — no terminal typing, no long commands, just a few keypresses.

**EASY_YT-DLP** is a fully interactive batch-based tool that simplifies downloading videos or MP3s with zero setup. It guides you through everything: picking formats, saving to organized folders, and keeping a log of what you downloaded.

---

## 📥 Download the All-in-One Script

To get started, **download the main batch file** from this repository:

[easy_yt-dlp_aio.bat](https://github.com/omr-abs/easy_yt-dlp/blob/main/easy_yt-dlp_aio.bat)

This is the all-in-one script you need—simply save it to your computer and run it to launch the tool.```

---

## ⚠️ Security & Antivirus Warning

Microsoft Edge (and some antivirus software) may flag `EASY_YT-DLP_ALL_IN_ONE.bat` as “unrecognized” or “potentially unsafe.” This happens because the script auto-downloads tools and isn’t code-signed. To run it:

1. When you see a SmartScreen warning, click **“More info”** then **“Run anyway.”**
2. If antivirus quarantines it, add the script’s folder as an exclusion/whitelist in your antivirus settings (or Windows Defender).

If you prefer not to bypass warnings, download `yt-dlp.exe` and FFmpeg manually (see “Manual Setup”), then run only the core `.bat` logic. Always review the script before running.  

---

## ✨ Features

- ✅ **Auto-detects and downloads** `yt-dlp.exe` and all required `ffmpeg` binaries (`ffmpeg.exe`, `ffplay.exe`, `ffprobe.exe`) if they’re missing  
- ✅ Automatically creates folders:
 - `EASY_YT-DLP DOWNLOADS/`
   - `Videos/`
   - `MP3/`
- ✅ Paste a YouTube or supported site URL — **clipboard is auto-detected**
- ✅ Automatically gets the **best available video+audio** or lets you **manually choose formats**
- ✅ Supports full **playlist downloads** and **multiple videos**
- ✅ Convert audio to **MP3** with one click
- ✅ Automatically merges **video + audio** using ffmpeg (only if compatible)
- ✅ Keeps a `download_history.txt` with:
   - `Video title`
   - `Format`
   - `Quality`
   - `Link`
   - `Date downloaded`
- ✅ Asks after every download if you want to grab another
- ✅ Supports **cookie-based login** (e.g., for private or age-restricted content)
- ✅ Portable — **no need to install anything system-wide**

---

## 📦 Installation & Setup

You **don’t need to install yt-dlp or ffmpeg manually**.

When you run the `.bat` file:
- If `yt-dlp.exe` is missing, it will download it from [yt-dlp GitHub](https://github.com/yt-dlp/yt-dlp)
- If `ffmpeg` binaries are missing, it will download the full archive from [gyan.dev](https://www.gyan.dev/ffmpeg/builds/), extract it, and place the necessary EXEs into the `ffmpeg_bin` folder

### Manual Setup (optional)
If you'd rather do it manually:

1. Download `yt-dlp.exe` from:  
 https://github.com/yt-dlp/yt-dlp/releases

2. Download the **FFmpeg Essentials ZIP** from:  
 https://www.gyan.dev/ffmpeg/builds/

3. Extract the 3 needed files into `ffmpeg_bin/`:
 - `ffmpeg.exe`
 - `ffplay.exe`
 - `ffprobe.exe`

---

## 🍪 Cookie Support

To download private, unlisted, or age-restricted videos:
- Use [Get cookies.txt](https://chrome.google.com/webstore/detail/get-cookiestxt/lcjhednjnlacjipfkejobcmlmglfbmaj?hl=en) extension for your browser
- Export cookies for YouTube
- Save the file as `cookies.txt` in the same folder as the script

---

### 🗂 Folder Structure (Simple View)

Make sure all these files and folders are in the **same main folder**, like `D:\YouTubeDownloader\`:

- `.bat` ← the script
- `yt-dlp.exe` ← download this from yt-dlp GitHub
- `youtube_cookies.txt` ← (optional) exported cookies file
- `ffmpeg_bin\` ← a folder (renamed from `bin`) that contains:
  - `ffmpeg.exe`
  - `ffprobe.exe`
  - `ffplay.exe` (optional)

---

## 🛠 Example Usage

Just double-click the `.bat` file.

- It detects clipboard URL
- Shows the video title
- Lets you download best or custom formats
- Saves in `Videos/` or `MP3/` folders
- Asks if you want to keep going

---

## 🙏 Credits

- 🛠 **[yt-dlp](https://github.com/yt-dlp/yt-dlp)** – Open-source download engine
- 🎬 **[FFmpeg](https://ffmpeg.org/)** – Used for merging and conversion

---
