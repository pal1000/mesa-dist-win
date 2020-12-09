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
@TITLE Compatibility hotfix with LunarG build of KhronosGroup Vulkan loader for programs buiilt with MSYS2 MinGW-W64
@IF NOT EXIST "%windir%\system32\vulkan-1.dll" (
@echo FATAL ERROR: KhronosGroup Vulkan loader is missing. Download latest Vulkan runtime from https://vulkan.lunarg.com/
@echo.
@pause
@exit
)
@echo This tool implements a compatibility hotfix with LunarG build of KhronosGroup Vulkan loader for programs
@echo buiilt with MSYS2 MinGW-W64. LunarG build of KhronosGroup Vulkan loader is avaible as both
@echo standalone download and as a component of Vulkan graphics drivers.
@echo If the compatibility hotfix is in place, this tool offers the option to remove it.
@echo.
@IF EXIST "%windir%\system32\libvulkan-1.dll" set /p remhotfix=Remove hotfix - y/n^:
@IF NOT EXIST "%windir%\system32\libvulkan-1.dll" set /p applyhotfix=Apply hotfix - y/n^:
@echo.
@IF /I "%remhotfix%"=="y" del "%windir%\system32\libvulkan-1.dll"
@IF /I "%remhotfix%"=="y" IF EXIST "%windir%\syswow64\libvulkan-1.dll" del "%windir%\syswow64\libvulkan-1.dll"
@IF /I "%applyhotfix%"=="y" mklink "%windir%\system32\libvulkan-1.dll" "%windir%\system32\vulkan-1.dll"
@IF /I "%applyhotfix%"=="y" IF NOT EXIST "%windir%\syswow64\libvulkan-1.dll" mklink "%windir%\syswow64\libvulkan-1.dll" "%windir%\syswow64\vulkan-1.dll"
@echo.
@pause
