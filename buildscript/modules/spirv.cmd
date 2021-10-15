@setlocal
@set canspvtools=1
@IF NOT EXIST %devroot%\spirv-tools\external\spirv-headers IF %gitstate% EQU 0 set canspvtools=0
@if %cmakestate% EQU 0 set canspvtools=0
@IF %canspvtools% EQU 1 set /p buildspvtools=Build SPIRV Tools (y/n):
@IF %canspvtools% EQU 1 echo.
@IF /I NOT "%buildspvtools%"=="y" GOTO skipspvtools
@IF EXIST %devroot%\spirv-tools\external IF %gitstate% GTR 0 (
@cd %devroot%\spirv-tools
@git checkout master
@git pull -v --progress --recurse-submodules origin
@git checkout canary
@echo.
)
@IF EXIST %devroot%\spirv-tools\external\spirv-headers IF %gitstate% GTR 0 (
@cd %devroot%\spirv-tools\external\spirv-headers
@git checkout master
@git pull -v --progress --recurse-submodules origin
@for /f tokens^=^2^,4^ delims^=^' %%a IN (%devroot%\spirv-tools\DEPS) do @IF /I "%%a"=="spirv_headers_revision" IF NOT "%%b"=="" git checkout %%b
@echo.
)
@IF NOT EXIST %devroot%\spirv-tools\external IF %gitstate% GTR 0 (
@git clone https://github.com/KhronosGroup/SPIRV-Tools %devroot%\spirv-tools
@cd %devroot%\spirv-tools
@git checkout canary
@echo.
)
@IF NOT EXIST %devroot%\spirv-tools\external\spirv-headers IF %gitstate% GTR 0 (
@git clone https://github.com/KhronosGroup/SPIRV-Headers %devroot%\spirv-tools\external\spirv-headers
@cd %devroot%\spirv-tools\external\spirv-headers
@for /f tokens^=^2^,4^ delims^=^' %%a IN (%devroot%\spirv-tools\DEPS) do @IF /I "%%a"=="spirv_headers_revision" IF NOT "%%b"=="" git checkout %%b
@echo.
)

:skipspvtools
@cd %devroot%