@setlocal
@rem Create distribution.
@if NOT EXIST %mesa%\mesa\build\windows-%longabi% if NOT EXIST %mesa%\mesa\build\%abi% GOTO exit
@set /p dist=Create or update Mesa3D distribution package (y/n):
@echo.
@if /I NOT "%dist%"=="y" GOTO exit
@cd %mesa%
@if NOT EXIST mesa-dist-win MD mesa-dist-win
@cd mesa-dist-win
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
@IF EXIST %mesa%\mesa\build\windows-%longabi%\bin RD /S /Q %mesa%\mesa\build\windows-%longabi%\bin
@forfiles /p %mesa%\mesa\build\windows-%longabi% /s /m *.dll /c "cmd /c IF NOT @file==0x22osmesa.dll0x22 IF NOT @file==0x22graw.dll0x22 copy @path %mesa%\mesa-dist-win\bin\%abi%"
@IF EXIST %mesa%\mesa\build\windows-%longabi%\mesa\drivers\osmesa\osmesa.dll copy %mesa%\mesa\build\windows-%longabi%\mesa\drivers\osmesa\osmesa.dll %mesa%\mesa-dist-win\bin\%abi%\osmesa-swrast\osmesa.dll
@IF EXIST %mesa%\mesa\build\windows-%longabi%\gallium\targets\osmesa\osmesa.dll copy %mesa%\mesa\build\windows-%longabi%\gallium\targets\osmesa\osmesa.dll %mesa%\mesa-dist-win\bin\%abi%\osmesa-gallium\osmesa.dll
@IF EXIST %mesa%\mesa\build\windows-%longabi%\gallium\targets\graw-gdi\graw.dll copy %mesa%\mesa\build\windows-%longabi%\gallium\targets\graw-gdi\graw.dll %mesa%\mesa-dist-win\bin\%abi%\graw.dll

@rem Copy build development artifacts
@xcopy %mesa%\mesa\build\windows-%longabi%\*.lib %mesa%\mesa-dist-win\lib\%abi% /E /I /G
@xcopy %mesa%\mesa\build\windows-%longabi%\*.a %mesa%\mesa-dist-win\lib\%abi% /E /I /G
@xcopy %mesa%\mesa\build\windows-%longabi%\*.h %mesa%\mesa-dist-win\include\%abi% /E /I /G

@echo.
@GOTO distributed

:mesondist
@forfiles /p %mesa%\mesa\build\%abi% /s /m *.dll /c "cmd /c IF NOT @file==0x22osmesa.dll0x22 copy @path %mesa%\mesa-dist-win\bin\%abi%"
@IF EXIST %mesa%\mesa\build\%abi%\src\mesa\drivers\osmesa\osmesa.dll copy %mesa%\mesa\build\%abi%\src\mesa\drivers\osmesa\osmesa.dll %mesa%\mesa-dist-win\bin\%abi%\osmesa-swrast\osmesa.dll
@IF EXIST %mesa%\mesa\build\%abi%\src\gallium\targets\osmesa\osmesa.dll copy %mesa%\mesa\build\%abi%\src\gallium\targets\osmesa\osmesa.dll %mesa%\mesa-dist-win\bin\%abi%\osmesa-gallium\osmesa.dll
@forfiles /p %mesa%\mesa\build\%abi% /s /m *.exe /c "cmd /c copy @path %mesa%\mesa-dist-win\bin\%abi%"
@rem Copy build development artifacts
@xcopy %mesa%\mesa\build\%abi%\*.lib %mesa%\mesa-dist-win\lib\%abi% /E /I /G
@xcopy %mesa%\mesa\build\%abi%\*.a %mesa%\mesa-dist-win\lib\%abi% /E /I /G
@xcopy %mesa%\mesa\build\%abi%\*.h %mesa%\mesa-dist-win\include\%abi% /E /I /G
@echo.

:distributed
@call %mesa%\mesa-dist-win\buildscript\modules\addversioninfo.cmd

:exit
@endlocal
@pause
@exit