@echo Mesa3D quick deployment utility
@echo -------------------------------
@echo Quick deployment utility allows for fast Mesa deployment without manual copy-paste. This helps a lot if you have
@echo many programs that can use Mesa. Some applications still may use the GPU if they are smart enough to only load OpenGL
@echo. DLL from system directory. Mesa and the applications that need it must be on same partition.
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
mklink /H "%dir%\opengl32.dll" %mesadll%\opengl32.dll
@echo.
@set s3tc=n
@set /p s3tc=Do you need S3TC (y/n):
@echo.
@if /I "%s3tc%"=="y" mklink /H "%dir%\dxtn.dll" %mesadll%\dxtn.dll
@if /I "%s3tc%"=="y" echo.
@set osmesatype=n
@set /p osmesa=Do you need off-screen rendering (y/n):
@echo.
@if /I "%osmesa%"=="y" echo What version of osmesa off-screen rendering you want:
@if /I "%osmesa%"=="y" echo 1. Gallium based (faster, but lacks certain features);
@if /I "%osmesa%"=="y" echo 2. Swrast based (slower, but has unique OpenGL 2.1 features);
@if /I "%osmesa%"=="y" set /p osmesatype=Enter choice:
@if /I "%osmesa%"=="y" @echo.
@if "%osmesatype%"=="1" mklink /H %dir%\osmesa.dll" %mesadll%\osmesa-gallium.dll
@if "%osmesatype%"=="2" mklink /H "%dir%\osmesa.dll" %mesadll%\osmesa-swrast.dll
@if "%osmesatype%"=="1" echo.
@if "%osmesatype%"=="2" echo.
@set /p graw=Do you need graw library (y/n):
@echo.
@if /I "%graw%"=="y" mklink /H "%dir%\graw.dll" %mesadll%\graw.dll
@echo.
@set /p rerun=More Mesa deployment? (y=yes):
@if /I "%rerun%"=="y" GOTO deploy
