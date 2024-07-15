@cd /d "%~dp0"
@echo Getting Mesa3D version...
@set mesaver=0
@IF EXIST ..\..\mesa\VERSION set /p mesaver=<..\..\mesa\VERSION
@IF EXIST ..\..\mesa\VERSION IF "%mesaver:~-6%"=="-devel" IF EXIST ..\..\mesa\.git\refs\heads\main for /f %%a IN (..\..\mesa\.git\refs\heads\main) DO @set mesaver=%mesaver:~0,-6%-%%a
@IF EXIST ..\..\mesa\VERSION echo %mesaver%
@IF NOT EXIST ..\..\mesa\VERSION set /p mesaver=Enter Mesa3D version:
@echo.

@echo Checking 7-zip compressor availability...
@set sevenzip=7z.exe
@CMD /C EXIT 0
@where /q 7z.exe
@if NOT "%ERRORLEVEL%"=="0" set sevenzip="%ProgramFiles%\7-Zip\7z.exe"
@if NOT %sevenzip%==7z.exe if NOT EXIST %sevenzip% set sevenzip="%ProgramW6432%\7-Zip\7z.exe"
@if NOT %sevenzip%==7z.exe if NOT EXIST %sevenzip% set sevenzip="%ProgramFiles(x86)%\7-Zip\7z.exe"
@if %sevenzip%==7z.exe echo OK.
@if NOT %sevenzip%==7z.exe if EXIST %sevenzip% echo OK.
@if NOT %sevenzip%==7z.exe if NOT EXIST %sevenzip% echo FATAL ERROR^: 7-Zip is not installed.
@echo.
@if NOT %sevenzip%==7z.exe if NOT EXIST %sevenzip% pause
@if NOT %sevenzip%==7z.exe if NOT EXIST %sevenzip% exit
@pause