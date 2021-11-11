@echo off
@cd /d "%~dp0"
@set "ERRORLEVEL="
@CMD /C EXIT 0
@"%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system" >nul 2>&1
@if NOT "%ERRORLEVEL%"=="0" (
@IF "%*"=="" powershell -Command Start-Process """%0""" -Verb runAs 2>nul
@IF NOT "%*"=="" powershell -Command Start-Process """%0""" """%*""" -Verb runAs 2>nul
@exit
)
:--------------------------------------
@TITLE Hotfix for libvulkan-1.dll missing error
@echo This tool is intended to troubleshoot an error complaining about libvulkan-1.dll being missing which
@echo can affect any program using a Mesa3D build that contains zink driver even if you don't use zink.
@echo This issue only manifests if Mesa3D is built against MSYS2 MinGW-W64 vulkan-devel SDK.
@echo Some Mesa MinGW releases containing zink driver are made with LunarG Vulkan SDK while others are made
@echo with MSYS2 MinGW-W64 vulkan-devel SDK, depending on which is more up-to-date at release time.
@echo As for why this issue manifests even if you don't use zink, learn more here:
@echo https://gitlab.freedesktop.org/mesa/mesa/-/issues/3855
@echo.
@echo To solve this problem this tool relies on LunarG build of KhronosGroup Vulkan loader
@echo and implements a compatibility hotfix with it when MSYS2 MinGW-W64 vulkan-devel SDK is involved.
@echo LunarG build of KhronosGroup Vulkan loader is avaible as both standalone download and
@echo as a component of Vulkan graphics drivers.
@echo If the compatibility hotfix is in place, this tool offers the option to remove it.
@echo.
@IF NOT EXIST "%windir%\system32\vulkan-1.dll" (
@echo FATAL ERROR: KhronosGroup Vulkan loader is missing. Please download and install latest Vulkan runtime from
@echo https://vulkan.lunarg.com/
@echo.
@IF /I NOT "%1"=="auto" pause
@exit
)

@IF EXIST "%windir%\system32\libvulkan-1.dll" IF /I NOT "%1"=="auto" set /p remhotfix=Remove hotfix - y/n^:
@IF NOT EXIST "%windir%\system32\libvulkan-1.dll" IF /I NOT "%1"=="auto" set /p applyhotfix=Apply hotfix - y/n^:
@IF EXIST "%windir%\system32\libvulkan-1.dll" IF /I "%1"=="auto" echo Removing hotfix...
@IF EXIST "%windir%\system32\libvulkan-1.dll" IF /I "%1"=="auto" set remhotfix=y
@IF NOT EXIST "%windir%\system32\libvulkan-1.dll" IF /I "%1"=="auto" echo Applying hotfix...
@IF NOT EXIST "%windir%\system32\libvulkan-1.dll" IF /I "%1"=="auto" set applyhotfix=y
@echo.
@IF /I "%remhotfix%"=="y" del "%windir%\system32\libvulkan-1.dll"
@IF /I "%remhotfix%"=="y" IF EXIST "%windir%\syswow64\libvulkan-1.dll" del "%windir%\syswow64\libvulkan-1.dll"
@IF /I "%applyhotfix%"=="y" mklink "%windir%\system32\libvulkan-1.dll" "%windir%\system32\vulkan-1.dll"
@IF /I "%applyhotfix%"=="y" IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF NOT EXIST "%windir%\syswow64\libvulkan-1.dll" mklink "%windir%\syswow64\libvulkan-1.dll" "%windir%\syswow64\vulkan-1.dll"
@echo.
@IF /I NOT "%1"=="auto" pause
