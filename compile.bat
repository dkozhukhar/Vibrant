@echo off

rem Change this directory to match the right directory

set ROOT=d:\gamesfrommars\d

set PATH=%ROOT%\dmd.1.058\windows\bin

set MAINFILE=vibrant

rem set BUD_PARAMS= -g -debug=1 -w 
rem set BUD_PARAMS= -release -inline -O -w 
set BUD_PARAMS= -release -inline -O -w -gui


bud %MAINFILE%.d vibrant.res %BUD_PARAMS% -cleanup -names -version=Phobos -I..\common2 -op


if errorlevel 1 goto fin

%MAINFILE%.exe
:fin



pause