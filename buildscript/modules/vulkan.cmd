@setlocal
@set vksdkstd=1
@set vksdkselect=0
@IF NOT EXIST "%VK_SDK_PATH%" IF NOT EXIST "%VULKAN_SDK%" set vksdkstd=0

:selectvksdk
@IF %vksdkstd% EQU 1 echo Select Vulkan SDK for zink driver
@IF %vksdkstd% EQU 1 echo 1. LunarG Vulkan SDK
@IF %vksdkstd% EQU 1 echo 2. MSYS2 MinGW-W64 vulkan-devel
@IF %vksdkstd% EQU 1 set /p vksdkselect=Enter choice:
@IF %vksdkstd% EQU 1 echo.
@IF %vksdkstd% EQU 1 IF NOT "%vksdkselect%"=="1" IF NOT "%vksdkselect%"=="2" (
@echo Invalid entry.
@echo.
@GOTO selectvksdk
)
@IF %vksdkstd% EQU 0 set vksdkselect=2
@IF "%vksdkselect%"=="1" (
@IF EXIST %msysloc%\%LMSYSTEM%\lib\libvulkan.dll.a del %msysloc%\%LMSYSTEM%\lib\libvulkan.dll.a
@IF EXIST %msysloc%\%LMSYSTEM%\lib\pkgconfig\vulkan.pc del %msysloc%\%LMSYSTEM%\lib\pkgconfig\vulkan.pc
@IF EXIST %msysloc%\%LMSYSTEM%\bin\libvulkan-1.dll del %msysloc%\%LMSYSTEM%\bin\libvulkan-1.dll
)
@IF "%vksdkselect%"=="2" (
@set "VULKAN_SDK="
@set "VK_SDK_PATH="
@%msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -S ${MINGW_PACKAGE_PREFIX}-vulkan-loader --noconfirm"
@echo.
)
@endlocal&set "VK_SDK_PATH=%VK_SDK_PATH%"&set "VULKAN_SDK=%VULKAN_SDK%"