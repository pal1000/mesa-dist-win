@cd /d "%~dp0"
@echo -----------------------------------
@echo Mesa-dist-win distribution packager
@echo -----------------------------------
@TITLE Mesa-dist-win distribution packager
@echo Checking 7-zip compressor availability...
@set sevenzip=7z.exe
@CMD /C EXIT 0
@where /q 7z.exe
@if NOT "%ERRORLEVEL%"=="0" set sevenzip="%ProgramFiles%\7-Zip\7z.exe"
@if NOT %sevenzip%==7z.exe if NOT EXIST %sevenzip% set sevenzip="%ProgramW6432%\7-Zip\7z.exe"
@if NOT %sevenzip%==7z.exe if NOT EXIST %sevenzip% set sevenzip="%ProgramFiles(x86)%\7-Zip\7z.exe"
@if NOT %sevenzip%==7z.exe if NOT EXIST %sevenzip% echo FATAL ERROR^: 7-Zip is not installed.
@if %sevenzip%==7z.exe echo OK.
@if NOT %sevenzip%==7z.exe if EXIST %sevenzip% echo OK.
@echo.
@if NOT %sevenzip%==7z.exe if NOT EXIST %sevenzip% pause
@if NOT %sevenzip%==7z.exe if NOT EXIST %sevenzip% exit /B

@echo Detecting binary toolchain...
@set msvclibs=0
@for /f %%a IN ('dir /b /s ..\lib\*.lib 2^>nul') DO @set /a msvclibs+=1
@set mingwlibs=0
@for /f %%a IN ('dir /b /s ..\lib\*.dll.a 2^>nul') DO @set /a mingwlibs+=1
@if %msvclibs% EQU 0 if %mingwlibs% EQU 0 echo FATAL ERROR^: Missing binaries!
@if %msvclibs% GTR 0 if %mingwlibs% GTR 0 echo FATAL ERROR^: Binaries are corrupt!
@if %msvclibs% GTR 0 if %mingwlibs% EQU 0 echo MSVC
@if %msvclibs% EQU 0 if %mingwlibs% GTR 0 echo MINGW
@echo.
@if %msvclibs% EQU 0 if %mingwlibs% EQU 0 pause
@if %msvclibs% EQU 0 if %mingwlibs% EQU 0 exit /B
@if %msvclibs% GTR 0 if %mingwlibs% GTR 0 pause
@if %msvclibs% GTR 0 if %mingwlibs% GTR 0 exit /B

@echo Getting Mesa3D version...
@set mesaver=0
@IF EXIST ..\..\mesa\VERSION set /p mesaver=<..\..\mesa\VERSION
@IF EXIST ..\..\mesa\VERSION IF "%mesaver:~-6%"=="-devel" IF EXIST ..\..\mesa\.git\refs\heads\main for /f %%a IN (..\..\mesa\.git\refs\heads\main) DO @set mesaver=%mesaver:~0,-6%-%%a
@IF EXIST ..\..\mesa\VERSION echo %mesaver%
@IF NOT EXIST ..\..\mesa\VERSION set /p mesaver=Enter Mesa3D version:
@echo.
@set /p mesarev=Enter distribution revision (leave blank if first):
@echo.

@echo Detecting build type...
@set buildtype=release
@if %mingwlibs% GTR 0 for /f %%a IN ('dir /b /s ..\debug\*.dll 2^>nul') DO @set buildtype=debug
@echo %buildtype%
@echo.

@IF %buildtype%==debug echo Creating mesa-dist-win MinGW debug package...
@if %msvclibs% GTR 0 echo Creating mesa-dist-win MSVC release package...
@IF %buildtype%==release if %mingwlibs% GTR 0 echo Creating mesa-dist-win MinGW release package...
@IF %buildtype%==debug %sevenzip% a mesa3d-%mesaver%%mesarev%-debug-mingw.7z -r ..\debug\*.* -m0=LZMA2 -mmt=off -mx=9
@if %msvclibs% GTR 0 %sevenzip% a mesa3d-%mesaver%%mesarev%-release-msvc.7z ..\bin ..\lib ..\include -m0=LZMA2 -mmt=off -mx=9
@IF %buildtype%==release if %mingwlibs% GTR 0 %sevenzip% a mesa3d-%mesaver%%mesarev%-release-mingw.7z ..\bin ..\lib ..\include -m0=LZMA2 -mmt=off -mx=9
@echo.

@IF %buildtype%==debug echo Creating mesa-dist-win MinGW debug test package...
@if %msvclibs% GTR 0 echo Creating mesa-dist-win MSVC test package...
@IF %buildtype%==release if %mingwlibs% GTR 0 echo Creating mesa-dist-win MinGW release test package...
@IF %buildtype%==debug %sevenzip% a mesa3d-%mesaver%%mesarev%-tests-debug-mingw.7z -r ..\tests\*.* -m0=LZMA2 -mmt=off -mx=9
@if %msvclibs% GTR 0 %sevenzip% a mesa3d-%mesaver%%mesarev%-tests-msvc.7z -r ..\tests\*.* -m0=LZMA2 -mmt=off -mx=9
@IF %buildtype%==release if %mingwlibs% GTR 0 %sevenzip% a mesa3d-%mesaver%%mesarev%-tests-mingw.7z -r ..\tests\*.* -m0=LZMA2 -mmt=off -mx=9
@echo.

@if %msvclibs% GTR 0 echo Creating mesa-dist-win MSVC debug info package...
@if %msvclibs% GTR 0 %sevenzip% a mesa3d-%mesaver%%mesarev%-debug-info-msvc.7z -r ..\debug\*.pdb -m0=LZMA2 -mmt=off -mx=9
@echo.
@pause