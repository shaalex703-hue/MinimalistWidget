@echo off
title MinimalistWidget Simulator
echo Starte MinimalistWidget Simulator im Browser...
start "" "%~dp0preview.html"
if %errorlevel% neq 0 (
    start msedge "file:///%~dp0preview.html"
)
exit
