@setlocal ENABLEDELAYEDEXPANSION
@set jsonlines=0
@for /R "%devroot%\%projectname%\bin\%abi%" %%a IN (%1_icd.*.json, %1_vk_icd.*.json) do @for /f delims^=^ eol^= %%b IN ('type "%%~a"') do @for /f tokens^=1-2^ delims^=^:^  %%c IN ("%%b") do (
@set /a jsonlines+=1
@if /I NOT "%%~c"=="library_path" set jsonline[!jsonlines!]=%%b
@if /I "%%~c"=="library_path" IF EXIST "%devroot%\%projectname%\bin\%abi%\libvulkan_%1.dll" set jsonline[!jsonlines!]=        "library_path"^: ".^\^\libvulkan_%1.dll"
@if /I "%%~c"=="library_path" IF NOT EXIST "%devroot%\%projectname%\bin\%abi%\libvulkan_%1.dll" set jsonline[!jsonlines!]=        "library_path"^: ".^\^\vulkan_%1.dll"
)
@for /R "%devroot%\%projectname%\bin\%abi%" %%a IN (%1_icd.*.json, %1_vk_icd.*.json) do @(
@del "%%~a"
@for /L %%b IN (1,1,%jsonlines%) do @echo !jsonline[%%b]!>>"%%~a"
)
