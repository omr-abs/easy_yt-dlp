@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

:: ===========================
:: EASY_YT-DLP - All-in-One Batch Script
:: ===========================

echo ================================
echo         EASY_YT-DLP
echo ================================

:: === Setup yt-dlp if missing ===
if not exist "yt-dlp.exe" (
    echo [Setup] yt-dlp.exe not found. Downloading latest release...
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe' -OutFile 'yt-dlp.exe'"
    if not exist "yt-dlp.exe" (
        echo [ERROR] yt-dlp.exe download failed.
        pause
        exit /b
    )
)

:: === Setup ffmpeg if missing ===
if not exist "ffmpeg_bin\ffmpeg.exe" (
    echo [Setup] ffmpeg not found. Downloading essentials ZIP...
    if not exist "ffmpeg_download.zip" (
        powershell -Command "Invoke-WebRequest -Uri 'https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip' -OutFile 'ffmpeg_download.zip'"
    )
    echo [INFO] Extracting ffmpeg...
    powershell -Command "Expand-Archive -Path 'ffmpeg_download.zip' -DestinationPath 'ffmpeg_extracted' -Force"
    for /D %%D in (ffmpeg_extracted\*) do (
        if exist "%%D\bin\ffmpeg.exe" (
            mkdir ffmpeg_bin >nul 2>&1
            copy "%%D\bin\ffmpeg.exe" ffmpeg_bin\ >nul
            copy "%%D\bin\ffplay.exe" ffmpeg_bin\ >nul
            copy "%%D\bin\ffprobe.exe" ffmpeg_bin\ >nul
        )
    )
    rmdir /s /q ffmpeg_extracted
    del ffmpeg_download.zip
    echo [SUCCESS] ffmpeg.exe, ffplay.exe, ffprobe.exe installed to ffmpeg_bin\
)

:: Add ffmpeg to PATH for this session
set "PATH=%~dp0ffmpeg_bin;%PATH%"

:START
cls
echo ================================
echo         EASY_YT-DLP
echo ================================

:: --- 1) Clipboard URL Detection / Title Check ---
for /f "delims=" %%C in ('powershell -noprofile -command "Get-Clipboard"') do set "CLIP=%%C"
set "URLS=%CLIP%"

:: Try to get title
for /f "delims=" %%T in ('yt-dlp --get-title "%URLS%" 2^>nul') do set "VIDTITLE=%%T"

if not defined VIDTITLE (
    echo Clipboard does not contain a valid URL or title could not be read.
    set /p "URLS=Please paste a valid YouTube or supported URL: "
) else (
    echo Clipboard URL detected: %CLIP%
    echo Video Title: "%VIDTITLE%"
    choice /M "Is this the correct video?"
    if errorlevel 2 (
        set /p "URLS=Please paste the correct URL: "
        :: Attempt to get title again
        for /f "delims=" %%X in ('yt-dlp --get-title "%URLS%" 2^>nul') do set "VIDTITLE=%%X"
    )
)

:: --- 2) Ensure Download Folders Exist ---
set "ROOTFOLDER=%USERPROFILE%\Downloads\EASY_YT-DLP DOWNLOADS"
set "VIDFOLDER=%ROOTFOLDER%\Videos"
set "MP3FOLDER=%ROOTFOLDER%\MP3"
if not exist "%VIDFOLDER%" mkdir "%VIDFOLDER%"
if not exist "%MP3FOLDER%" mkdir "%MP3FOLDER%"

:: --- 3) Optional Cookie Support ---
if exist "youtube_cookies.txt" (
    echo Using cookies from youtube_cookies.txt
    set "COOKIES=--cookies youtube_cookies.txt"
) else (
    set "COOKIES="
)

:: --- 4) Choose Download Type ---
echo.
echo Choose download type:
echo   1 - Best video+audio (auto merge)
echo   2 - Audio only (MP3)
echo   3 - Video (manual format code merge)
set /p dl_type="Enter choice (1/2/3) [Default: 1]: "
if "%dl_type%"=="" set dl_type=1

if "%dl_type%"=="2" (
    echo.
    echo Downloading as MP3 with metadata...
    yt-dlp %COOKIES% --extract-audio --audio-format mp3 --audio-quality 0 ^
      --embed-thumbnail --add-metadata ^
      -o "%MP3FOLDER%\%%(title)s.%%(ext)s" %URLS%
    echo [%date% %time%] "%VIDTITLE%" ^| MP3 ^| %URLS% >> download_history.txt
    goto AFTER_DOWNLOAD
)

if "%dl_type%"=="3" (
    echo.
    :: Show available formats
    yt-dlp %COOKIES% -F "%URLS%"
    echo.
    set /p "VID=Enter VIDEO format code: "
    set /p "AUD=Enter AUDIO format code: "
    echo.
    echo Downloading with format %%VID%%+%%AUD%% ...
    yt-dlp %COOKIES% -f "%VID%+%AUD%" --merge-output-format mp4 ^
      -o "%VIDFOLDER%\%%(title)s.%%(ext)s" %URLS%
    echo [%date% %time%] "%VIDTITLE%" ^| Manual %VID%+%AUD% ^| %URLS% >> download_history.txt
    goto AFTER_DOWNLOAD
)

:: Default: auto best video+audio
echo.
echo Downloading best video+audio (auto merge)...
yt-dlp %COOKIES% -f "bv*+ba/b" --merge-output-format mp4 ^
  -o "%VIDFOLDER%\%%(title)s.%%(ext)s" %URLS%
echo [%date% %time%] "%VIDTITLE%" ^| Auto best ^| %URLS% >> download_history.txt

:AFTER_DOWNLOAD
echo.
echo ✅ Download completed successfully!
choice /M "Would you like to download another?"
if errorlevel 2 exit /b
goto START
