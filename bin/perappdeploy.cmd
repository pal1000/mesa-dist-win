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
@echo This deployment utility allows for per-application deployments of Mesa3D without manual copy-paste 
@echo allowing updates to Mesa3D from a central location. It is intended for systems with working GPUs. 
@echo This helps a lot if you have many programs that you want to use Mesa3D with. 
@echo Some applications may still use the GPU if they are smart enough to only load OpenGL DLL from system directory.
@echo Use Federico Dossena's Mesainjector to workaround this case.
@echo Build instructions - https://fdossena.com/?p=mesa/injector_build.frag
@echo VMWare ThinApp capture: http://fdossena.com/mesa/MesaInjector_Capture.7z
@echo.
@pause
@set mesaloc=%~dp0

:deploy
@cls
@echo Mesa3D per-application deployment utility
@echo -----------------------------------------
@echo Please provide the path to the folder that contains the application launcher executable. It is recommended to
@echo copy-paste it from Windows Explorer using CTRL+V. The right click paste introduced in Windows 10 may lead to
@echo unexpected double paste. Also don't worry if path contains spaces, parantheses or other symbols, it is enclosed in
@echo quotes automatically so you don't need to add them manually.
@echo.
@set /p dir=Path to folder holding application executable:
@echo.
@set mesadll=x86
@if NOT %PROCESSOR_ARCHITECTURE%==AMD64 GOTO desktopgl

:ask_for_app_abi
@set /p ABI=This is a 64-bit application (y=yes):
@if /I "%ABI%"=="y" set mesadll=x64
@echo.

:desktopgl
@set nodesktopgl=n
@set /p nodesktopgl=I don't need Desktop OpenGL drivers (y/n, defaults to no):
@echo.
@IF /I "%nodesktopgl%"=="y" GOTO osmesa
@IF EXIST "%dir%\opengl32.dll" echo Updated softpipe and llvmpipe deployment.
@IF EXIST "%dir%\opengl32.dll" del "%dir%\opengl32.dll"
@mklink "%dir%\opengl32.dll" "%mesaloc%%mesadll%\opengl32.dll"
@echo.
@set swr=n
@if NOT %mesadll%==x64 GOTO osmesa
@set /p swr=Do you want swr driver - the new desktop OpenGL driver made by Intel (y/n):
@echo.
@IF /I NOT "%swr%"=="y" GOTO osmesa
@if EXIST "%dir%\swrAVX.dll" echo Updated swr driver deployment.
@if EXIST "%dir%\swrAVX.dll" GOTO deployswr
@if EXIST "%dir%\swrAVX2.dll" echo Updated swr driver deployment.
@if EXIST "%dir%\swrAVX2.dll" GOTO deployswr

:deployswr
@if EXIST "%dir%\swrAVX.dll" del "%dir%\swrAVX.dll"
@if EXIST "%dir%\swrAVX2.dll" del "%dir%\swrAVX2.dll"
@mklink "%dir%\swrAVX.dll" "%mesaloc%x64\swrAVX.dll"
@mklink "%dir%\swrAVX2.dll" "%mesaloc%x64\swrAVX2.dll"
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
@if "%osmesatype%"=="1" mklink "%dir%\osmesa.dll" "%mesaloc%%mesadll%\osmesa-gallium\osmesa.dll"
@if "%osmesatype%"=="2" mklink "%dir%\osmesa.dll" "%mesaloc%%mesadll%\osmesa-swrast\osmesa.dll"
@if "%osmesatype%"=="1" echo.
@if "%osmesatype%"=="2" echo.

:graw
@set /p graw=Do you need graw library (y/n):
@echo.
@if /I NOT "%graw%"=="y" GOTO restart
@if EXIST "%dir%\graw.dll" echo Updated Mesa3D graw framework deployment.
@if EXIST "%dir%\graw.dll" del "%dir%\graw.dll" 
@mklink "%dir%\graw.dll" "%mesaloc%%mesadll%\graw.dll"
@echo.

:restart
@set /p rerun=More Mesa deployment? (y=yes):
@if /I "%rerun%"=="y" GOTO deploy
