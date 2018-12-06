@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
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
@echo Use Federico Dossena's Mesainjector to workaround this case.
@echo Build instructions - https://fdossena.com/?p=mesa/injector_build.frag
@echo VMWare ThinApp capture: http://fdossena.com/mesa/MesaInjector_Capture.7z
@echo Mesainjector does not work with Windows 10 Version 1803 and newer.
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
@IF "%appexe%"=="" echo.
@IF "%appexe%"=="" GOTO ask_for_app_abi
@IF /I NOT "%appexe:~-4%"==".exe" set appexe=%appexe%.exe
@IF NOT EXIST "%dir%\%appexe%" echo.
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
@rem Add Meson subprojects
@if EXIST "%dir%\z.dll" del "%dir%\z.dll"
@if EXIST "%dir%\expat-1.dll" del "%dir%\expat-1.dll"
@IF EXIST "%mesaloc%\%mesadll%\z.dll" mklink "%dir%\z.dll" "%mesaloc%\%mesadll%\z.dll"
@IF EXIST "%mesaloc%\%mesadll%\expat-1.dll" mklink "%dir%\expat-1.dll" "%mesaloc%\%mesadll%\expat-1.dll"
@echo.

@set desktopgl=y
@set /p desktopgl=Do you want Desktop OpenGL drivers (y/n, defaults to yes):
@echo.
@IF /I "%desktopgl%"=="n" GOTO opengles
@IF EXIST "%dir%\opengl32.dll" echo Updated softpipe and llvmpipe deployment.
@IF EXIST "%dir%\opengl32.dll" del "%dir%\opengl32.dll"
@IF EXIST "%dir%\libglapi.dll" del "%dir%\libglapi.dll"
@mklink "%dir%\opengl32.dll" "%mesaloc%\%mesadll%\opengl32.dll"
@IF EXIST "%mesaloc%\%mesadll%\libglapi.dll" mklink "%dir%\libglapi.dll" "%mesaloc%\%mesadll%\libglapi.dll"
@IF NOT "%dir%\%appexe%"=="%dir%\" echo dummy > "%dir%\%appexe%.local"
@echo.
@set swr=n
@if NOT %mesadll%==x64 GOTO opengles
@set /p swr=Do you want swr driver - the new desktop OpenGL driver made by Intel (y/n):
@echo.
@IF /I NOT "%swr%"=="y" GOTO opengles
@if EXIST "%dir%\swrAVX.dll" echo Updated swr driver deployment.
@if EXIST "%dir%\swrAVX.dll" GOTO deployswr
@if EXIST "%dir%\swrAVX2.dll" echo Updated swr driver deployment.
@if EXIST "%dir%\swrAVX2.dll" GOTO deployswr

:deployswr
@if EXIST "%dir%\swrAVX.dll" del "%dir%\swrAVX.dll"
@if EXIST "%dir%\swrAVX2.dll" del "%dir%\swrAVX2.dll"
@mklink "%dir%\swrAVX.dll" "%mesaloc%\x64\swrAVX.dll"
@mklink "%dir%\swrAVX2.dll" "%mesaloc%\x64\swrAVX2.dll"
@echo.

:opengles
@set /p opengles=Do you need OpenGL ES support (y/n):
@IF /I NOT "%opengles%"=="y" GOTO osmesa
@if EXIST "%dir%\libGLESv1_CM.dll" del "%dir%\libGLESv1_CM.dll"
@if EXIST "%dir%\libGLESv2.dll" del "%dir%\libGLESv2.dll"
@IF EXIST "%mesaloc%\%mesadll%\libGLESv1_CM.dll" mklink "%dir%\libGLESv1_CM.dll" "%mesaloc%\%mesadll%\libGLESv1_CM.dll"
@IF EXIST "%mesaloc%\%mesadll%\libGLESv2.dll" mklink "%dir%\libGLESv2.dll" "%mesaloc%\%mesadll%\libGLESv2.dll"
@echo.

:osmesa
@set osmesatype=n
@set /p osmesa=Do you need off-screen rendering (y/n):
@echo.
@if /I NOT "%osmesa%"=="y" GOTO graw
@IF EXIST "%dir%\osmesa.dll" echo Updated Mesa3D off-screen rendering interface deployment.
@IF EXIST "%dir%\osmesa.dll" del "%dir%\osmesa.dll"
@echo What version of osmesa off-screen rendering you want:
@echo 1. Gallium based (faster, but lacks certain features);
@echo 2. Swrast based (slower, but has unique OpenGL 2.1 features);
@set /p osmesatype=Enter choice:
@echo.
@if "%osmesatype%"=="1" mklink "%dir%\osmesa.dll" "%mesaloc%\%mesadll%\osmesa-gallium\osmesa.dll"
@if "%osmesatype%"=="2" mklink "%dir%\osmesa.dll" "%mesaloc%\%mesadll%\osmesa-swrast\osmesa.dll"
@if "%osmesatype%"=="1" echo.
@if "%osmesatype%"=="2" echo.

:graw
@set /p graw=Do you need graw library (y/n):
@echo.
@if /I NOT "%graw%"=="y" GOTO restart
@if EXIST "%dir%\graw.dll" echo Updated Mesa3D graw framework deployment.
@if EXIST "%dir%\graw.dll" del "%dir%\graw.dll" 
@mklink "%dir%\graw.dll" "%mesaloc%\%mesadll%\graw.dll"
@echo.

:restart
@set /p rerun=More Mesa deployment? (y=yes):
@if /I "%rerun%"=="y" GOTO deploy
