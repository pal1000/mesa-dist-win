@setlocal
@IF EXIST "%devroot%\mesa\include\winddk\.gitignore" set winwdkcount=0
@IF EXIST "%devroot%\mesa\include\winddk\.gitignore" for /f delims^=^ eol^= %%a in ('type "%devroot%\mesa\include\winddk\.gitignore"') do @(
set /a winwdkcount-=1
for /f delims^=^ eol^= %%b in ('@call "%devroot%\%projectname%\buildscript\modules\winsdkloc.cmd"') do @IF EXIST "%%b" for /f delims^=^ eol^= %%c in ('dir /b /s "%%b\%%a" 2^>^&1') do @if /I "%%~nxa"=="%%~nxc" set /a winwdkcount+=1
)
@IF "%winwdkcount%"=="0" echo OK
@IF NOT "%winwdkcount%"=="0" echo null