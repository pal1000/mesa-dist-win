@echo off
@cd /d "%~dp0"
@set "ERRORLEVEL="
@CMD /C EXIT 0
@"%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system" >nul 2>&1
@if NOT "%ERRORLEVEL%"=="0" (
@IF "%*"=="" powershell -Command Start-Process """%0""" -Verb runAs 2>nul
@IF NOT "%*"=="" powershell -Command Start-Process """%0""" """%*""" -Verb runAs 2>nul
@GOTO exit
)
:--------------------------------------
@IF "%*"=="" TITLE Mesa3D system-wide deployment utility
@IF "%*"=="" echo -------------------------------------
@IF "%*"=="" echo Mesa3D system-wide deployment utility
@IF "%*"=="" echo -------------------------------------
@IF "%*"=="" echo This deployment utility targets systems without working GPUs and any use case
@IF "%*"=="" echo where hardware accelerated OpenGL is not available. This mainly covers
@IF "%*"=="" echo virtual machines in cloud environments and RDP connections. It can be
@IF "%*"=="" echo used to replace Microsoft Windows inbox OpenGL 1.1 software render
@IF "%*"=="" echo driver with Mesa3D OpenGL drivers.
@IF "%*"=="" echo.
@IF "%*"=="" pause
@set CD=
@set mesaloc=%CD%
@IF %mesaloc:~0,1%%mesaloc:~-1%=="" set mesaloc=%mesaloc:~1,-1%
@IF "%mesaloc:~-1%"=="\" set mesaloc=%mesaloc:~0,-1%

:deploy
@IF "%*"=="" cls
@echo -------------------------------------
@echo Mesa3D system-wide deployment utility
@echo -------------------------------------
@echo Please make a deployment choice:

:option_1
@set option1=0
@IF NOT EXIST "%mesaloc%\x64\opengl32.dll" IF NOT EXIST "%mesaloc%\x86\opengl32.dll" IF NOT EXIST "%mesaloc%\x64\libgallium_wgl.dll" IF NOT EXIST "%mesaloc%\x86\libgallium_wgl.dll" GOTO option_2
@echo 1. Core desktop OpenGL drivers
@set option1=1

:option_2
@set option2=0
@IF %option1% EQU 1 IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%mesaloc%\x64\swr*.dll" set option2=1
@IF %option2% EQU 1 echo 2. Intel swr (depends on Core desktop OpenGL drivers to work)

:option_3
@set option3=0
@IF NOT EXIST "%mesaloc%\x86\dxil.dll" IF NOT EXIST "%mesaloc%\x64\dxil.dll" GOTO option_4
@echo 3. Install DirectX IL for redistribution only
@set option3=1

:option_4
@set option4=0
@IF EXIST "%mesaloc%\x86\dxil.dll" IF EXIST "%mesaloc%\x86\openglon12.dll" set option4=1
@IF EXIST "%mesaloc%\x64\dxil.dll" IF EXIST "%mesaloc%\x64\openglon12.dll" set option4=1
@IF %option4% EQU 0 GOTO option_5
@echo 4. Microsoft OpenGL over D3D12 driver only (replaces Mesa core desktop OpenGL drivers)

:option_5
@set option5=0
@IF NOT EXIST "%mesaloc%\x86\osmesa.dll" IF NOT EXIST "%mesaloc%\x64\osmesa.dll" GOTO option_6
@echo 5. Mesa3D off-screen render driver gallium version (osmesa gallium)
@set option5=1

:option_6
@set option6=0
@IF NOT EXIST "%mesaloc%\x86\graw.dll" IF NOT EXIST "%mesaloc%\x64\graw.dll" IF NOT EXIST "%mesaloc%\x86\graw_null.dll" IF NOT EXIST "%mesaloc%\x64\graw_null.dll" GOTO option_7
@echo 6. Gallium raw interface
@set option6=1

:option_7
@set mesainstalled=2
@IF NOT EXIST "%windir%\System32\openglon12.dll" IF NOT EXIST "%windir%\System32\mesadrv.dll" IF NOT EXIST "%windir%\System32\graw.dll" IF NOT EXIST "%windir%\System32\graw_null.dll" IF NOT EXIST "%windir%\System32\osmesa.dll" set /a mesainstalled-=1
@IF NOT EXIST "%windir%\SysWOW64\openglon12.dll" IF NOT EXIST "%windir%\SysWOW64\mesadrv.dll" IF NOT EXIST "%windir%\SysWOW64\graw.dll" IF NOT EXIST "%windir%\SysWOW64\graw_null.dll" IF NOT EXIST "%windir%\SysWOW64\osmesa.dll" set /a mesainstalled-=1
@IF %mesainstalled% GTR 0 echo 7. Update system-wide deployment
@IF "%1"=="" IF %mesainstalled% EQU 0 echo 7. Exit

:option_8
@IF %mesainstalled% GTR 0 echo 8. Remove system-wide deployments (uninstall)

:option_9
@IF "%1"=="" IF %mesainstalled% GTR 0 echo 9. Exit
@echo.

@set SystemDrive=
@IF EXIST "%SystemDrive%\Program Files\WindowsApps\Microsoft.D3DMappingLayers*" echo WARNING: System-wide Mesa3D desktop OpenGL drivers deployment won't work on your computer until you uninstall Microsoft OpenCL and OpenGL Compatibility Pack Windows store application. You are free to perform the deployment right now, but it won't take effect until conflicting software is removed.
@IF EXIST "%SystemDrive%\Program Files\WindowsApps\Microsoft.D3DMappingLayers*" echo.

@IF "%1"=="" set /p deploychoice=Enter choice:
@IF NOT "%1"=="" echo Enter choice:%1
@IF NOT "%1"=="" set deploychoice=%1
@if "%deploychoice%"=="1" IF %option1% EQU 1 GOTO desktopgl
@if "%deploychoice%"=="2" IF %option2% EQU 1 GOTO desktopgl
@if "%deploychoice%"=="3" IF %option3% EQU 1 GOTO instdxil
@if "%deploychoice%"=="4" IF %option4% EQU 1 GOTO instglon12
@if "%deploychoice%"=="5" IF %option5% EQU 1 GOTO osmesa
@if "%deploychoice%"=="6" IF %option6% EQU 1 GOTO graw
@if "%deploychoice%"=="7" IF %mesainstalled% GTR 0 GOTO update
@if "%deploychoice%"=="7" IF %mesainstalled% EQU 0 IF "%1"=="" GOTO bye
@if "%deploychoice%"=="8" IF %mesainstalled% GTR 0 GOTO uninstall
@if "%deploychoice%"=="9" IF %mesainstalled% GTR 0 IF "%1"=="" GOTO bye
@set deployerror=
@if "%deploychoice%"=="1" IF %option1% EQU 0 set deployerror=Invalid choice. Mesa3D desktop OpenGL drivers are not included in this Mesa3D release package.
@if "%deploychoice%"=="2" IF %option2% EQU 0 if /I NOT %PROCESSOR_ARCHITECTURE%==AMD64 set deployerror=Invalid choice. swr driver is only supported on x64/AMD64 systems.
@if "%deploychoice%"=="2" IF %option2% EQU 0 if /I %PROCESSOR_ARCHITECTURE%==AMD64 set deployerror=Invalid choice. swr driver is not available in this release package.
@if "%deploychoice%"=="3" IF %option3% EQU 0 set deployerror=Invalid choice. DirectX IL for redistribution is not available in this release package.
@if "%deploychoice%"=="4" IF %option4% EQU 0 set deployerror=Invalid choice. Microsoft OpenGL over D3D12 driver is not available in this release package.
@if "%deploychoice%"=="5" IF %option5% EQU 0 set deployerror=Invalid choice. osmesa gallium is not available in this release package.
@if "%deploychoice%"=="6" IF %option6% EQU 0 set deployerror=Invalid choice. Gallium raw interface is not available in this release package.
@if "%deploychoice%"=="7" IF %mesainstalled% EQU 0 IF NOT "%1"=="" set deployerror=Unattended mode does not support exit command.
@if "%deploychoice%"=="8" IF %mesainstalled% EQU 0 set deployerror=Error^: No Mesa3D drivers installed.
@if "%deploychoice%"=="9" IF %mesainstalled% GTR 0 IF NOT "%1"=="" set deployerror=Unattended mode does not support exit command.
@IF NOT defined deployerror set deployerror=Invaild choice.
@echo %deployerror%
@GOTO enddeploy

:desktopgl
@IF /I %PROCESSOR_ARCHITECTURE%==X86 IF NOT EXIST "%mesaloc%\x86\libgallium_wgl.dll" IF EXIST "%mesaloc%\x86\opengl32.dll" copy "%mesaloc%\x86\opengl32.dll" "%windir%\System32\mesadrv.dll"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF NOT EXIST "%mesaloc%\x86\libgallium_wgl.dll" IF EXIST "%mesaloc%\x86\opengl32.dll" copy "%mesaloc%\x86\opengl32.dll" "%windir%\SysWOW64\mesadrv.dll"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF NOT EXIST "%mesaloc%\x64\libgallium_wgl.dll" IF EXIST "%mesaloc%\x64\opengl32.dll" copy "%mesaloc%\x64\opengl32.dll" "%windir%\System32\mesadrv.dll"
@IF /I %PROCESSOR_ARCHITECTURE%==X86 IF EXIST "%mesaloc%\x86\libgallium_wgl.dll" copy "%mesaloc%\x86\libgallium_wgl.dll" "%windir%\System32\mesadrv.dll"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%mesaloc%\x86\libgallium_wgl.dll" copy "%mesaloc%\x86\libgallium_wgl.dll" "%windir%\SysWOW64\mesadrv.dll"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%mesaloc%\x64\libgallium_wgl.dll" copy "%mesaloc%\x64\libgallium_wgl.dll" "%windir%\System32\mesadrv.dll"
@IF /I %PROCESSOR_ARCHITECTURE%==X86 IF EXIST "%mesaloc%\x86\libglapi.dll" copy "%mesaloc%\x86\libglapi.dll" "%windir%\System32"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%mesaloc%\x86\libglapi.dll" copy "%mesaloc%\x86\libglapi.dll" "%windir%\SysWOW64"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%mesaloc%\x64\libglapi.dll" copy "%mesaloc%\x64\libglapi.dll" "%windir%\System32"
@IF /I %PROCESSOR_ARCHITECTURE%==X86 IF EXIST "%mesaloc%\x86\dxil.dll" copy "%mesaloc%\x86\dxil.dll" "%windir%\System32"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%mesaloc%\x86\dxil.dll" copy "%mesaloc%\x86\dxil.dll" "%windir%\SysWOW64"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%mesaloc%\x64\dxil.dll" copy "%mesaloc%\x64\dxil.dll" "%windir%\System32"
@if "%deploychoice%"=="2" IF /I %PROCESSOR_ARCHITECTURE%==AMD64 copy "%mesaloc%\x64\swr*.dll" "%windir%\System32"
@call modules\reggl.cmd mesadrv
@echo.
@echo Desktop OpenGL drivers deploy complete.
@GOTO enddeploy

:instdxil
@IF /I %PROCESSOR_ARCHITECTURE%==X86 IF EXIST "%mesaloc%\x86\dxil.dll" copy "%mesaloc%\x86\dxil.dll" "%windir%\System32"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%mesaloc%\x86\dxil.dll" copy "%mesaloc%\x86\dxil.dll" "%windir%\SysWOW64"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%mesaloc%\x64\dxil.dll" copy "%mesaloc%\x64\dxil.dll" "%windir%\System32"
@echo.
@echo Install DirectX IL for redistribution complete.
@GOTO enddeploy

:instglon12
@IF /I %PROCESSOR_ARCHITECTURE%==X86 IF EXIST "%mesaloc%\x86\openglon12.dll" copy "%mesaloc%\x86\openglon12.dll" "%windir%\System32"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%mesaloc%\x86\openglon12.dll" copy "%mesaloc%\x86\openglon12.dll" "%windir%\SysWOW64"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%mesaloc%\x64\openglon12.dll" copy "%mesaloc%\x64\openglon12.dll" "%windir%\System32"
@IF /I %PROCESSOR_ARCHITECTURE%==X86 IF EXIST "%mesaloc%\x86\libglapi.dll" copy "%mesaloc%\x86\libglapi.dll" "%windir%\System32"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%mesaloc%\x86\libglapi.dll" copy "%mesaloc%\x86\libglapi.dll" "%windir%\SysWOW64"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%mesaloc%\x64\libglapi.dll" copy "%mesaloc%\x64\libglapi.dll" "%windir%\System32"
@IF /I %PROCESSOR_ARCHITECTURE%==X86 IF EXIST "%mesaloc%\x86\dxil.dll" copy "%mesaloc%\x86\dxil.dll" "%windir%\System32"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%mesaloc%\x86\dxil.dll" copy "%mesaloc%\x86\dxil.dll" "%windir%\SysWOW64"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%mesaloc%\x64\dxil.dll" copy "%mesaloc%\x64\dxil.dll" "%windir%\System32"
@call modules\reggl.cmd openglon12
@echo.
@echo Microsoft desktop OpenGL over D3D12 driver deploy complete.
@GOTO enddeploy

:osmesa
@IF /I %PROCESSOR_ARCHITECTURE%==X86 IF EXIST "%mesaloc%\x86\osmesa.dll" copy "%mesaloc%\x86\osmesa.dll" "%windir%\System32"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%mesaloc%\x86\osmesa.dll" copy "%mesaloc%\x86\osmesa.dll" "%windir%\SysWOW64"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%mesaloc%\x64\osmesa.dll" copy "%mesaloc%\x64\osmesa.dll" "%windir%\System32"
@IF /I %PROCESSOR_ARCHITECTURE%==X86 IF EXIST "%mesaloc%\x86\libglapi.dll" copy "%mesaloc%\x86\libglapi.dll" "%windir%\System32"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%mesaloc%\x86\libglapi.dll" copy "%mesaloc%\x86\libglapi.dll" "%windir%\SysWOW64"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%mesaloc%\x64\libglapi.dll" copy "%mesaloc%\x64\libglapi.dll" "%windir%\System32"
@echo.
@echo Off-screen render driver deploy complete.
@GOTO enddeploy

:graw
@IF /I %PROCESSOR_ARCHITECTURE%==X86 IF EXIST "%mesaloc%\x86\graw.dll" copy "%mesaloc%\x86\graw.dll" "%windir%\System32"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%mesaloc%\x86\graw.dll" copy "%mesaloc%\x86\graw.dll" "%windir%\SysWOW64"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%mesaloc%\x64\graw.dll" copy "%mesaloc%\x64\graw.dll" "%windir%\System32"
@IF /I %PROCESSOR_ARCHITECTURE%==X86 IF EXIST "%mesaloc%\x86\graw_null.dll" copy "%mesaloc%\x86\graw_null.dll" "%windir%\System32"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%mesaloc%\x86\graw_null.dll" copy "%mesaloc%\x86\graw_null.dll" "%windir%\SysWOW64"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%mesaloc%\x64\graw_null.dll" copy "%mesaloc%\x64\graw_null.dll" "%windir%\System32"
@IF /I %PROCESSOR_ARCHITECTURE%==X86 IF EXIST "%mesaloc%\x86\libglapi.dll" copy "%mesaloc%\x86\libglapi.dll" "%windir%\System32"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%mesaloc%\x86\libglapi.dll" copy "%mesaloc%\x86\libglapi.dll" "%windir%\SysWOW64"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%mesaloc%\x64\libglapi.dll" copy "%mesaloc%\x64\libglapi.dll" "%windir%\System32"
@echo.
@echo Gallium raw interface deploy complete.
@GOTO enddeploy

:update
@IF /I %PROCESSOR_ARCHITECTURE%==X86 IF EXIST "%windir%\System32\mesadrv.dll" IF NOT EXIST "%mesaloc%\x86\libgallium_wgl.dll" IF EXIST "%mesaloc%\x86\opengl32.dll" copy "%mesaloc%\x86\opengl32.dll" "%windir%\System32\mesadrv.dll"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%windir%\SysWOW64\mesadrv.dll" IF NOT EXIST "%mesaloc%\x86\libgallium_wgl.dll" IF EXIST "%mesaloc%\x86\opengl32.dll" copy "%mesaloc%\x86\opengl32.dll" "%windir%\SysWOW64\mesadrv.dll"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%windir%\System32\mesadrv.dll" IF NOT EXIST "%mesaloc%\x64\libgallium_wgl.dll" IF EXIST "%mesaloc%\x64\opengl32.dll" copy "%mesaloc%\x64\opengl32.dll" "%windir%\System32\mesadrv.dll"
@IF /I %PROCESSOR_ARCHITECTURE%==X86 IF EXIST "%windir%\System32\mesadrv.dll" IF EXIST "%mesaloc%\x86\libgallium_wgl.dll" copy "%mesaloc%\x86\libgallium_wgl.dll" "%windir%\System32\mesadrv.dll"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%windir%\SysWOW64\mesadrv.dll" IF EXIST "%mesaloc%\x86\libgallium_wgl.dll" copy "%mesaloc%\x86\libgallium_wgl.dll" "%windir%\SysWOW64\mesadrv.dll"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%windir%\System32\mesadrv.dll" IF EXIST "%mesaloc%\x64\libgallium_wgl.dll" copy "%mesaloc%\x64\libgallium_wgl.dll" "%windir%\System32\mesadrv.dll"
@IF /I %PROCESSOR_ARCHITECTURE%==X86 IF EXIST "%windir%\System32\libglapi.dll" IF EXIST "%mesaloc%\x86\libglapi.dll" copy "%mesaloc%\x86\libglapi.dll" "%windir%\System32"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%windir%\SysWOW64\libglapi.dll" IF EXIST "%mesaloc%\x86\libglapi.dll" copy "%mesaloc%\x86\libglapi.dll" "%windir%\SysWOW64"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%windir%\System32\libglapi.dll" IF EXIST "%mesaloc%\x64\libglapi.dll" copy "%mesaloc%\x64\libglapi.dll" "%windir%\System32"
@IF /I %PROCESSOR_ARCHITECTURE%==X86 IF EXIST "%windir%\System32\dxil.dll" IF EXIST "%mesaloc%\x86\dxil.dll" copy "%mesaloc%\x86\dxil.dll" "%windir%\System32"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%windir%\SysWOW64\dxil.dll" IF EXIST "%mesaloc%\x86\dxil.dll" copy "%mesaloc%\x86\dxil.dll" "%windir%\SysWOW64"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%windir%\System32\dxil.dll" IF EXIST "%mesaloc%\x64\dxil.dll" copy "%mesaloc%\x64\dxil.dll" "%windir%\System32"
@IF /I %PROCESSOR_ARCHITECTURE%==X86 IF EXIST "%windir%\System32\openglon12.dll" IF EXIST "%mesaloc%\x86\openglon12.dll" copy "%mesaloc%\x86\openglon12.dll" "%windir%\System32"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%windir%\SysWOW64\openglon12.dll" IF EXIST "%mesaloc%\x86\openglon12.dll" copy "%mesaloc%\x86\openglon12.dll" "%windir%\SysWOW64"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%windir%\System32\openglon12.dll" IF EXIST "%mesaloc%\x64\openglon12.dll" copy "%mesaloc%\x64\openglon12.dll" "%windir%\System32"
@IF EXIST "%windir%\System32\swrAVX.dll" copy "%mesaloc%\x64\swrAVX.dll" "%windir%\System32"
@IF EXIST "%windir%\System32\swrAVX2.dll" copy "%mesaloc%\x64\swrAVX2.dll" "%windir%\System32"
@IF EXIST "%windir%\System32\swrSKX.dll" copy "%mesaloc%\x64\swrSKX.dll" "%windir%\System32"
@IF EXIST "%windir%\System32\swrKNL.dll" copy "%mesaloc%\x64\swrKNL.dll" "%windir%\System32"
@IF /I %PROCESSOR_ARCHITECTURE%==X86 IF EXIST "%windir%\System32\graw.dll" copy "%mesaloc%\x86\graw.dll" "%windir%\System32"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%windir%\SysWOW64\graw.dll" copy "%mesaloc%\x86\graw.dll" "%windir%\SysWOW64"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%windir%\System32\graw.dll" copy "%mesaloc%\x64\graw.dll" "%windir%\System32"
@IF /I %PROCESSOR_ARCHITECTURE%==X86 IF EXIST "%windir%\System32\graw_null.dll" IF EXIST "%mesaloc%\x86\graw_null.dll" copy "%mesaloc%\x86\graw_null.dll" "%windir%\System32"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%windir%\SysWOW64\graw_null.dll" IF EXIST "%mesaloc%\x86\graw_null.dll" copy "%mesaloc%\x86\graw_null.dll" "%windir%\SysWOW64"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%windir%\System32\graw_null.dll" IF EXIST "%mesaloc%\x64\graw_null.dll" copy "%mesaloc%\x64\graw_null.dll" "%windir%\System32"
@IF /I %PROCESSOR_ARCHITECTURE%==X86 IF EXIST "%windir%\System32\osmesa.dll" IF EXIST "%mesaloc%\x86\osmesa.dll" copy "%mesaloc%\x86\osmesa.dll" "%windir%\System32"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%windir%\System32\osmesa.dll" IF EXIST "%mesaloc%\x86\osmesa.dll" copy "%mesaloc%\x86\osmesa.dll" "%windir%\SysWOW64"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%windir%\System32\osmesa.dll" IF EXIST "%mesaloc%\x64\osmesa.dll" copy "%mesaloc%\x64\osmesa.dll" "%windir%\System32"
@echo.
@echo Update complete.
@GOTO enddeploy

:uninstall
@IF "%1"=="" set keepdxil=y
@IF "%1"=="" set /p keepdxil=Do you want to keep DirectX IL for redistribution (y/n, default - y):
@IF "%1"=="" echo.
@IF NOT "%1"=="" set keepdxil=n
@call modules\unreggl.cmd mesadrv
@call modules\unreggl.cmd openglon12
@IF EXIST "%windir%\System32\mesadrv.dll" del "%windir%\System32\mesadrv.dll"
@IF EXIST "%windir%\System32\libglapi.dll" del "%windir%\System32\libglapi.dll"
@IF /I "%keepdxil%"=="n" IF EXIST "%windir%\System32\dxil.dll" del "%windir%\System32\dxil.dll"
@IF EXIST "%windir%\System32\openglon12.dll" del "%windir%\System32\openglon12.dll"
@IF EXIST "%windir%\System32\graw.dll" del "%windir%\System32\graw.dll"
@IF EXIST "%windir%\System32\graw_null.dll" del "%windir%\System32\graw_null.dll"
@IF EXIST "%windir%\System32\osmesa.dll" del "%windir%\System32\osmesa.dll"
@IF EXIST "%windir%\System32\swrAVX.dll" del "%windir%\System32\swrAVX.dll"
@IF EXIST "%windir%\System32\swrAVX2.dll" del "%windir%\System32\swrAVX2.dll"
@IF EXIST "%windir%\System32\swrSKX.dll" del "%windir%\System32\swrSKX.dll"
@IF EXIST "%windir%\System32\swrKNL.dll" del "%windir%\System32\swrKNL.dll"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%windir%\SysWOW64\mesadrv.dll" del "%windir%\SysWOW64\mesadrv.dll"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%windir%\SysWOW64\libglapi.dll" del "%windir%\SysWOW64\libglapi.dll"
@IF /I "%keepdxil%"=="n" IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%windir%\SysWOW64\dxil.dll" del "%windir%\SysWOW64\dxil.dll"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%windir%\SysWOW64\openglon12.dll" del "%windir%\SysWOW64\openglon12.dll"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%windir%\SysWOW64\osmesa.dll" del "%windir%\SysWOW64\osmesa.dll"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%windir%\SysWOW64\graw.dll" del "%windir%\SysWOW64\graw.dll"
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%windir%\SysWOW64\graw_null.dll" del "%windir%\SysWOW64\graw_null.dll"
@echo.
@echo Uninstall complete.

:enddeploy
@IF "%1"=="" pause
@IF "%1"=="" GOTO deploy
@IF NOT "%1"=="" GOTO exit

:bye
@echo Good Bye!
@IF "%1"=="" pause

:exit
