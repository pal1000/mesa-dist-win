@setlocal
@IF EXIST "%devroot%\mesa\include\winddk\.gitignore" set windrvkitcheck=0
@IF EXIST "%devroot%\mesa\include\winddk\.gitignore" for /f delims^=^ eol^= %%a in ('type "%devroot%\mesa\include\winddk\.gitignore"') do @(
set /a windrvkitcheck-=1
for /f delims^=^ eol^= %%b in ('dir /b /s "%winsdkloc%\Include\%VSCMD_ARG_WINSDK%\%%a" 2^>nul') do @(
set /a windrvkitcheck+=1
@IF %toolchain%==msvc IF EXIST "%devroot%\mesa\include\winddk\%%a" del "%devroot%\mesa\include\winddk\%%a" >nul 2>&1
@IF NOT %toolchain%==msvc copy "%%~b" "%devroot%\mesa\include\winddk" >nul 2>&1
)
)
@IF "%windrvkitcheck%"=="0" echo OK
@IF NOT "%windrvkitcheck%"=="0" echo null
