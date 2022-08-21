@setlocal
@rem Create distribution.
@if NOT EXIST "%devroot%\mesa\build\%toolchain%-%abi%\" GOTO exit

@rem Keep both clover standalone and ICD intact
@IF EXIST "%devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\opencl\*penCL-1.dll" IF EXIST "%devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\opencl\*penCL.dll" del /Q "%devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\opencl\*penCL.dll"
@IF EXIST "%devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\opencl\MesaOpenCL-1.dll" REN "%devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\opencl\MesaOpenCL-1.dll" MesaOpenCL.dll
@IF EXIST "%devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\opencl\OpenCL-1.dll" REN "%devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\opencl\OpenCL-1.dll" OpenCL.dll
@IF EXIST "%devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\opencl\libMesaOpenCL-1.dll" REN "%devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\opencl\libMesaOpenCL-1.dll" MesaOpenCL.dll
@IF EXIST "%devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\opencl\libOpenCL-1.dll" REN "%devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\opencl\libOpenCL-1.dll" OpenCL.dll

@set dist=n
@set /p dist=Create or update Mesa3D distribution package (y/n):
@echo.
@if /I NOT "%dist%"=="y" GOTO exit
@cd "%devroot%\%projectname%"

@rem Normal distribution vs Meson install
@set normaldist=1
@IF %normaldist% EQU 1 GOTO normaldist

@IF %toolchain%==msvc GOTO distributed
@%mesonloc% install --no-rebuild --skip-subprojects -C "%devroot%\mesa\build\%toolchain%-%abi%"
@echo.
@GOTO distributed

:normaldist
@if NOT EXIST "bin\" MD bin
@if NOT EXIST "debugsymbols\" MD debugsymbols
@if NOT EXIST "lib\" MD lib
@if EXIST "bin\%abi%\" RD /S /Q bin\%abi%
@if EXIST "debugsymbols\%abi%\" RD /S /Q debugsymbols\%abi%
@if EXIST "lib\%abi%\" RD /S /Q lib\%abi%
@if EXIST "include\" RD /S /Q include
@MD bin\%abi%
@MD debugsymbols\%abi%
@MD lib\%abi%
@MD lib\%abi%\pkgconfig
@MD include

:mesondist
@echo Copying Mesa3D shared libraries...
@for /R "%devroot%\mesa\build\%toolchain%-%abi%\src" %%a IN (*.dll) do @IF EXIST "%%a" copy "%%a" "%devroot%\%projectname%\bin\%abi%"
@IF EXIST "%devroot%\%projectname%\bin\%abi%\libclon12compiler.dll" REN "%devroot%\%projectname%\bin\%abi%\libclon12compiler.dll" clon12compiler.dll
@echo.

@echo Copying runtimes for Microsoft drivers if needed...
@IF EXIST "%devroot%\%projectname%\bin\%abi%\*on12compiler.dll" for /R "%devroot%\clon12\out\%abi%\bin" %%a IN (*.dll) do @IF EXIST "%%a" copy "%%a" "%devroot%\%projectname%\bin\%abi%"
@IF EXIST "%devroot%\%projectname%\bin\%abi%\*pirv_to_dxil.dll" IF NOT EXIST "%devroot%\%projectname%\bin\%abi%\dxil.dll" for /f delims^=^ eol^= %%a in ('@call "%devroot%\%projectname%\buildscript\modules\winsdk.cmd" dxil') do @IF EXIST %%a copy %%a "%devroot%\%projectname%\bin\%abi%"
@IF EXIST "%devroot%\%projectname%\bin\%abi%\openglon12.dll" IF NOT EXIST "%devroot%\%projectname%\bin\%abi%\dxil.dll" for /f delims^=^ eol^= %%a in ('@call "%devroot%\%projectname%\buildscript\modules\winsdk.cmd" dxil') do @IF EXIST %%a copy %%a "%devroot%\%projectname%\bin\%abi%"
@IF EXIST "%devroot%\%projectname%\bin\%abi%\openclon12.dll" IF NOT EXIST "%devroot%\%projectname%\bin\%abi%\dxil.dll" for /f delims^=^ eol^= %%a in ('@call "%devroot%\%projectname%\buildscript\modules\winsdk.cmd" dxil') do @IF EXIST %%a copy %%a "%devroot%\%projectname%\bin\%abi%"
@IF EXIST "%devroot%\%projectname%\bin\%abi%\vulkan_dzn.dll" IF NOT EXIST "%devroot%\%projectname%\bin\%abi%\dxil.dll" for /f delims^=^ eol^= %%a in ('@call "%devroot%\%projectname%\buildscript\modules\winsdk.cmd" dxil') do @IF EXIST %%a copy %%a "%devroot%\%projectname%\bin\%abi%"
@echo.

@echo Copying test suite and commandline utilities...
@for /R "%devroot%\mesa\build\%toolchain%-%abi%\src" %%a IN (*.exe) do @IF EXIST "%%a" copy "%%a" "%devroot%\%projectname%\bin\%abi%"
@echo.

@echo Copying Vulkan drivers initialization configuration files if needed...
@IF EXIST "%devroot%\%projectname%\bin\%abi%\vulkan_lvp.dll" for /R "%devroot%\mesa\build\%toolchain%-%abi%\src" %%a IN (lvp_icd.*.json) do @IF EXIST "%%a" copy "%%a" "%devroot%\%projectname%\bin\%abi%"
@IF EXIST "%devroot%\%projectname%\bin\%abi%\*ulkan_radeon.dll" for /R "%devroot%\mesa\build\%toolchain%-%abi%\src" %%a IN (radeon_icd.*.json) do @IF EXIST "%%a" copy "%%a" "%devroot%\%projectname%\bin\%abi%"
@IF EXIST "%devroot%\%projectname%\bin\%abi%\vulkan_dzn.dll" for /R "%devroot%\mesa\build\%toolchain%-%abi%\src" %%a IN (dzn_icd.*.json) do @IF EXIST "%%a" copy "%%a" "%devroot%\%projectname%\bin\%abi%"
@echo.

@rem Patch Vulkan drivers JSONs
@IF EXIST "%devroot%\%projectname%\bin\%abi%\lvp_icd.*.json" call "%devroot%\%projectname%\buildscript\modules\fixvulkanjsons.cmd" lvp
@IF EXIST "%devroot%\%projectname%\bin\%abi%\radeon_icd.*.json" call "%devroot%\%projectname%\buildscript\modules\fixvulkanjsons.cmd" radeon
@IF EXIST "%devroot%\%projectname%\bin\%abi%\dzn_icd.*.json" call "%devroot%\%projectname%\buildscript\modules\fixvulkanjsons.cmd" dzn

@echo Copying static libraries...
@for /R "%devroot%\mesa\build\%toolchain%-%abi%" %%a IN (*.lib) do @IF EXIST "%%a" copy "%%a" "%devroot%\%projectname%\lib\%abi%"
@for /R "%devroot%\mesa\build\%toolchain%-%abi%" %%a IN (*.dll.a) do @IF EXIST "%%a" copy "%%a" "%devroot%\%projectname%\lib\%abi%"
@echo.

@echo Copying pkg-config scripts...
@for /R "%devroot%\mesa\build\%toolchain%-%abi%\meson-private" %%a IN (*.pc) do @IF EXIST "%%a" IF /I NOT "%%~na"=="DirectX-Headers" IF /I NOT "%%~na"=="libelf" IF /I NOT "%%~na"=="zlib" copy "%%a" "%devroot%\%projectname%\lib\%abi%\pkgconfig"
@echo.

@echo Copying headers...
@ROBOCOPY "%devroot%\mesa\include" "%devroot%\%projectname%\include" /E
@echo.

@echo Copying debug information...
@ROBOCOPY "%devroot%\mesa\build\%toolchain%-%abi%" "%devroot%\%projectname%\debugsymbols\%abi%" *.pdb /E
@echo.

:distributed
@call "%devroot%\%projectname%\buildscript\modules\addversioninfo.cmd"
@rem IF EXIST "%devroot%\%projectname%\lib\%abi%\src\gallium\targets\libgl-gdi\opengl32.dll.a" IF EXIST "%msysloc%\%LMSYSTEM%\bin\strip.exe" IF EXIST "%msysloc%\%LMSYSTEM%\bin\objcopy.exe" echo.
@rem IF EXIST "%devroot%\%projectname%\lib\%abi%\src\gallium\targets\libgl-gdi\opengl32.dll.a" IF EXIST "%msysloc%\%LMSYSTEM%\bin\strip.exe" call "%devroot%\%projectname%\buildscript\modules\collectdebugsymbols.cmd"

:exit
@endlocal
@pause
@exit