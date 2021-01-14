@echo off
@cd /d "%~dp0"
@set "ERRORLEVEL="
@CMD /C EXIT 0
@"%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system" >nul 2>&1
@if NOT "%ERRORLEVEL%"=="0" (
@powershell -Command Start-Process ""%0"" -Verb runAs 2>nul
@exit
)
:--------------------------------------
@TITLE Hotfix for libvulkan-1.dll missing error
@echo This tool is intended to troubleshoot an error complaining about libvulkan-1.dll being missing
@echo which affects any program using a Mesa3D build that contains zink driver even if you don't use zink.
@echo Learn more: https://gitlab.freedesktop.org/mesa/mesa/-/issues/3855
@echo.
@echo To solve this problem this tool relies on LunarG build of KhronosGroup Vulkan loader
@echo and implements a compatibility hotfix with it when MSYS2 MinGW-W64 is involved.
@echo LunarG build of KhronosGroup Vulkan loader is avaible as both standalone download and
@echo as a component of Vulkan graphics drivers.
@echo If the compatibility hotfix is in place, this tool offers the option to remove it.
@echo.
@IF NOT EXIST "%windir%\system32\vulkan-1.dll" (
@echo FATAL ERROR: KhronosGroup Vulkan loader is missing. Please download and install latest Vulkan runtime from
@echo https://vulkan.lunarg.com/
@echo.
@pause
@exit
)

@IF EXIST "%windir%\system32\libvulkan-1.dll" set /p remhotfix=Remove hotfix - y/n^:
@IF NOT EXIST "%windir%\system32\libvulkan-1.dll" set /p applyhotfix=Apply hotfix - y/n^:
@echo.
@IF /I "%remhotfix%"=="y" del "%windir%\system32\libvulkan-1.dll"
@IF /I "%remhotfix%"=="y" IF EXIST "%windir%\syswow64\libvulkan-1.dll" del "%windir%\syswow64\libvulkan-1.dll"
@IF /I "%applyhotfix%"=="y" mklink "%windir%\system32\libvulkan-1.dll" "%windir%\system32\vulkan-1.dll"
@IF /I "%applyhotfix%"=="y" IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF NOT EXIST "%windir%\syswow64\libvulkan-1.dll" mklink "%windir%\syswow64\libvulkan-1.dll" "%windir%\syswow64\vulkan-1.dll"
@echo.
@pause
