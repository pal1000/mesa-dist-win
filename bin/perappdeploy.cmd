@echo off
@cd /d "%~dp0"
@set "ERRORLEVEL="
@CMD /C EXIT 0
@"%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system" >nul 2>&1
@if NOT "%ERRORLEVEL%"=="0" (
@powershell -Command Start-Process """%0""" -Verb runAs 2>nul
@exit
)
:--------------------------------------
@TITLE Mesa3D per-application deployment utility
@echo Mesa3D per-application deployment utility
@echo -----------------------------------------
@echo This deployment utility allows for per-application deployments of Mesa3D
@echo without manual copy-paste allowing updates to Mesa3D from a central location.
@echo It is intended for systems with working GPUs.
@echo This helps a lot if you have many programs that you want to use Mesa3D with.
@echo Some applications may still use the GPU if they are smart enough to only load
@echo OpenGL DLL from system directory.
@echo To overcome this you may enter the program executable filename and a .local
@echo file is generated for it or use Mesainjector made by Federico Dossena.
@echo However Mesainjector does not work with Windows 10 Version 1803 and newer.
@echo Download: https://downloads.fdossena.com/Projects/Mesa3D/Injector/index.php
@echo Build Mesainjector - https://fdossena.com/?p=mesa/injector_build.frag
@echo.
@pause
@set CD=
@set mesaloc=%CD%
@IF %mesaloc:~0,1%%mesaloc:~-1%=="" set mesaloc=%mesaloc:~1,-1%
@IF "%mesaloc:~-1%"=="\" set mesaloc=%mesaloc:~0,-1%

:deploy
@cls
@echo Mesa3D per-application deployment utility
@echo -----------------------------------------
@echo Please provide the path to the folder that contains the application launcher
@echo executable. It is recommended to copy-paste it from Windows Explorer using
@echo CTRL+V. The right click paste introduced in Windows 10 may lead to unexpected
@echo double paste. Also don't worry if path contains spaces, parantheses or other
@echo symbols, it is enclosed in quotes automatically so you don't need to add them
@echo manually.
@echo.
@set dir=
@set /p dir=Path to folder holding application executable:
@echo.
@IF %dir:~0,1%%dir:~-1%=="" set dir=%dir:~1,-1%
@IF "%dir:~-1%"=="\" set dir=%dir:~0,-1%
@IF NOT EXIST "%dir%" echo Error: That location doesn't exist.
@IF NOT EXIST "%dir%" pause
@IF NOT EXIST "%dir%" GOTO deploy

@echo Removing existing Mesa3D deployments for this folder...
@echo Note 1: .local files are removed only if application executable name is specified later and desktop OpenGL deployment is rejected.
@echo Note 2: DirectX IL, OpenGL ES stack, WGL loader and clover standalone are removed only if they are symbolic links.
@echo.
@set founddesktopgl=0
@set foundclover=0
@set foundswr=0
@set foundosmesa=0
@set foundgraw=0
@set foundvaapi=0
@set overwritewarn=
@for /f delims^=^ eol^= %%a IN ('dir /A:L /B "%dir%" 2^>^&1') DO @(
@IF /I "%%~nxa"=="opengl32.dll" set founddesktopgl=1
@IF /I "%%~nxa"=="opengl32.dll" del "%dir%\%%~nxa"
@IF /I "%%~nxa"=="opengl32sw.dll" set founddesktopgl=1
@IF /I "%%~nxa"=="opengl32sw.dll" del "%dir%\%%~nxa"
@IF /I "%%~nxa"=="dxil.dll" del "%dir%\%%~nxa"
@IF /I "%%~nxa"=="libEGL.dll" del "%dir%\%%~nxa"
@IF /I "%%~nxa"=="libGLESv1_CM.dll" del "%dir%\%%~nxa"
@IF /I "%%~nxa"=="libGLESv2.dll" del "%dir%\%%~nxa"
@IF /I "%%~nxa"=="OpenCL.dll" del "%dir%\%%~nxa"
)
@if EXIST "%dir%\opengl32.dll" set overwritewarn=%overwritewarn%opengl32.dll,
@if EXIST "%dir%\opengl32sw.dll" set overwritewarn=%overwritewarn%opengl32sw.dll,
@if EXIST "%dir%\dxil.dll" set overwritewarn=%overwritewarn%dxil.dll,
@if EXIST "%dir%\libEGL.dll" set overwritewarn=%overwritewarn%libEGL.dll,
@if EXIST "%dir%\libGLESv1_CM.dll" set overwritewarn=%overwritewarn%libGLESv1_CM.dll,
@if EXIST "%dir%\libGLESv2.dll" set overwritewarn=%overwritewarn%libGLESv2.dll,
@if EXIST "%dir%\OpenCL.dll" set overwritewarn=%overwritewarn%OpenCL.dll,
@if defined overwritewarn echo WARNING: These files may get overwritten depending which Mesa3D components you choose to deploy: %overwritewarn:~0,-1%. If Mesa3D doesn't help or you choose to wipe the deployment a reinstall/repair install of affected software is necessary to restore original files.
@if defined overwritewarn echo.
@IF EXIST "%dir%\libgallium_wgl.dll" del "%dir%\libgallium_wgl.dll"
@IF EXIST "%dir%\libglapi.dll" del "%dir%\libglapi.dll"
@if EXIST "%dir%\swrAVX.dll" set foundswr=1
@if EXIST "%dir%\swrAVX.dll" del "%dir%\swrAVX.dll"
@if EXIST "%dir%\swrAVX2.dll" set foundswr=1
@if EXIST "%dir%\swrAVX2.dll" del "%dir%\swrAVX2.dll"
@if EXIST "%dir%\swrSKX.dll" set foundswr=1
@if EXIST "%dir%\swrSKX.dll" del "%dir%\swrSKX.dll"
@if EXIST "%dir%\swrKNL.dll" set foundswr=1
@if EXIST "%dir%\swrKNL.dll" del "%dir%\swrKNL.dll"
@if EXIST "%dir%\pipe_swrast.dll" set foundclover=1
@if EXIST "%dir%\pipe_swrast.dll" del "%dir%\pipe_swrast.dll"
@IF EXIST "%dir%\osmesa.dll" set foundosmesa=1
@IF EXIST "%dir%\osmesa.dll" del "%dir%\osmesa.dll"
@if EXIST "%dir%\graw.dll" set foundgraw=1
@if EXIST "%dir%\graw.dll" del "%dir%\graw.dll"
@if EXIST "%dir%\graw_null.dll" set foundgraw=1
@if EXIST "%dir%\graw_null.dll" del "%dir%\graw_null.dll"
@if EXIST "%dir%\va.dll" set foundvaapi=1
@if EXIST "%dir%\va.dll" del "%dir%\va.dll"
@if EXIST "%dir%\va_win32.dll" set foundvaapi=1
@if EXIST "%dir%\va_win32.dll" del "%dir%\va_win32.dll"
@if EXIST "%dir%\vaon12_drv_video.dll" set foundvaapi=1
@if EXIST "%dir%\vaon12_drv_video.dll" del "%dir%\vaon12_drv_video.dll"
@echo Done.
@echo.

@set continue_deploy=
@set /p continue_deploy=Continue with deployment? (y=yes):
@echo.
@if /I NOT "%continue_deploy%"=="y" EXIT /b

:askforappexe
@set appexe=
@set /p appexe=Application executable name with or without extension (optional, try leaving it blank first and only specify it if things don't work otherwise; it forces some programs to use Mesa3D which would otherwise bypass it):
@echo.
@IF "%appexe%"=="" GOTO ask_for_app_abi
@IF /I NOT "%appexe:~-4%"==".exe" set appexe=%appexe%.exe
@IF NOT EXIST "%dir%\%appexe%" echo Error: File not found.
@IF NOT EXIST "%dir%\%appexe%" pause
@IF NOT EXIST "%dir%\%appexe%" cls
@IF NOT EXIST "%dir%\%appexe%" GOTO askforappexe
@IF EXIST "%dir%\%appexe%.local" del "%dir%\%appexe%.local"

:ask_for_app_abi
@set mesadll=x86
@if /I NOT %PROCESSOR_ARCHITECTURE%==AMD64 if /I NOT %PROCESSOR_ARCHITECTURE%==ARM64 GOTO desktopgl
@echo Select processor architecture compatible with program you want to use Mesa3D with
@call modules\abiselect.cmd
@if %cpuchoice% EQU 2 set mesadll=x64
@if %cpuchoice% EQU 3 set mesadll=aarch64
@echo.

:desktopgl
@set desktopgl=n
@IF EXIST "%mesaloc%\%mesadll%\opengl32.dll" set desktopgl=y
@IF EXIST "%mesaloc%\%mesadll%\opengl32.dll" set /p desktopgl=Do you want Desktop OpenGL drivers (y/n, defaults to yes):
@IF EXIST "%mesaloc%\%mesadll%\opengl32.dll" echo.
@IF /I "%desktopgl%"=="n" GOTO opengles
@IF %founddesktopgl% EQU 1 echo Updating core desktop OpenGL deployment...
@IF EXIST "%mesaloc%\%mesadll%\dxil.dll" IF EXIST "%dir%\dxil.dll" del "%dir%\dxil.dll"
@IF EXIST "%dir%\opengl32.dll" del "%dir%\opengl32.dll"
@IF EXIST "%dir%\opengl32sw.dll" del "%dir%\opengl32sw.dll"
@call modules\mklink.cmd opengl32
@call modules\mklink.cmd opengl32sw
@IF EXIST "%mesaloc%\%mesadll%\libglapi.dll" IF NOT EXIST "%dir%\libglapi.dll" call modules\mklink.cmd libglapi
@IF EXIST "%mesaloc%\%mesadll%\libgallium_wgl.dll" IF NOT EXIST "%dir%\libgallium_wgl.dll" call modules\mklink.cmd libgallium_wgl
@IF EXIST "%mesaloc%\%mesadll%\dxil.dll" IF NOT EXIST "%dir%\dxil.dll" call modules\mklink.cmd dxil
@IF NOT "%dir%\%appexe%"=="%dir%\" echo dummy > "%dir%\%appexe%.local"
@echo.
@set swr=n
@IF EXIST "%mesaloc%\%mesadll%\swr*.dll" if %mesadll%==x64 set /p swr=Do you want swr driver - the new desktop OpenGL driver made by Intel (y/n):
@IF EXIST "%mesaloc%\%mesadll%\swr*.dll" if %mesadll%==x64 echo.
@IF /I NOT "%swr%"=="y" GOTO opengles
@IF %foundswr% EQU 1 echo Updating swr driver deployment...
@IF EXIST "%mesaloc%\%mesadll%\swrAVX.dll" IF NOT EXIST "%dir%\swrAVX.dll" call modules\mklink.cmd swrAVX
@IF EXIST "%mesaloc%\%mesadll%\swrAVX2.dll" IF NOT EXIST "%dir%\swrAVX2.dll" call modules\mklink.cmd swrAVX2
@IF EXIST "%mesaloc%\%mesadll%\swrSKX.dll" IF NOT EXIST "%dir%\swrSKX.dll" call modules\mklink.cmd swrSKX
@IF EXIST "%mesaloc%\%mesadll%\swrKNL.dll" IF NOT EXIST "%dir%\swrKNL.dll" call modules\mklink.cmd swrKNL
@echo.

:opengles
@set opengles=
@IF EXIST "%mesaloc%\%mesadll%\libGLESv2.dll" IF EXIST "%mesaloc%\%mesadll%\libglapi.dll" set /p opengles=Do you need OpenGL ES support (y/n):
@IF EXIST "%mesaloc%\%mesadll%\libGLESv2.dll" IF EXIST "%mesaloc%\%mesadll%\libglapi.dll" echo.
@IF /I NOT "%opengles%"=="y" GOTO clover
@IF EXIST "%dir%\libEGL.dll" del "%dir%\libEGL.dll"
@if EXIST "%dir%\libGLESv1_CM.dll" del "%dir%\libGLESv1_CM.dll"
@if EXIST "%dir%\libGLESv2.dll" del "%dir%\libGLESv2.dll"
@IF NOT EXIST "%mesaloc%\%mesadll%\libgallium_wgl.dll" IF EXIST "%mesaloc%\%mesadll%\opengl32.dll" IF EXIST "%dir%\opengl32.dll" del "%dir%\opengl32.dll"
@IF NOT EXIST "%mesaloc%\%mesadll%\libgallium_wgl.dll" IF EXIST "%mesaloc%\%mesadll%\opengl32.dll" IF EXIST "%dir%\opengl32sw.dll" del "%dir%\opengl32sw.dll"
@IF EXIST "%mesaloc%\%mesadll%\libglapi.dll" IF NOT EXIST "%dir%\libglapi.dll" call modules\mklink.cmd libglapi
@IF EXIST "%mesaloc%\%mesadll%\libEGL.dll" IF NOT EXIST "%dir%\libEGL.dll" call modules\mklink.cmd libEGL
@IF EXIST "%mesaloc%\%mesadll%\libgallium_wgl.dll" IF NOT EXIST "%dir%\libgallium_wgl.dll" call modules\mklink.cmd libgallium_wgl
@IF NOT EXIST "%mesaloc%\%mesadll%\libgallium_wgl.dll" IF EXIST "%mesaloc%\%mesadll%\opengl32.dll" IF NOT EXIST "%dir%\opengl32.dll" call modules\mklink.cmd opengl32
@IF NOT EXIST "%mesaloc%\%mesadll%\libgallium_wgl.dll" IF EXIST "%mesaloc%\%mesadll%\opengl32.dll" IF NOT EXIST "%dir%\opengl32sw.dll" call modules\mklink.cmd opengl32sw
@IF EXIST "%mesaloc%\%mesadll%\libGLESv1_CM.dll" IF NOT EXIST "%dir%\libGLESv1_CM.dll" call modules\mklink.cmd libGLESv1_CM
@IF EXIST "%mesaloc%\%mesadll%\libGLESv2.dll" IF NOT EXIST "%dir%\libGLESv2.dll" call modules\mklink.cmd libGLESv2
@echo.

:clover
@set deploy_clover=
@IF EXIST "%mesaloc%\%mesadll%\OpenCL.dll" IF EXIST "%mesaloc%\%mesadll%\pipe_*.dll" set /p deploy_clover=Deploy Mesa3D OpenCL clover driver as the only OpenCL driver for this program hiding all other drivers registered system-wide (y/n):
@IF EXIST "%mesaloc%\%mesadll%\OpenCL.dll" IF EXIST "%mesaloc%\%mesadll%\pipe_*.dll" echo.
@if /I NOT "%deploy_clover%"=="y" GOTO osmesa
@IF %foundclover% EQU 1 echo Updating Mesa3D clover deployment...
@IF EXIST "%dir%\OpenCL.dll" del "%dir%\OpenCL.dll"
@IF EXIST "%mesaloc%\%mesadll%\OpenCL.dll" IF NOT EXIST "%dir%\OpenCL.dll" call modules\mklink.cmd OpenCL
@IF EXIST "%mesaloc%\%mesadll%\pipe_swrast.dll" IF NOT EXIST "%dir%\pipe_swrast.dll" call modules\mklink.cmd pipe_swrast
@echo.

:osmesa
@set osmesa=
@IF EXIST "%mesaloc%\%mesadll%\osmesa.dll" set /p osmesa=Do you need off-screen rendering (y/n):
@IF EXIST "%mesaloc%\%mesadll%\osmesa.dll" echo.
@if /I NOT "%osmesa%"=="y" GOTO graw
@IF %foundosmesa% EQU 1 echo Updating Mesa3D off-screen rendering interface deployment...
@call modules\mklink.cmd osmesa
@IF EXIST "%mesaloc%\%mesadll%\libglapi.dll" IF NOT EXIST "%dir%\libglapi.dll" call modules\mklink.cmd libglapi
@echo.

:graw
@set graw=
@if NOT EXIST "%mesaloc%\%mesadll%\graw.dll" if NOT EXIST "%mesaloc%\%mesadll%\graw_null.dll" GOTO vaapi
@set /p graw=Do you need gallium raw interface (y/n):
@echo.
@if /I NOT "%graw%"=="y" GOTO vaapi
@IF %foundgraw% EQU 1 echo Updating Gallium raw interface deployment...
@IF EXIST "%mesaloc%\%mesadll%\graw.dll" if NOT EXIST "%dir%\graw.dll" call modules\mklink.cmd graw
@IF EXIST "%mesaloc%\%mesadll%\graw_null.dll" if NOT EXIST "%dir%\graw_null.dll" call modules\mklink.cmd graw_null
@IF EXIST "%mesaloc%\%mesadll%\libglapi.dll" if NOT EXIST "%dir%\libglapi.dll" call modules\mklink.cmd libglapi
@echo.

:vaapi
@if EXIST "%mesaloc%\%mesadll%\va.dll" if EXIST "%mesaloc%\%mesadll%\va_win32.dll" if EXIST "%mesaloc%\%mesadll%\vaon12_drv_video.dll" set /p vaapi=Deploy video acceleration support (y/n):
@if EXIST "%mesaloc%\%mesadll%\va.dll" if EXIST "%mesaloc%\%mesadll%\va_win32.dll" if EXIST "%mesaloc%\%mesadll%\vaon12_drv_video.dll" echo.
@if /I NOT "%vaapi%"=="y" GOTO restart
@IF %foundvaapi% EQU 1 echo Updating VA-API interface deployment...
@IF EXIST "%mesaloc%\%mesadll%\va.dll" if NOT EXIST "%dir%\va.dll" call modules\mklink.cmd va
@IF EXIST "%mesaloc%\%mesadll%\va_win32.dll" if NOT EXIST "%dir%\va_win32.dll" call modules\mklink.cmd va_win32
@IF EXIST "%mesaloc%\%mesadll%\vaon12_drv_video.dll" if NOT EXIST "%dir%\vaon12_drv_video.dll" call modules\mklink.cmd vaon12_drv_video
@IF EXIST "%mesaloc%\%mesadll%\dxil.dll" IF EXIST "%dir%\dxil.dll" del "%dir%\dxil.dll"
@IF EXIST "%mesaloc%\%mesadll%\dxil.dll" IF NOT EXIST "%dir%\dxil.dll" call modules\mklink.cmd dxil

:restart
@set rerun=
@echo.
@set /p rerun=More Mesa deployment? (y=yes):
@echo.
@if /I "%rerun%"=="y" GOTO deploy
