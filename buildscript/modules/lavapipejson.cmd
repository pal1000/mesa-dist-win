@setlocal ENABLEDELAYEDEXPANSION
@set jsonlines=0
@for /R %devroot%\%projectname%\bin\%abi%\ %%a IN (lvp_icd.*.json) do @for /f tokens^=^*^ delims^= %%b IN (%%a) do @(
@set /a jsonlines+=1
@IF !jsonlines! NEQ 4 set jsonline[!jsonlines!]=%%b
@IF !jsonlines! EQU 4 set jsonline[!jsonlines!]=        "library_path": "vulkan_lvp.dll"
)
@for /R %devroot%\%projectname%\bin\%abi%\ %%a IN (lvp_icd.*.json) do @(
@del %%a
@for /L %%b IN (1,1,%jsonlines%) do @echo !jsonline[%%b]!>>%%a
)
