@setlocal
@rem Create distribution.
@if NOT EXIST %devroot%\mesa\build\%toolchain%-%abi% GOTO exit

@rem Keep both clover standalone and ICD intact
@IF EXIST %devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\opencl\MesaOpenCL-1.dll IF EXIST %devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\opencl\MesaOpenCL.dll del %devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\opencl\MesaOpenCL.dll
@IF EXIST %devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\opencl\MesaOpenCL-1.dll REN %devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\opencl\MesaOpenCL-1.dll MesaOpenCL.dll
@IF EXIST %devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\opencl\OpenCL-1.dll IF EXIST %devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\opencl\OpenCL.dll del %devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\opencl\OpenCL.dll
@IF EXIST %devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\opencl\OpenCL-1.dll REN %devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\opencl\OpenCL-1.dll OpenCL.dll

@set dist=n
@set /p dist=Create or update Mesa3D distribution package (y/n):
@echo.
@if /I NOT "%dist%"=="y" GOTO exit
@cd %devroot%\%projectname%

@rem Detect if both osmesa classic and gallium are present
@set dualosmesa=0
@IF EXIST %devroot%\mesa\build\%toolchain%-%abi%\src\mesa\drivers\osmesa\osmesa.dll IF EXIST %devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\osmesa\osmesa.dll set dualosmesa=1

@rem Use legacy dist until osmesa classic is removed
@set legacydist=1
@IF %legacydist% EQU 1 GOTO legacydist

@IF %dualosmesa% EQU 1 GOTO distributed
@IF NOT %toolchain%==msvc %mesonloc% install --no-rebuild --skip-subprojects -C $(/usr/bin/cygpath -m ${devroot})/mesa/build/%toolchain%-${abi}"
@IF NOT %toolchain%==msvc GOTO distributed
@IF EXIST %devroot%\mesa\build\%toolchain%-%abi%\build.ninja IF %ninjastate% EQU 0 GOTO distributed
@IF EXIST %devroot%\mesa\build\%toolchain%-%abi%\build.ninja IF %ninjastate% EQU 1 set PATH=%devroot%\ninja\;%PATH%
@IF EXIST %devroot%\mesa\build\%toolchain%-%abi%\*.sln call %vsenv% %vsabi%
@%mesonloc% install --no-rebuild --skip-subprojects -C %devroot:\=/%/mesa/build/%toolchain%-%abi%
@IF %dualosmesa% EQU 0 GOTO distributed

@if NOT EXIST dist MD dist
@if EXIST dist\%toolchain%-%abi% RD /S /Q dist\%toolchain%-%abi%
@md dist\%toolchain%-%abi%
@MD dist\%toolchain%-%abi%\bin
@MD dist\%toolchain%-%abi%\lib
@MD dist\%toolchain%-%abi%\lib\pkgconfig
@MD dist\%toolchain%-%abi%\include
@MD dist\%toolchain%-%abi%\bin\osmesa-gallium
@MD dist\%toolchain%-%abi%\bin\osmesa-swrast
@MD dist\%toolchain%-%abi%\share
@MD dist\%toolchain%-%abi%\share\drirc.d
@GOTO mesondist

:legacydist
@if NOT EXIST "bin\" MD bin
@if NOT EXIST "lib\" MD lib
@if NOT EXIST "include\" MD include
@if EXIST "bin\%abi%\" RD /S /Q bin\%abi%
@if EXIST "lib\%abi%\" RD /S /Q lib\%abi%
@if EXIST "include\%abi%\" RD /S /Q include\%abi%
@MD bin\%abi%
@IF %dualosmesa% EQU 1 MD bin\%abi%\osmesa-gallium
@IF %dualosmesa% EQU 1 MD bin\%abi%\osmesa-swrast
@MD lib\%abi%
@MD include\%abi%

:mesondist
@IF %dualosmesa% EQU 1 forfiles /p %devroot%\mesa\build\%toolchain%-%abi%\src /s /m *.dll /c "cmd /c IF NOT @file==0x22osmesa.dll0x22 IF EXIST @path copy @path %devroot%\%projectname%\bin\%abi%"
@IF %dualosmesa% EQU 1 copy %devroot%\mesa\build\%toolchain%-%abi%\src\mesa\drivers\osmesa\osmesa.dll %devroot%\%projectname%\bin\%abi%\osmesa-swrast\osmesa.dll
@IF %dualosmesa% EQU 1 copy %devroot%\mesa\build\%toolchain%-%abi%\src\gallium\targets\osmesa\osmesa.dll %devroot%\%projectname%\bin\%abi%\osmesa-gallium\osmesa.dll
@IF %dualosmesa% EQU 0 forfiles /p %devroot%\mesa\build\%toolchain%-%abi%\src /s /m *.dll /c "cmd /c IF EXIST @path copy @path %devroot%\%projectname%\bin\%abi%"
@IF EXIST %devroot%\%projectname%\bin\%abi%\*on12compiler.dll forfiles /p %devroot%\clon12\out\%abi%\bin /s /m *.dll /c "cmd /c IF EXIST @path copy @path %devroot%\%projectname%\bin\%abi%"
@IF EXIST %devroot%\%projectname%\bin\%abi%\openglon12.dll IF NOT EXIST %devroot%\%projectname%\bin\%abi%\dxil.dll for /f tokens^=^* %%a in ('@call %devroot%\%projectname%\buildscript\modules\winsdk.cmd dxil') do @IF EXIST %%a copy %%a %devroot%\%projectname%\bin\%abi%
@IF EXIST %devroot%\%projectname%\bin\%abi%\openclon12.dll IF NOT EXIST %devroot%\%projectname%\bin\%abi%\dxil.dll for /f tokens^=^* %%a in ('@call %devroot%\%projectname%\buildscript\modules\winsdk.cmd dxil') do @IF EXIST %%a copy %%a %devroot%\%projectname%\bin\%abi%
@forfiles /p %devroot%\mesa\build\%toolchain%-%abi%\src /s /m *.exe /c "cmd /c IF EXIST @path copy @path %devroot%\%projectname%\bin\%abi%"
@IF EXIST %devroot%\%projectname%\bin\%abi%\vulkan_lvp.dll forfiles /p %devroot%\mesa\build\%toolchain%-%abi%\src /s /m lvp_icd.*.json /c "cmd /c IF EXIST @path copy @path %devroot%\%projectname%\bin\%abi%"
@IF EXIST %devroot%\%projectname%\bin\%abi%\*ulkan_radeon.dll forfiles /p %devroot%\mesa\build\%toolchain%-%abi%\src /s /m radeon_icd.*.json /c "cmd /c copy @path %devroot%\%projectname%\bin\%abi%"

@rem Patch Vulkan drivers JSONs
@IF EXIST %devroot%\%projectname%\bin\%abi%\lvp_icd.*.json call %devroot%\%projectname%\buildscript\modules\fixvulkanjsons.cmd lvp
@IF EXIST %devroot%\%projectname%\bin\%abi%\radeon_icd.*.json call %devroot%\%projectname%\buildscript\modules\fixvulkanjsons.cmd radeon

@rem Copy build development artifacts
@xcopy %devroot%\mesa\build\%toolchain%-%abi%\*.lib %devroot%\%projectname%\lib\%abi% /E /I /G
@xcopy %devroot%\mesa\build\%toolchain%-%abi%\*.a %devroot%\%projectname%\lib\%abi% /E /I /G
@xcopy %devroot%\mesa\build\%toolchain%-%abi%\*.h %devroot%\%projectname%\include\%abi% /E /I /G
@echo.

:distributed
@call %devroot%\%projectname%\buildscript\modules\addversioninfo.cmd
@rem IF EXIST %devroot%\%projectname%\lib\%abi%\src\gallium\targets\libgl-gdi\opengl32.dll.a IF EXIST %msysloc%\%LMSYSTEM%\bin\strip.exe IF EXIST %msysloc%\%LMSYSTEM%\bin\objcopy.exe echo.
@rem IF EXIST %devroot%\%projectname%\lib\%abi%\src\gallium\targets\libgl-gdi\opengl32.dll.a IF EXIST %msysloc%\%LMSYSTEM%\bin\strip.exe call %devroot%\%projectname%\buildscript\modules\collectdebugsymbols.cmd

:exit
@endlocal
@pause
@exit