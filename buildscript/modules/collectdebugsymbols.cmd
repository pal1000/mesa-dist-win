@if EXIST "%devroot%\%projectname%\debugsymbols\%abi%\" RD /S /Q "%devroot%\%projectname%\debugsymbols\%abi%"
@MD "%devroot%\%projectname%\debugsymbols\%abi%"
@IF %toolchain%==msvc ROBOCOPY "%devroot%\mesa\build\%toolchain%-%abi%" "%devroot%\%projectname%\debugsymbols\%abi%" *.pdb /E
@IF NOT %toolchain%==msvc IF EXIST "%msysloc%\%LMSYSTEM%\bin\strip.exe" IF EXIST "%msysloc%\%LMSYSTEM%\bin\objcopy.exe" for /f delims^=^ eol^= %%a in ('dir /b "%devroot%\%projectname%\bin\%abi%\*.*" 2^>^&1') do @IF EXIST "%devroot%\%projectname%\bin\%abi%\%%~nxa" IF /I NOT "%%~na"=="dxil" IF /I NOT "%%~na"=="openclon12" IF /I NOT "%%~na"=="WinPixEventRuntime" IF /I NOT "%%~xa"==".json" IF /I NOT "%%~xa"=="json" (
@echo Extracting debug information from %%~nxa into %%~nxa.sym...
@"%msysloc%\%LMSYSTEM%\bin\objcopy.exe" --only-keep-debug "%devroot%\%projectname%\bin\%abi%\%%~nxa" "%devroot%\%projectname%\debugsymbols\%abi%\%%~nxa.sym"
@"%msysloc%\%LMSYSTEM%\bin\strip.exe" --strip-debug --strip-unneeded "%devroot%\%projectname%\bin\%abi%\%%~nxa"
@echo Finished.
)
@echo.
