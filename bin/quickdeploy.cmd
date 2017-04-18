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


@echo Mesa3D quick deployment utility
@echo -------------------------------
@echo Quick deployment utility allows for fast Mesa deployment without manual copy-paste. This helps a lot if you have
@echo many programs that can use Mesa. Some applications still may use the GPU if they are smart enough to only load OpenGL
@echo DLL from system directory. Use Federico Dossena's Mesainjector to workaround this case.
@echo Build instructions - https://fdossena.com/?p=mesa/injector_build.frag
@echo VMWare ThinApp capture: http://fdossena.com/mesa/MesaInjector_Capture.7z
@echo.
@pause

:deploy
@cls
@echo Mesa3D quick deployment utility
@echo -------------------------------
@echo Please provide the path to the folder that contains the application launcher executable. It is recommended to
@echo copy-paste it from Windows Explorer using CTRL+V. The right click paste introduced in Windows 10 may lead to
@echo unexpected double paste. Also don't worry if path contains spaces, parantheses or other symbols, it is enclosed in
@echo quotes automatically so you don't need to add them manually.
@echo.
@set /p dir=Path to folder holding application executable:
@echo.
@set mesadll=x86
@if %PROCESSOR_ARCHITECTURE%==AMD64 GOTO ask_for_app_abi
@if NOT %PROCESSOR_ARCHITECTURE%==AMD64 GOTO finish

:ask_for_app_abi
@set /p ABI=This is a 64-bit application (y=yes):
@if /I "%ABI%"=="y" set mesadll=x64
@echo.

:finish
@set mesaloc=%~dp0
@mklink "%dir%\opengl32.dll" "%mesaloc%%mesadll%\opengl32.dll"
@echo.
@set s3tc=n
@set /p s3tc=Do you need S3TC (y/n):
@echo.
@if /I "%s3tc%"=="y" mklink "%dir%\dxtn.dll" "%mesaloc%%mesadll%\dxtn.dll"
@if /I "%s3tc%"=="y" echo.
@set osmesatype=n
@set /p osmesa=Do you need off-screen rendering (y/n):
@echo.
@if /I "%osmesa%"=="y" echo What version of osmesa off-screen rendering you want:
@if /I "%osmesa%"=="y" echo 1. Gallium based (faster, but lacks certain features);
@if /I "%osmesa%"=="y" echo 2. Swrast based (slower, but has unique OpenGL 2.1 features);
@if /I "%osmesa%"=="y" set /p osmesatype=Enter choice:
@if /I "%osmesa%"=="y" echo.
@if "%osmesatype%"=="1" mklink "%dir%\osmesa.dll" "%mesaloc%%mesadll%\osmesa-gallium.dll"
@if "%osmesatype%"=="2" mklink "%dir%\osmesa.dll" "%mesaloc%%mesadll%\osmesa-swrast.dll"
@if "%osmesatype%"=="1" echo.
@if "%osmesatype%"=="2" echo.
@set /p graw=Do you need graw library (y/n):
@echo.
@if /I "%graw%"=="y" mklink "%dir%\graw.dll" "%mesaloc%%mesadll%\graw.dll"
@echo.
@set /p rerun=More Mesa deployment? (y=yes):
@if /I "%rerun%"=="y" GOTO deploy
