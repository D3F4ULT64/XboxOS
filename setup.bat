@echo off
title XboxOS Setup Wizard
color 0B
setlocal EnableDelayedExpansion

cls
echo.
echo ==========================================
echo            XboxOS Setup Wizard
echo                 Version 0.1
echo ==========================================
echo.
echo Welcome to XboxOS!
echo.
echo This wizard will prepare XboxOS on your PC.
echo.
pause


:: -------------------------------
:: Python Check
:: -------------------------------

cls
echo.
echo [1/5] Checking Python...
echo.

where py >nul 2>&1

if %errorlevel%==0 (
    set PYTHON=py
) else (
    where python >nul 2>&1

    if %errorlevel%==0 (
        set PYTHON=python
    ) else (
        color 0C
        echo Python was not found.
        echo.
        echo Install Python:
        echo https://www.python.org/downloads/
        pause
        exit /b
    )
)

echo Python detected!
echo.


:: -------------------------------
:: Install Requirements
:: -------------------------------

echo [2/5] Installing requirements...
echo.

if exist requirements.txt (
    %PYTHON% -m pip install -r requirements.txt
) else (
    echo No requirements.txt found.
    echo Installing pygame manually...
    %PYTHON% -m pip install pygame
)

if errorlevel 1 (
    color 0C
    echo.
    echo Package installation failed.
    pause
    exit /b
)

echo Requirements installed!
echo.


:: -------------------------------
:: Installation Type
:: -------------------------------

:INSTALL_TYPE

cls
echo.
echo ==========================================
echo          Choose Installation Type
echo ==========================================
echo.
echo 1. Normal Install
echo.
echo    Recommended
echo    Keeps XboxOS in its current folder.
echo.
echo 2. Copy XboxOS Folder
echo.
echo    Advanced option.
echo    WARNING: May break asset loading.
echo.

choice /c 12 /m "Select option"


if errorlevel 2 goto COPY_INSTALL
if errorlevel 1 goto NORMAL_INSTALL



:: -------------------------------
:: Normal Install
:: -------------------------------

:NORMAL_INSTALL

set INSTALL_DIR=%~dp0

goto CREATE_LAUNCHER



:: -------------------------------
:: Copy Install
:: -------------------------------

:COPY_INSTALL

cls
echo.
echo ==========================================
echo               WARNING
echo ==========================================
echo.
echo Copying XboxOS may cause problems.
echo.
echo Some versions of XboxOS use paths like:
echo.
echo C:\Users\Username\xboxos\assets
echo.
echo Moving the folder can cause:
echo.
echo - Missing images
echo - Missing sounds
echo - Broken apps
echo.
echo Continue anyway?
echo.

choice /c YN /m "Continue"

if errorlevel 2 goto INSTALL_TYPE


echo.
set /p COPY_LOCATION="Enter destination folder: "

if not exist "%COPY_LOCATION%" (
    mkdir "%COPY_LOCATION%"
)

echo.
echo Copying XboxOS...

xcopy "%~dp0*" "%COPY_LOCATION%\XboxOS\" /E /I /Y /Q

set INSTALL_DIR=%COPY_LOCATION%\XboxOS

echo Copy finished!
echo.


:: -------------------------------
:: Launcher
:: -------------------------------

:CREATE_LAUNCHER

cls
echo.
echo [4/5] Creating launcher...
echo.

(
echo @echo off
echo title XboxOS
echo cd /d "%INSTALL_DIR%"
echo %PYTHON% main.py
) > "%INSTALL_DIR%\XboxOS.bat"


echo Launcher created!
echo.


:: -------------------------------
:: Finish
:: -------------------------------

cls
color 0A

echo.
echo ==========================================
echo           XboxOS Setup Complete!
echo ==========================================
echo.
echo Installed location:
echo.
echo %INSTALL_DIR%
echo.
echo To start XboxOS:
echo.
echo Double click XboxOS.bat
echo.
echo Enjoy XboxOS!
echo.

pause
exit /b