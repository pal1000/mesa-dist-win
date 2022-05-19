@setlocal ENABLEDELAYEDEXPANSION
@set jsonlines=0
@for /R "%devroot%\%projectname%\bin\%abi%" %%a IN (%1_icd.*.json) do @for /f delims^=^ eol^= %%b IN ('type "%%~a"') do @(
@set /a jsonlines+=1
@IF !jsonlines! NEQ 4 set jsonline[!jsonlines!]=%%b
@IF !jsonlines! EQU 4 IF EXIST "%devroot%\%projectname%\bin\%abi%\libvulkan_%1.dll" set jsonline[!jsonlines!]=        "library_path"^: ".^\^\libvulkan_%1.dll"
@IF !jsonlines! EQU 4 IF NOT EXIST "%devroot%\%projectname%\bin\%abi%\libvulkan_%1.dll" set jsonline[!jsonlines!]=        "library_path"^: ".^\^\vulkan_%1.dll"
)
@for /R "%devroot%\%projectname%\bin\%abi%" %%a IN (%1_icd.*.json) do @(
@del "%%~a"
@for /L %%b IN (1,1,%jsonlines%) do @echo !jsonline[%%b]!>>"%%~a"
)
