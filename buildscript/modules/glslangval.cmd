@set glslangval=1
@IF %toolchain%==msvc IF NOT EXIST "%VK_SDK_PATH%\Bin\glslangValidator.exe" IF NOT EXIST "%VULKAN_SDK%\Bin\glslangValidator.exe" set glslangval=0
@IF NOT %toolchain%==msvc IF NOT EXIST "%msysloc%\%LMSYSTEM%\bin\glslangValidator.exe" set glslangval=0