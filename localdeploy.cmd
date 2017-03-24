@echo Mesa3D local deployment utility
@echo -------------------------------
@echo By default Mesa 3D for Windows is installed system wide. But under certain circumstances the GPU(s) might get used 
@echo even if it's not intended:
@echo - the GPU suports the required Core profile demanded by the application but lacks certain extensions;
@echo - the application that needs mesa due to GPU limitations has issues on systems with multiple OpenGL drivers
@echo resulting in selection of a wrong driver. Local deployment of mesa solves this problem by forcing itself to be used
@echo by the aplication.   
@echo.
@pause

:deploy
@cls
@echo Mesa3D local deployment utility
@echo -------------------------------
@echo Please provide the path to the folder that contains the application launcher executable, that needs local deployment
@echo of Mesa. It is recommended to copy-paste it from Windows Explorer using CTRL+V. The right click paste introduced in 
@echo Windows 10 may lead to unexpected double paste. Also don't worry if path contains spaces, it is enclosed in quotes
automatically so you don't need to add them.
@echo.  
@set /p dir=Path to folder holding application executable:
@echo.
@set mesadll=system32
@if %PROCESSOR_ARCHITECTURE%==AMD64 GOTO ask_for_app_abi
@if NOT %PROCESSOR_ARCHITECTURE%==AMD64 GOTO finish

:ask_for_app_abi
@set mesadll=syswow64
@set /p ABI=This is a 64-bit application (y=yes):
@if /I %ABI%==y @set mesadll=system32
@echo.

:finish
@cd /d "%dir%"
@mklink opengl32.dll %windir%\%mesadll%\opengl32sw.dll
@echo.
@set /p rerun=More local deployment? (y=yes):
@if /I %rerun%==y GOTO deploy
