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
@set mesaloc=%~dp0
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
@set /p dir=Path to folder holding application executable:
@IF NOT EXIST "%dir%" echo.
@IF NOT EXIST "%dir%" echo Error: That location doesn't exist.
@IF NOT EXIST "%dir%" pause
@IF NOT EXIST "%dir%" GOTO deploy
@echo.

:askforappexe
@set /p appexe=Application executable name with or without extension (optional, forces some programs to use Mesa3D which would otherwise bypass it):
@echo.
@IF "%appexe%"=="" IF EXIST "%dir%\*.exe.local" del "%dir%\*.exe.local"
@IF "%appexe%"=="" GOTO ask_for_app_abi
@IF /I NOT "%appexe:~-4%"==".exe" set appexe=%appexe%.exe
@IF NOT EXIST "%dir%\%appexe%" echo Error: File not found.
@IF NOT EXIST "%dir%\%appexe%" pause
@IF NOT EXIST "%dir%\%appexe%" cls
@IF NOT EXIST "%dir%\%appexe%" GOTO askforappexe

:ask_for_app_abi
@set mesadll=x86
@if /I NOT %PROCESSOR_ARCHITECTURE%==AMD64 GOTO desktopgl
@set /p ABI=This is a 64-bit application (y=yes):
@if /I "%ABI%"=="y" set mesadll=x64
@echo.

:desktopgl
@set desktopgl=y
@set /p desktopgl=Do you want Desktop OpenGL drivers (y/n, defaults to yes):
@echo.
@IF /I "%desktopgl%"=="n" GOTO opengles
@IF EXIST "%dir%\opengl32.dll" echo Updating core desktop OpenGL deployment...
@IF EXIST "%dir%\opengl32.dll" del "%dir%\opengl32.dll"
@IF EXIST "%dir%\libgallium_wgl.dll" del "%dir%\libgallium_wgl.dll"
@IF EXIST "%dir%\libglapi.dll" del "%dir%\libglapi.dll"
@IF EXIST "%dir%\dxil.dll" del "%dir%\dxil.dll"
@mklink "%dir%\opengl32.dll" "%mesaloc%\%mesadll%\opengl32.dll"
@mklink "%dir%\libglapi.dll" "%mesaloc%\%mesadll%\libglapi.dll"
@IF EXIST "%mesaloc%\%mesadll%\libgallium_wgl.dll" mklink "%dir%\libgallium_wgl.dll" "%mesaloc%\%mesadll%\libgallium_wgl.dll"
@IF EXIST "%mesaloc%\%mesadll%\dxil.dll" mklink "%dir%\dxil.dll" "%mesaloc%\%mesadll%\dxil.dll"
@IF NOT "%dir%\%appexe%"=="%dir%\" echo dummy > "%dir%\%appexe%.local"
@echo.
@set swr=n
@if NOT %mesadll%==x64 GOTO opengles
@IF EXIST "%mesaloc%\%mesadll%\swr*.dll" set /p swr=Do you want swr driver - the new desktop OpenGL driver made by Intel (y/n):
@IF EXIST "%mesaloc%\%mesadll%\swr*.dll" echo.
@IF /I NOT "%swr%"=="y" GOTO opengles
@if NOT EXIST "%dir%\swrAVX.dll" if NOT EXIST "%dir%\swrAVX2.dll" if NOT EXIST "%dir%\swrSKX.dll" if NOT EXIST "%dir%\swrKNL.dll" GOTO deployswr
@echo Updating swr driver deployment...

:deployswr
@if EXIST "%dir%\swrAVX.dll" del "%dir%\swrAVX.dll"
@if EXIST "%dir%\swrAVX2.dll" del "%dir%\swrAVX2.dll"
@if EXIST "%dir%\swrSKX.dll" del "%dir%\swrSKX.dll"
@if EXIST "%dir%\swrKNL.dll" del "%dir%\swrKNL.dll"
@mklink "%dir%\swrAVX.dll" "%mesaloc%\x64\swrAVX.dll"
@mklink "%dir%\swrAVX2.dll" "%mesaloc%\x64\swrAVX2.dll"
@IF EXIST "%mesaloc%\x64\swrSKX.dll" mklink "%dir%\swrSKX.dll" "%mesaloc%\x64\swrSKX.dll"
@IF EXIST "%mesaloc%\x64\swrKNL.dll" mklink "%dir%\swrKNL.dll" "%mesaloc%\x64\swrKNL.dll"
@echo.

:opengles
@IF EXIST "%mesaloc%\%mesadll%\libglapi.dll" set /p opengles=Do you need OpenGL ES support (y/n):
@IF /I NOT "%opengles%"=="y" GOTO osmesa
@IF EXIST "%dir%\libglapi.dll" del "%dir%\libglapi.dll"
@if EXIST "%dir%\libGLESv1_CM.dll" del "%dir%\libGLESv1_CM.dll"
@if EXIST "%dir%\libGLESv2.dll" del "%dir%\libGLESv2.dll"
@mklink "%dir%\libglapi.dll" "%mesaloc%\%mesadll%\libglapi.dll"
@IF EXIST "%mesaloc%\%mesadll%\libGLESv1_CM.dll" mklink "%dir%\libGLESv1_CM.dll" "%mesaloc%\%mesadll%\libGLESv1_CM.dll"
@IF EXIST "%mesaloc%\%mesadll%\libGLESv2.dll" mklink "%dir%\libGLESv2.dll" "%mesaloc%\%mesadll%\libGLESv2.dll"
@echo.

:osmesa
@set osmesatype=n
@set /p osmesa=Do you need off-screen rendering (y/n):
@echo.
@if /I NOT "%osmesa%"=="y" GOTO graw
@IF EXIST "%dir%\osmesa.dll" echo Updating Mesa3D off-screen rendering interface deployment...
@IF EXIST "%dir%\osmesa.dll" del "%dir%\osmesa.dll"
@IF EXIST "%dir%\libglapi.dll" del "%dir%\libglapi.dll"
@IF EXIST "%mesaloc%\%mesadll%\osmesa.dll" mklink "%dir%\osmesa.dll" "%mesaloc%\%mesadll%\osmesa.dll"
@mklink "%dir%\libglapi.dll" "%mesaloc%\%mesadll%\libglapi.dll"
@echo.
@IF EXIST "%mesaloc%\%mesadll%\osmesa.dll" GOTO graw
@IF EXIST "%mesaloc%\%mesadll%\osmesa-gallium\osmesa.dll" IF EXIST "%mesaloc%\%mesadll%\osmesa-swrast\osmesa.dll" echo What version of osmesa off-screen rendering you want:
@IF EXIST "%mesaloc%\%mesadll%\osmesa-gallium\osmesa.dll" IF EXIST "%mesaloc%\%mesadll%\osmesa-swrast\osmesa.dll" echo 1. Gallium based (faster, but lacks certain features)
@IF EXIST "%mesaloc%\%mesadll%\osmesa-gallium\osmesa.dll" IF EXIST "%mesaloc%\%mesadll%\osmesa-swrast\osmesa.dll" echo 2. Swrast based (slower, but has unique OpenGL 2.1 features)
@IF EXIST "%mesaloc%\%mesadll%\osmesa-gallium\osmesa.dll" IF EXIST "%mesaloc%\%mesadll%\osmesa-swrast\osmesa.dll" set /p osmesatype=Enter choice:
@IF EXIST "%mesaloc%\%mesadll%\osmesa-gallium\osmesa.dll" IF EXIST "%mesaloc%\%mesadll%\osmesa-swrast\osmesa.dll" echo.
@if "%osmesatype%"=="1" mklink "%dir%\osmesa.dll" "%mesaloc%\%mesadll%\osmesa-gallium\osmesa.dll"
@if "%osmesatype%"=="2" mklink "%dir%\osmesa.dll" "%mesaloc%\%mesadll%\osmesa-swrast\osmesa.dll"
@if "%osmesatype%"=="1" echo.
@if "%osmesatype%"=="2" echo.

:graw
@set /p graw=Do you need graw library (y/n):
@echo.
@if /I NOT "%graw%"=="y" GOTO restart
@if NOT EXIST "%dir%\graw.dll" if NOT EXIST "%dir%\graw_null.dll" GOTO deploygraw
@echo Updating Mesa3D graw framework deployment...

:deploygraw
@if EXIST "%dir%\graw.dll" del "%dir%\graw.dll"
@if EXIST "%dir%\graw_null.dll" del "%dir%\graw_null.dll"
@IF EXIST "%dir%\libglapi.dll" del "%dir%\libglapi.dll"
@IF EXIST "%mesaloc%\%mesadll%\graw.dll" mklink "%dir%\graw.dll" "%mesaloc%\%mesadll%\graw.dll"
@IF EXIST "%mesaloc%\%mesadll%\graw_null.dll" mklink "%dir%\graw_null.dll" "%mesaloc%\%mesadll%\graw_null.dll"
@mklink "%dir%\libglapi.dll" "%mesaloc%\%mesadll%\libglapi.dll"
@echo.

:restart
@set /p rerun=More Mesa deployment? (y=yes):
@if /I "%rerun%"=="y" GOTO deploy
