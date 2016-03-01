@echo off
setlocal EnableDelayedExpansion
set path=%path%;%~dp0
set program=HKLM\SOFTWARE\pdfforge\PDFCreator\Program

echo Checking if PDFCreator is even installed..
reg query "%program%" > nul 2>&1

if !errorlevel!==0 (
echo.
echo PDFCreator found. Reading the version now..

reg query "%program%" /v ApplicationVersion |^
sed "s/^.*REG_SZ[ \t]*//" |^
grep -v "[a-zA-Z]" |^
grep "[0-9\.]\+"

if !errorlevel!==0 (
echo.
echo Reading version and format value for welcome key..

for /f "tokens=*" %%a in ('^
reg query "%program%" /v ApplicationVersion ^|
sed "s/^.*REG_SZ[ \t]*//" ^|
grep -v "[a-zA-Z]" ^|
grep "[0-9\.]\+" ^|
sed "s/^/v/;s/\./ Build /3"') do (

echo.
echo Inserting value in current user profile..

reg add "HKCU\Software\pdfforge\PDFCreator" ^
/v LatestWelcomeVersion /t REG_SZ /d "%%a" /f > nul 2>&1
if !errorlevel!==0 echo Done.
echo.
)

)

)
endlocal

