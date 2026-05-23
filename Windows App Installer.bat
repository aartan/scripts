@echo off
title Windows App Installer

:: Request admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

setlocal enabledelayedexpansion

set apps[0]=7zip.7zip
set apps[1]=Docker.DockerDesktop
set apps[2]=REALiX.HWiNFO
set apps[3]=Proton.ProtonVPN
set apps[4]=Henry++.simplewall
set apps[5]=Google.Chrome
set apps[6]=RevoUninstaller.RevoUninstaller
set apps[7]=Veeam.VeeamAgent
set apps[8]=TechPowerUp.NVCleanstall
set apps[9]=Guru3D.Afterburner
set apps[10]=CodecGuide.K-LiteCodecPack.Standard
set apps[11]=Guru3D.RTSS
set apps[12]=Valve.Steam
set apps[13]=qBittorrent.qBittorrent
set apps[14]=Futuremark.FuturemarkSystemInfo
set apps[15]=TechPowerUp.GPU-Z
set apps[16]=xanderfrangos.twinkletray
set apps[17]=JetBrains.Toolbox
set apps[18]=Obsidian.Obsidian
set apps[19]=Microsoft.PowerToys
set apps[20]=Playnite.Playnite
set apps[21]=Microsoft.VisualStudioCode

set total=22
set success=0
set failed=0
set skipped=0

echo =========================================
echo Starting WinGet bulk install
echo Total apps: %total%
echo =========================================
echo.

for /L %%i in (0,1,21) do (

    set app=!apps[%%i]!
    set /a current=%%i+1

    echo.
    echo [!current!/%total%] Processing: !app!
    echo -----------------------------------------

    winget list --exact --id !app! >nul 2>&1

    if !errorlevel! == 0 (

        echo [SKIPPED] !app! already installed
        set /a skipped+=1

    ) else (

        winget install --exact --silent --disable-interactivity ^
        --accept-package-agreements ^
        --accept-source-agreements ^
        !app!

        if !errorlevel! == 0 (
            echo [SUCCESS] !app!
            set /a success+=1
        ) else (
            echo [FAILED] !app!
            set /a failed+=1
        )
    )
)

echo.
echo =========================================
echo Installation Complete
echo =========================================
echo Successful: %success%
echo Skipped:   %skipped%
echo Failed:    %failed%
echo.

if %failed% GTR 0 (
    echo Some installs failed. Press any key to close...
    pause >nul
) else (
    exit
)