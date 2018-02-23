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
@set mesaloc=%~dp0

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
@if NOT %PROCESSOR_ARCHITECTURE%==AMD64 GOTO desktopgl

:ask_for_app_abi
@set /p ABI=This is a 64-bit application (y=yes):
@if /I "%ABI%"=="y" set mesadll=x64
@echo.

:desktopgl
@IF NOT EXIST "%dir%\opengl32.dll" mklink "%dir%\opengl32.dll" "%mesaloc%%mesadll%\opengl32.dll"
@if NOT %mesadll%==x64 GOTO s3tc
@if NOT EXIST "%dir%\swrAVX.dll" mklink "%dir%\swrAVX.dll" "%mesaloc%x64\swrAVX.dll"
@if NOT EXIST "%dir%\swrAVX2.dll" mklink "%dir%\swrAVX2.dll" "%mesaloc%x64\swrAVX2.dll"
@echo.

:s3tc
@set s3tc=n
@IF EXIST "%mesaloc%%mesadll%\dxtn.dll" set /p s3tc=Do you need S3TC (y/n):
@echo.
@if /I NOT "%s3tc%"=="y" GOTO osmesa
@if NOT EXIST "%dir%\dxtn.dll" mklink "%dir%\dxtn.dll" "%mesaloc%%mesadll%\dxtn.dll"
echo.

:osmesa
@set osmesatype=n
@set /p osmesa=Do you need off-screen rendering (y/n):
@echo.
@if /I NOT "%osmesa%"=="y" GOTO graw
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
@if NOT EXIST "%dir%\graw.dll" mklink "%dir%\graw.dll" "%mesaloc%%mesadll%\graw.dll"
@echo.

:restart
@set /p rerun=More Mesa deployment? (y=yes):
@if /I "%rerun%"=="y" GOTO deploy
