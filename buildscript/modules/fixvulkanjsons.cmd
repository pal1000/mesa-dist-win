@setlocal
@if EXIST "%devroot%\%projectname%\buildscript\assets\vulkan-patch-%toolchain%-%abi%.json" del "%devroot%\%projectname%\buildscript\assets\vulkan-patch-%toolchain%-%abi%.json"
@for /R "%devroot%\%projectname%\bin\%abi%" %%a IN (%1_icd.*.json, %1_vk_icd.*.json) do @(
@for /f delims^=^ eol^= %%b IN ('type "%%~a"') do @for /f tokens^=1-2^ delims^=^:^  %%c IN ("%%b") do @(
@if /I NOT "%%~c"=="library_path" echo %%b
@if /I "%%~c"=="library_path" IF EXIST "%devroot%\%projectname%\bin\%abi%\libvulkan_%1.dll" echo         "library_path"^: ".^\^\libvulkan_%1.dll"
@if /I "%%~c"=="library_path" IF NOT EXIST "%devroot%\%projectname%\bin\%abi%\libvulkan_%1.dll" echo         "library_path"^: ".^\^\vulkan_%1.dll"
)>>"%devroot%\%projectname%\buildscript\assets\vulkan-patch-%toolchain%-%abi%.json"
@copy "%devroot%\%projectname%\buildscript\assets\vulkan-patch-%toolchain%-%abi%.json" "%%~a"
)
