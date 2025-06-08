@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

pushd "%~dp0"
echo ────────────────────────────────────────────────────
echo            EASY_YT-DLP Setup & Tor Auto-Download
echo ────────────────────────────────────────────────────

:: --- 1) Auto-download tor.exe if missing ---
echo [1/8] Checking for tor.exe…
if not exist "tor\tor.exe" (
    echo [Info] tor.exe not found. Downloading from GitHub…
    set "TOR_URL=https://raw.githubusercontent.com/omr-abs/easy_yt-dlp/main/tor.exe"
    powershell -Command "Invoke-WebRequest -Uri '!TOR_URL!' -OutFile tor.exe -UseBasicParsing"
    if not exist "tor.exe" (
        echo [Error] Failed to download tor.exe
        pause
        exit /b
    )
    mkdir "tor" 2>nul
    move /Y tor.exe "tor\" >nul
    echo [OK] tor.exe installed to tor\
) else (
    echo [OK] tor.exe already present.
)

:: --- 2) Launch & verify Tor proxy ---
echo [2/8] Launching Tor…
start "" /min "%~dp0tor\tor.exe"
echo [Info] Waiting 10 seconds for Tor to bootstrap…
timeout /t 10 /nobreak >nul
echo [3/8] Verifying Tor proxy on 127.0.0.1:9050…
powershell -noprofile -command ^
 "if ((Test-NetConnection -ComputerName 127.0.0.1 -Port 9050).TcpTestSucceeded) { exit 0 } else { exit 1 }"
if errorlevel 1 (
    echo [Warn] Tor proxy unreachable on port 9050.
    choice /M "Continue WITHOUT Tor?"
    if errorlevel 2 exit /b
    set "PROXY_FLAG="
) else (
    echo [OK] Tor proxy is up.
    set "PROXY_FLAG=--proxy socks5h://127.0.0.1:9050"
)

:: --- 3) Ensure yt-dlp.exe ---
echo [4/8] Checking for yt-dlp.exe…
if not exist "yt-dlp.exe" (
    echo [Info] Downloading yt-dlp.exe…
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe' -OutFile yt-dlp.exe -UseBasicParsing"
    if not exist "yt-dlp.exe" (
        echo [Error] Failed to download yt-dlp.exe. Exiting.
        pause
        exit /b
    )
    echo [OK] yt-dlp.exe downloaded.
) else (
    echo [OK] yt-dlp.exe found.
)

:: --- 4) Ensure ffmpeg binaries ---
echo [5/8] Checking for FFmpeg…
if not exist "ffmpeg_bin\ffmpeg.exe" (
    echo [Info] Downloading FFmpeg Essentials…
    powershell -Command "Invoke-WebRequest -Uri 'https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip' -OutFile ffmpeg.zip -UseBasicParsing"
    echo [Info] Extracting FFmpeg…
    powershell -Command "Expand-Archive -Path ffmpeg.zip -DestinationPath ffmpeg_tmp -Force"
    for /D %%D in (ffmpeg_tmp\*) do (
        copy "%%D\bin\ffmpeg.exe" "ffmpeg_bin\" >nul
        copy "%%D\bin\ffplay.exe" "ffmpeg_bin\" >nul
        copy "%%D\bin\ffprobe.exe" "ffmpeg_bin\" >nul
    )
    rmdir /S /Q ffmpeg_tmp
    del ffmpeg.zip
    echo [OK] FFmpeg binaries installed.
) else (
    echo [OK] FFmpeg binaries present.
)

:: Add ffmpeg to PATH
set "PATH=%~dp0ffmpeg_bin;%PATH%"

:: --- 5) Configure cookies + proxy + format flags ---
echo [6/8] Configuring download flags…
set "COOKIE_FLAG=--cookies-from-browser firefox"
set "FORMAT_FLAG=bestvideo[ext=mp4]+bestaudio[ext=m4a]/best"
echo [OK] Flags set: !COOKIE_FLAG! !PROXY_FLAG! !FORMAT_FLAG!

:START
cls
echo ============================================
echo             EASY_YT-DLP Download
echo ============================================

:: --- A) URL & Title (public fetch) ---
echo [7/8] Detecting URL from clipboard…
for /F "delims=" %%C in ('powershell -noprofile -command "Get-Clipboard"') do set "URLS=%%C"
for /F "delims=" %%T in ('yt-dlp.exe --get-title "!URLS!" 2^>nul') do set "VIDTITLE=%%T"
if not defined VIDTITLE (
    echo [Warn] No valid URL/title in clipboard.
    set /P "URLS=Enter YouTube (or supported) URL: "
    for /F "delims=" %%T in ('yt-dlp.exe --get-title "!URLS!" 2^>nul') do set "VIDTITLE=%%T"
)
echo [Video] "!VIDTITLE!"
choice /M "Proceed with this video?"
if errorlevel 2 goto START

:: --- B) Download folder choice ---
echo.
echo Default root: %USERPROFILE%\Downloads\EASY_YT-DLP DOWNLOADS
choice /M "Use default folder?"
if errorlevel 2 (
    set /P "ROOT=Enter custom download folder: "
    set "ISDEF=0"
) else (
    set "ROOT=%USERPROFILE%\Downloads\EASY_YT-DLP DOWNLOADS"
    set "ISDEF=1"
)
if not exist "!ROOT!" mkdir "!ROOT!"

if "!ISDEF!"=="1" (
    set "VIDFOLDER=!ROOT!\Videos"
    set "MP3FOLDER=!ROOT!\MP3"
) else (
    set "VIDFOLDER=!ROOT!"
    set "MP3FOLDER=!ROOT!"
)
if not exist "!VIDFOLDER!" mkdir "!VIDFOLDER!"
if not exist "!MP3FOLDER!" mkdir "!MP3FOLDER!"

:: --- C) Download type & execution ---
echo.
echo 1) Auto best video+audio
echo 2) Audio only (MP3)
echo 3) Manual format codes
set /P "CHOICE=Select [1-3] (default=1): "
if "!CHOICE!"=="" set "CHOICE=1"

if "!CHOICE!"=="2" (
    echo [Download] MP3 with metadata…
    yt-dlp.exe !COOKIE_FLAG! !PROXY_FLAG! --extract-audio --audio-format mp3 --audio-quality 0 ^
      --embed-thumbnail --add-metadata -o "!MP3FOLDER!\%%(title)s.%%(ext)s" "!URLS!"
    echo [!DATE! !TIME!] "!VIDTITLE!" ^| MP3 ^| !URLS!>>"%~dp0download_history.txt"
) else if "!CHOICE!"=="3" (
    echo [Download] Fetching formats…
    yt-dlp.exe !COOKIE_FLAG! !PROXY_FLAG! -F "!URLS!"
    set /P "VF=Video format code: "
    set /P "AF=Audio format code: "
    echo [Download] Video+Audio !VF!+!AF!…
    yt-dlp.exe !COOKIE_FLAG! !PROXY_FLAG! -f "!VF!+!AF!" --merge-output-format mp4 ^
      -o "!VIDFOLDER!\%%(title)s.%%(ext)s" "!URLS!"
    echo [!DATE! !TIME!] "!VIDTITLE!" ^| Manual !VF!+!AF! ^| !URLS!>>"%~dp0download_history.txt"
) else (
    echo [Download] Best video+audio…
    yt-dlp.exe !COOKIE_FLAG! !PROXY_FLAG! -f "!FORMAT_FLAG!" ^
      -o "!VIDFOLDER!\%%(title)s.%%(ext)s" "!URLS!"
    echo [!DATE! !TIME!] "!VIDTITLE!" ^| Auto best ^| !URLS!>>"%~dp0download_history.txt"
)

echo.
echo ✅ Download completed!
choice /M "Download another?" && goto START
exit /b
