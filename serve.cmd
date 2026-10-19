@echo off
cd /d "%~dp0"

echo.
echo   Codeforces Div.2 viewer -- local / LAN server
echo   --------------------------------------------
echo   Local :  http://localhost:8080/
echo   Phone :  http://[IPv4 below]:8080/   (same Wi-Fi)
echo.
ipconfig | findstr /i "IPv4"
echo.
echo   Press Ctrl+C to stop.
echo.

where py >nul 2>nul
if %errorlevel%==0 goto usepy

where python >nul 2>nul
if %errorlevel%==0 goto usepython

echo   [!] Python 3 not found. Install it from https://www.python.org/downloads/
echo       Or just double-click index.html to open it locally.
pause
goto :eof

:usepy
py -3 -m http.server 8080
goto :eof

:usepython
python -m http.server 8080
goto :eof
