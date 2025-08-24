@setlocal
@rem Create distribution.
@rem Keep both clover standalone and ICD intact
@IF EXIST "%devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\opencl\*penCL-1.dll" IF EXIST "%devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\opencl\*penCL.dll" del /Q "%devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\opencl\*penCL.dll"
@IF EXIST "%devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\opencl\MesaOpenCL-1.dll" REN "%devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\opencl\MesaOpenCL-1.dll" MesaOpenCL.dll
@IF EXIST "%devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\opencl\OpenCL-1.dll" REN "%devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\opencl\OpenCL-1.dll" OpenCL.dll
@IF EXIST "%devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\opencl\libMesaOpenCL-1.dll" REN "%devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\opencl\libMesaOpenCL-1.dll" MesaOpenCL.dll
@IF EXIST "%devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\opencl\libOpenCL-1.dll" REN "%devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\opencl\libOpenCL-1.dll" OpenCL.dll

@if %cimode% EQU 0 set dist=n
@call "%devroot%\%projectname%\bin\modules\prompt.cmd" dist "Create or update Mesa3D distribution package (y/n):"
@if /I NOT "%dist%"=="y" GOTO donedist
@cd "%devroot%\%projectname%"

@rem Normal distribution vs Meson install
@set normaldist=1
@IF %normaldist% EQU 1 GOTO normaldist

@IF %toolchain%==msvc GOTO donedist
@%mesonloc% install --no-rebuild --skip-subprojects -C "%devroot%\mesa\build\%toolchain%-%abi%"
@echo.
@GOTO donedist

:normaldist
@if %cimode% EQU 0 set keeplastbuild=n
@IF %toolchain%==msvc IF EXIST lib\%abi%\*.lib call "%devroot%\%projectname%\bin\modules\prompt.cmd" keeplastbuild "Keep binaries and libraries from previous build (y/n):"
@if NOT EXIST "bin\" MD bin
@if NOT EXIST "lib\" MD lib
@if NOT EXIST "tests\" MD tests
@IF /I NOT "%keeplastbuild%"=="y" if EXIST "bin\%abi%\" RD /S /Q bin\%abi%
@IF /I NOT "%keeplastbuild%"=="y" if EXIST "lib\%abi%\" RD /S /Q lib\%abi%
@IF /I NOT "%keeplastbuild%"=="y" if EXIST "debug\%abi%\" RD /S /Q debug\%abi%
@IF /I NOT "%keeplastbuild%"=="y" if EXIST "tests\%abi%\" RD /S /Q tests\%abi%
@IF /I NOT "%keeplastbuild%"=="y" if EXIST "include\" RD /S /Q include
@if NOT EXIST "bin\%abi%\" MD bin\%abi%
@if NOT EXIST "lib\%abi%\" MD lib\%abi%
@if NOT EXIST "lib\%abi%\pkgconfig\" MD lib\%abi%\pkgconfig
@if NOT EXIST "debug\%abi%\" MD debug\%abi%
@if NOT EXIST "tests\%abi%\" MD tests\%abi%
@if NOT EXIST "include\" MD include

:mesondist
@echo Copying Mesa3D shared libraries and PDBs...
@for /R "%devroot%\mesa\build\%toolchain%-%abi%\src" %%a IN (*.dll) do @(
@IF EXIST "%%a" copy "%%a" "%devroot%\%projectname%\bin\%abi%"
@IF EXIST "%%~dpna.pdb" copy "%%~dpna.pdb" "%devroot%\%projectname%\debug\%abi%"
)
@IF EXIST "%devroot%\%projectname%\bin\%abi%\libclon12compiler.dll" REN "%devroot%\%projectname%\bin\%abi%\libclon12compiler.dll" clon12compiler.dll
@echo.

@echo Copying runtimes for Microsoft drivers if needed...
@IF EXIST "%devroot%\%projectname%\bin\%abi%\*on12compiler.dll" for /R "%devroot%\clon12\out\%abi%\bin" %%a IN (*.dll) do @IF EXIST "%%a" copy "%%a" "%devroot%\%projectname%\bin\%abi%"
@IF EXIST "%devroot%\%projectname%\bin\%abi%\*pirv_to_dxil.dll" IF NOT EXIST "%devroot%\%projectname%\bin\%abi%\dxil.dll" for /f delims^=^ eol^= %%a in ('@call "%devroot%\%projectname%\buildscript\modules\dxil.cmd"') do @IF EXIST %%a copy %%a "%devroot%\%projectname%\bin\%abi%"
@IF EXIST "%devroot%\%projectname%\bin\%abi%\openglon12.dll" IF NOT EXIST "%devroot%\%projectname%\bin\%abi%\dxil.dll" for /f delims^=^ eol^= %%a in ('@call "%devroot%\%projectname%\buildscript\modules\dxil.cmd"') do @IF EXIST %%a copy %%a "%devroot%\%projectname%\bin\%abi%"
@IF EXIST "%devroot%\%projectname%\bin\%abi%\openclon12.dll" IF NOT EXIST "%devroot%\%projectname%\bin\%abi%\dxil.dll" for /f delims^=^ eol^= %%a in ('@call "%devroot%\%projectname%\buildscript\modules\dxil.cmd"') do @IF EXIST %%a copy %%a "%devroot%\%projectname%\bin\%abi%"
@IF EXIST "%devroot%\%projectname%\bin\%abi%\vulkan_dzn.dll" IF NOT EXIST "%devroot%\%projectname%\bin\%abi%\dxil.dll" for /f delims^=^ eol^= %%a in ('@call "%devroot%\%projectname%\buildscript\modules\dxil.cmd"') do @IF EXIST %%a copy %%a "%devroot%\%projectname%\bin\%abi%"
@IF EXIST "%devroot%\%projectname%\bin\%abi%\*aon12_drv_video.dll" IF NOT EXIST "%devroot%\%projectname%\bin\%abi%\dxil.dll" for /f delims^=^ eol^= %%a in ('@call "%devroot%\%projectname%\buildscript\modules\dxil.cmd"') do @IF EXIST %%a copy %%a "%devroot%\%projectname%\bin\%abi%"
@IF EXIST "%devroot%\%projectname%\bin\%abi%\*aon12_drv_video.dll" IF NOT EXIST "%devroot%\%projectname%\bin\%abi%\va.dll" IF EXIST "%devroot%\libva\build\%abi%\bin\va.dll" copy "%devroot%\libva\build\%abi%\bin\va.dll" "%devroot%\%projectname%\bin\%abi%"
@IF EXIST "%devroot%\%projectname%\bin\%abi%\*aon12_drv_video.dll" IF NOT EXIST "%devroot%\%projectname%\bin\%abi%\va_win32.dll" IF EXIST "%devroot%\libva\build\%abi%\bin\va_win32.dll" copy "%devroot%\libva\build\%abi%\bin\va_win32.dll" "%devroot%\%projectname%\bin\%abi%"
@echo.

@echo Copying test suite, commandline utilities and their PDB debug symbols...
@for /R "%devroot%\mesa\build\%toolchain%-%abi%\src" %%a IN (*.exe) do @(
@IF EXIST "%%a" IF /I "%%~na"=="spirv2dxil" copy "%%a" "%devroot%\%projectname%\bin\%abi%"
@IF EXIST "%%~dpna.pdb" IF /I "%%~na"=="spirv2dxil" copy "%%~dpna.pdb" "%devroot%\%projectname%\debug\%abi%"
@IF EXIST "%%a" IF /I NOT "%%~na"=="spirv2dxil" copy "%%a" "%devroot%\%projectname%\tests\%abi%"
@IF EXIST "%%~dpna.pdb" IF /I NOT "%%~na"=="spirv2dxil" copy "%%~dpna.pdb" "%devroot%\%projectname%\tests\%abi%"
)
@echo.

@echo Copying Vulkan drivers and layers initialization configuration files if needed...
@rem Patch Vulkan drivers and layers JSONs when using Mesa 24.0 or older except gfxstream driver and layers which always need patching
@set /p mesaver=<"%devroot%\mesa\VERSION"
@if "%mesaver:~-7%"=="0-devel" set /a intmesaver=%mesaver:~0,2%%mesaver:~3,1%00
@if "%mesaver:~5,4%"=="0-rc" set /a intmesaver=%mesaver:~0,2%%mesaver:~3,1%00+%mesaver:~9%
@if NOT "%mesaver:~5,2%"=="0-" set /a intmesaver=%mesaver:~0,2%%mesaver:~3,1%50+%mesaver:~5%
@for /R "%devroot%\%projectname%\bin\%abi%" %%a IN (vulkan_*.dll, libvulkan_*.dll, libVkLayer_*.dll, VkLayer_*.dll) do @for /f tokens^=1*^ delims^=_^ eol^= %%b IN ("%%~na") DO @(
@for /R "%devroot%\mesa\build\%toolchain%-%abi%\src" %%d IN (%%c*.json) do @for /f tokens^=*^ eol^= %%e IN ('echo %%~nd ^| find /V "devenv"') DO @(
@copy "%%~d" "%devroot%\%projectname%\bin\%abi%"
@if /I "%%c"=="lvp" IF %intmesaver% LSS 24100 call "%devroot%\%projectname%\buildscript\modules\fixvulkanjsons.cmd" "%%~na" "%%~nd"
@if /I "%%c"=="radeon" IF %intmesaver% LSS 24100 call "%devroot%\%projectname%\buildscript\modules\fixvulkanjsons.cmd" "%%~na" "%%~nd"
@if /I "%%c"=="dzn" IF %intmesaver% LSS 24100 call "%devroot%\%projectname%\buildscript\modules\fixvulkanjsons.cmd" "%%~na" "%%~nd"
@if /I NOT "%%c"=="lvp" if /I NOT "%%c"=="radeon" if /I NOT "%%c"=="dzn" call "%devroot%\%projectname%\buildscript\modules\fixvulkanjsons.cmd" "%%~na" "%%~nd"
)
@for /R "%devroot%\mesa\src" %%d IN (*%%c.json, *%%c.json.in) DO @(
@copy "%%~d" "%devroot%\%projectname%\bin\%abi%\VkLayer_%%c.json"
@call "%devroot%\%projectname%\buildscript\modules\fixvulkanjsons.cmd" "%%~na" "VkLayer_%%c"
)
)

@echo Copying static libraries...
@for /R "%devroot%\mesa\build\%toolchain%-%abi%" %%a IN (*.lib) do @IF EXIST "%%a" copy "%%a" "%devroot%\%projectname%\lib\%abi%"
@for /R "%devroot%\mesa\build\%toolchain%-%abi%" %%a IN (*.dll.a) do @IF EXIST "%%a" copy "%%a" "%devroot%\%projectname%\lib\%abi%"
@echo.

@echo Copying pkg-config scripts...
@for /R "%devroot%\mesa\build\%toolchain%-%abi%\meson-private" %%a IN (*.pc) do @IF EXIST "%%a" IF /I NOT "%%~na"=="DirectX-Headers" IF /I NOT "%%~na"=="libelf" IF /I NOT "%%~na"=="zlib" copy "%%a" "%devroot%\%projectname%\lib\%abi%\pkgconfig"
@echo.

@IF /I NOT "%keeplastbuild%"=="y" echo Copying headers...
@IF /I NOT "%keeplastbuild%"=="y" ROBOCOPY "%devroot%\mesa\include" "%devroot%\%projectname%\include" /E
@IF /I NOT "%keeplastbuild%"=="y" echo.

:donedist
@IF EXIST "%devroot%\%projectname%\bin\%abi%\*.dll" IF NOT EXIST "%devroot%\%projectname%\lib\%abi%\*.lib" IF EXIST "%devroot%\mesa\build\%toolchain%-%abi%\meson-logs\meson-log.txt" for /f delims^= %%i in ('type "%devroot%\mesa\build\%toolchain%-%abi%\meson-logs\meson-log.txt" ^| find "-Dbuildtype=d"') do @(
@echo Moving debug binaries to distinct location...
@MOVE "%devroot%\%projectname%\bin\%abi%\*.*" "%devroot%\%projectname%\debug\%abi%\"
@echo.
)
@endlocal
