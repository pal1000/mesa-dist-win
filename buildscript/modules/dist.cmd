@setlocal
@rem Create distribution.
@if NOT EXIST %devroot%\mesa\build\%abi% GOTO exit
@set /p dist=Create or update Mesa3D distribution package (y/n):
@echo.
@if /I NOT "%dist%"=="y" GOTO exit
@cd %devroot%\%projectname%

@set legacydist=1
@IF %legacydist% EQU 1 GOTO legacydist
@IF %toolchain%==gcc IF EXIST %devroot%\mesa\build\%abi% %mesonloc% install -C ${devroot}/mesa/build/${abi}"
@IF %toolchain%==gcc IF EXIST %devroot%\mesa\build\%abi% GOTO distributed

@if NOT EXIST dist MD dist
@if EXIST dist\%abi% RD /S /Q dist\%abi%
@md dist\%abi%
@MD dist\%abi%\bin
@MD dist\%abi%\lib
@MD dist\%abi%\lib\pkgconfig
@MD dist\%abi%\include
@MD dist\%abi%\bin\osmesa-gallium
@MD dist\%abi%\bin\osmesa-swrast
@MD dist\%abi%\share
@MD dist\%abi%\share\drirc.d
@GOTO mesondist

:legacydist
@if NOT EXIST bin MD bin
@if NOT EXIST lib MD lib
@if NOT EXIST include MD include
@cd bin
@if EXIST %abi% RD /S /Q %abi%
@MD %abi%
@cd %abi%
@MD osmesa-gallium
@MD osmesa-swrast
@cd ..\..\lib
@if EXIST %abi% RD /S /Q %abi%
@MD %abi%
@cd ..\include
@if EXIST %abi% RD /S /Q %abi%
@MD %abi%

:mesondist
@forfiles /p %devroot%\mesa\build\%abi% /s /m *.dll /c "cmd /c IF NOT @file==0x22osmesa.dll0x22 copy @path %devroot%\%projectname%\bin\%abi%"
@IF EXIST %devroot%\mesa\build\%abi%\src\mesa\drivers\osmesa\osmesa.dll copy %devroot%\mesa\build\%abi%\src\mesa\drivers\osmesa\osmesa.dll %devroot%\%projectname%\bin\%abi%\osmesa-swrast\osmesa.dll
@IF EXIST %devroot%\mesa\build\%abi%\src\gallium\targets\osmesa\osmesa.dll copy %devroot%\mesa\build\%abi%\src\gallium\targets\osmesa\osmesa.dll %devroot%\%projectname%\bin\%abi%\osmesa-gallium\osmesa.dll
@forfiles /p %devroot%\mesa\build\%abi% /s /m *.exe /c "cmd /c copy @path %devroot%\%projectname%\bin\%abi%"
@rem Copy build development artifacts
@xcopy %devroot%\mesa\build\%abi%\*.lib %devroot%\%projectname%\lib\%abi% /E /I /G
@xcopy %devroot%\mesa\build\%abi%\*.a %devroot%\%projectname%\lib\%abi% /E /I /G
@xcopy %devroot%\mesa\build\%abi%\*.h %devroot%\%projectname%\include\%abi% /E /I /G
@echo.

:distributed
@call %devroot%\%projectname%\buildscript\modules\addversioninfo.cmd

:exit
@endlocal
@pause
@exit