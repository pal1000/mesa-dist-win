@setlocal
@if EXIST "%devroot%\%projectname%\buildscript\assets\vulkan-patch-%toolchain%-%abi%.json" del "%devroot%\%projectname%\buildscript\assets\vulkan-patch-%toolchain%-%abi%.json"
@for /f delims^=^ eol^= %%a IN ('type "%devroot%\%projectname%\bin\%abi%\%~2.json"') do @for /f tokens^=1^ delims^=^:^  %%b IN ("%%a") do @(
@if /I NOT "%%~b"=="library_path" echo %%a
@if /I "%%~b"=="library_path" echo         "library_path"^: ".\\%~1.dll"
)>>"%devroot%\%projectname%\buildscript\assets\vulkan-patch-%toolchain%-%abi%.json"
@copy "%devroot%\%projectname%\buildscript\assets\vulkan-patch-%toolchain%-%abi%.json" "%devroot%\%projectname%\bin\%abi%\%~2.json"
