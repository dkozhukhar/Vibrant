@echo off

set ROOT=d:\gamesfrommars\d

set PATH=%ROOT%\dmd.1.062\windows\bin

set MAINFILE=vibrant

rc /v vibrant.rc 

rem rcedit /L %MAINFILE%.exe

rem rcedit /R %MAINFILE%.exe vibrant.rcedit


rem rcedit /L %MAINFILE%.exe



pause