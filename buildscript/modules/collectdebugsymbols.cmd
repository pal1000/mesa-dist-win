@echo Copying debug information...
@IF %toolchain%==msvc ROBOCOPY "%devroot%\mesa\build\%toolchain%-%abi%" "%devroot%\%projectname%\debugsymbols\%abi%" *.pdb /E
@IF NOT %toolchain%==msvc IF EXIST "%msysloc%\%LMSYSTEM%\bin\strip.exe" for /f delims^=^ eol^= %%a in ('dir /b "%devroot%\%projectname%\bin\%abi%\*.dll" 2^>^&1') do @IF EXIST "%devroot%\%projectname%\bin\%abi%\%%~nxa"(
@copy "%devroot%\%projectname%\bin\%abi%\%%~nxa" "%devroot%\%projectname%\debugsymbols\%abi%\%%~nxa.sym"
@"%msysloc%\%LMSYSTEM%\bin\strip.exe" --only-keep-debug "%devroot%\%projectname%\debugsymbols\%abi%\%%~nxa.sym"
@"%msysloc%\%LMSYSTEM%\bin\strip.exe" --strip-debug --strip-unneeded "%devroot%\%projectname%\bin\%abi%\%%~nxa"
)
@IF NOT %toolchain%==msvc IF EXIST "%msysloc%\%LMSYSTEM%\bin\strip.exe" for /f delims^=^ eol^= %%a in ('dir /b "%devroot%\%projectname%\bin\%abi%\*.exe" 2^>^&1') do @IF EXIST "%devroot%\%projectname%\bin\%abi%\%%~nxa"(
@copy "%devroot%\%projectname%\bin\%abi%\%%~nxa" "%devroot%\%projectname%\debugsymbols\%abi%\%%~nxa.sym"
@"%msysloc%\%LMSYSTEM%\bin\strip.exe" --only-keep-debug "%devroot%\%projectname%\debugsymbols\%abi%\%%~nxa.sym"
@"%msysloc%\%LMSYSTEM%\bin\strip.exe" --strip-debug --strip-unneeded "%devroot%\%projectname%\bin\%abi%\%%~nxa"
)
@echo.
