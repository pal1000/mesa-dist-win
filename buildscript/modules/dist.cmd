@setlocal
@rem Create distribution.
@if NOT EXIST %devroot%\mesa\build\windows-%longabi% if NOT EXIST %devroot%\mesa\build\%abi% GOTO exit
@set /p dist=Create or update Mesa3D distribution package (y/n):
@echo.
@if /I NOT "%dist%"=="y" GOTO exit
@cd %devroot%\%projectname%

@set legacydist=1
@IF %legacydist% EQU 1 GOTO legacydist
@IF %toolchain%==gcc IF EXIST %devroot%\mesa\build\%abi% %mesonloc% install -C ${devroot}/mesa/build/${abi}"
@GOTO exit

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
@IF %mesabldsys%==meson GOTO mesondist

:sconsdist
@rem Copy binaries
@IF EXIST %devroot%\mesa\build\windows-%longabi%\bin RD /S /Q %devroot%\mesa\build\windows-%longabi%\bin
@forfiles /p %devroot%\mesa\build\windows-%longabi% /s /m *.dll /c "cmd /c IF NOT @file==0x22osmesa.dll0x22 IF NOT @file==0x22graw.dll0x22 copy @path %devroot%\%projectname%\bin\%abi%"
@IF EXIST %devroot%\mesa\build\windows-%longabi%\mesa\drivers\osmesa\osmesa.dll copy %devroot%\mesa\build\windows-%longabi%\mesa\drivers\osmesa\osmesa.dll %devroot%\%projectname%\bin\%abi%\osmesa-swrast\osmesa.dll
@IF EXIST %devroot%\mesa\build\windows-%longabi%\gallium\targets\osmesa\osmesa.dll copy %devroot%\mesa\build\windows-%longabi%\gallium\targets\osmesa\osmesa.dll %devroot%\%projectname%\bin\%abi%\osmesa-gallium\osmesa.dll
@IF EXIST %devroot%\mesa\build\windows-%longabi%\gallium\targets\graw-gdi\graw.dll copy %devroot%\mesa\build\windows-%longabi%\gallium\targets\graw-gdi\graw.dll %devroot%\%projectname%\bin\%abi%\graw.dll

@rem Copy build development artifacts
@xcopy %devroot%\mesa\build\windows-%longabi%\*.lib %devroot%\%projectname%\lib\%abi% /E /I /G
@xcopy %devroot%\mesa\build\windows-%longabi%\*.a %devroot%\%projectname%\lib\%abi% /E /I /G
@xcopy %devroot%\mesa\build\windows-%longabi%\*.h %devroot%\%projectname%\include\%abi% /E /I /G

@echo.
@GOTO distributed

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