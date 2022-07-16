@pause
@echo Collecting debug symbools. Please wait...

@IF NOT EXIST "%devroot%\%projectname%\debugsymbols\" MD "%devroot%\%projectname%\debugsymbols"
@IF NOT EXIST "%devroot%\%projectname%\debugsymbols\%abi%\" RD /S /Q "%devroot%\%projectname%\debugsymbols\%abi%"
@IF NOT EXIST "%devroot%\%projectname%\debugsymbols\%abi%\" MD "%devroot%\%projectname%\debugsymbols\%abi%"
@IF %dualosmesa% EQU 1 MD "%devroot%\%projectname%\debugsymbols\osmesa-gallium"
@IF %dualosmesa% EQU 1 MD "%devroot%\%projectname%\debugsymbols\osmesa-swrast"
@IF EXIST "%devroot%\%projectname%\bin\%abi%\osmesa-gallium\osmesa.dll" (
@copy "%devroot%\%projectname%\bin\%abi%\osmesa-gallium\osmesa.dll" "%devroot%\%projectname%\debugsymbols\%abi%\osmesa-gallium\osmesa.dll.symbols"
@"%msysloc%\%LMSYSTEM%\bin\strip.exe" --only-keep-debug "%devroot%\%projectname%\debugsymbols\%abi%\osmesa-gallium\osmesa.dll.symbols"
@"%msysloc%\%LMSYSTEM%\bin\strip.exe" --strip-debug --strip-unneeded "%devroot%\%projectname%\bin\%abi%\osmesa-gallium\osmesa.dll"
)
@IF EXIST "%devroot%\%projectname%\bin\%abi%\osmesa-swrast\osmesa.dll" (
@copy "%devroot%\%projectname%\bin\%abi%\osmesa-swrast\osmesa.dll" "%devroot%\%projectname%\debugsymbols\%abi%\osmesa-swrast\osmesa.dll.symbols"
@"%msysloc%\%LMSYSTEM%\bin\strip.exe" --only-keep-debug "%devroot%\%projectname%\debugsymbols\%abi%\osmesa-swrast\osmesa.dll.symbols"
@"%msysloc%\%LMSYSTEM%\bin\strip.exe" --strip-debug --strip-unneeded "%devroot%\%projectname%\bin\%abi%\osmesa-swrast\osmesa.dll"
)

@for /f delims^=^ eol^= %%a in ('dir /b "%devroot%\%projectname%\bin\%abi%\*.dll" 2^>^&1') do @IF EXIST "%devroot%\%projectname%\bin\%abi%\%%~nxa"(
@copy "%devroot%\%projectname%\bin\%abi%\%%~nxa" "%devroot%\%projectname%\debugsymbols\%abi%\%%~nxa.symbols"
@"%msysloc%\%LMSYSTEM%\bin\strip.exe" --only-keep-debug "%devroot%\%projectname%\debugsymbols\%abi%\%%~nxa.symbols"
@"%msysloc%\%LMSYSTEM%\bin\strip.exe" --strip-debug --strip-unneeded "%devroot%\%projectname%\bin\%abi%\%%~nxa"
)
@for /f delims^=^ eol^= %%a in ('dir /b "%devroot%\%projectname%\bin\%abi%\*.exe" 2^>^&1') do @IF EXIST "%devroot%\%projectname%\bin\%abi%\%%~nxa"(
@copy "%devroot%\%projectname%\bin\%abi%\%%~nxa" "%devroot%\%projectname%\debugsymbols\%abi%\%%~nxa.symbols"
@"%msysloc%\%LMSYSTEM%\bin\strip.exe" --only-keep-debug "%devroot%\%projectname%\debugsymbols\%abi%\%%~nxa.symbols"
@"%msysloc%\%LMSYSTEM%\bin\strip.exe" --strip-debug --strip-unneeded "%devroot%\%projectname%\bin\%abi%\%%~nxa"
)
@echo.
@echo Done.
@echo.