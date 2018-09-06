@rem Create distribution.
@if NOT EXIST %mesa%\mesa\build\windows-%longabi% GOTO exit
@set /p dist=Create or update Mesa3D distribution package (y/n):
@echo.
@if /I NOT "%dist%"=="y" GOTO exit
@cd %mesa%
@if NOT EXIST mesa-dist-win MD mesa-dist-win
@cd mesa-dist-win
@if NOT EXIST bin MD bin
@cd bin
@if EXIST %abi% RD /S /Q %abi%
@MD %abi%
@cd %abi%
@MD osmesa-gallium
@MD osmesa-swrast
@IF %pythonver% GEQ 3 GOTO mesondist

:sconsdist
@forfiles /p %mesa%\mesa\build\windows-%longabi% /s /m *.dll /c "cmd /c IF NOT @file==0x22osmesa.dll0x22 copy @path %mesa%\mesa-dist-win\bin\%abi%"
@copy %mesa%\mesa\build\windows-%longabi%\mesa\drivers\osmesa\osmesa.dll osmesa-swrast\osmesa.dll
@copy %mesa%\mesa\build\windows-%longabi%\gallium\targets\osmesa\osmesa.dll osmesa-gallium\osmesa.dll
@echo.
@GOTO exit

:mesondist
@forfiles /p %mesa%\mesa\%abi% /s /m *.dll /c "cmd /c copy @path %mesa%\mesa-dist-win\bin\%abi%"

:exit
@pause
@exit