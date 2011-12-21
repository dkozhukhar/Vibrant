@echo off
set ZIP="c:\program files\7-zip\7z.exe" 

cd release
%ZIP% a vibrant.zip *
move vibrant.zip ..\Vibrant_1.5.zip
pause