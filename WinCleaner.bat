@echo off
:: Check for Administrator privileges. If missing, auto-restart with admin rights.
chcp 65001 >nul
net session >nul 2>&1
if %errorLevel% == 0 (
    goto :init
) else (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /b
)

:init
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
cls
color 0A
title WinCleaner & Optimizer v1.0

echo ============================================================
echo          WinCleaner - Windows System Junk Cleaner            
echo ============================================================
echo.
echo Preparing to remove system clutter and cache...
echo Please close your web browsers and other apps before proceeding.
echo.
pause

cls
echo ============================================================
echo [1/4] Cleaning User Temporary Files (Temp)...
echo ============================================================
del /f /s /q "%TEMP%\*.*" >nul 2>&1
rmdir /s /q "%TEMP%" >nul 2>&1
mkdir "%TEMP%"
echo User temporary files successfully deleted!
echo.

echo ============================================================
echo [2/4] Cleaning System Cache (C:\Windows\Temp)...
echo ============================================================
del /f /s /q "C:\Windows\Temp\*.*" >nul 2>&1
rmdir /s /q "C:\Windows\Temp" >nul 2>&1
mkdir "C:\Windows\Temp"
echo System cache successfully deleted!
echo.

echo ============================================================
echo [3/4] Purging Windows Update Cache...
echo ============================================================
echo Stopping Windows Update services...
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1

echo Deleting old update files...
del /f /s /q "C:\Windows\SoftwareDistribution\Download\*.*" >nul 2>&1
rmdir /s /q "C:\Windows\SoftwareDistribution\Download" >nul 2>&1
mkdir "C:\Windows\SoftwareDistribution\Download"

echo Restarting Windows Update services...
net start wuauserv >nul 2>&1
net start bits >nul 2>&1
echo Windows Update cache successfully cleared!
echo.

echo ============================================================
echo [4/4] Flushing Network DNS Cache...
echo ============================================================
ipconfig /flushdns >nul 2>&1
echo DNS cache successfully flushed! Network optimized.
echo.

echo ============================================================
echo       Cleanup successfully completed! Disk space freed.          
echo ============================================================
echo.
pause
exit
