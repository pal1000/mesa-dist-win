@setlocal
@set canspvtools=1
@IF NOT EXIST %devroot%\spirv-tools\external\spirv-headers IF %gitstate% EQU 0 set canspvtools=0
@if %cmakestate% EQU 0 set canspvtools=0
@IF %canspvtools% EQU 1 set /p buildspvtools=Build SPIRV Tools (y/n):
@IF %canspvtools% EQU 1 echo.
@IF /I NOT "%buildspvtools%"=="y" GOTO skipspvtools
@set spvtoolsver=v2021.3
@IF EXIST %devroot%\spirv-tools\external\spirv-headers IF %gitstate% GTR 0 (
@cd %devroot%\spirv-tools\external\spirv-headers
@git pull -v --progress --recurse-submodules origin
@echo.
)
@IF EXIST %devroot%\spirv-tools\external IF %gitstate% GTR 0 (
@cd %devroot%\spirv-tools
@git checkout master
@git pull -v --progress --recurse-submodules origin
@git checkout %spvtoolsver%
@echo.
)
@IF NOT EXIST %devroot%\spirv-tools\external IF %gitstate% GTR 0 (
@git clone https://github.com/KhronosGroup/SPIRV-Tools %devroot%\spirv-tools
@cd %devroot%\spirv-tools
@git checkout %spvtoolsver%
@echo.
)
@IF NOT EXIST %devroot%\spirv-tools\external\spirv-headers IF %gitstate% GTR 0 (
@git clone https://github.com/KhronosGroup/SPIRV-Headers %devroot%\spirv-tools\external\spirv-headers
@echo.
)

:skipspvtools
@cd %devroot%