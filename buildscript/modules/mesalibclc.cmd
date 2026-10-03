@set mesaliibclcver=22.1.8.3
@call "%devroot%\%projectname%\bin\modules\prompt.cmd" buildclc "Install Mesa libclc fork (y/n):"
@if /I NOT "%buildclc%"=="y" GOTO finishmesaclc
@if NOT EXIST "%llvminstloc:~0,-6%\" MD "%llvminstloc:~0,-6%"
@if NOT EXIST "%llvminstloc%\" MD "%llvminstloc%"
@if NOT EXIST "%llvminstloc%\clc\" MD "%llvminstloc%\clc"
@if NOT EXIST "%llvminstloc%\clc\share\" MD "%llvminstloc%\clc\share"
@if NOT EXIST "%llvminstloc%\clc\share\pkgconfig\" MD "%llvminstloc%\clc\share\pkgconfig"
@if NOT EXIST "%llvminstloc%\clc\share\mesa-clc\" MD "%llvminstloc%\clc\share\mesa-clc"

@IF NOT EXIST "%USERPROFILE%\Downloads\mesa-libclc.pc.in" IF EXIST "%msysloc%\usr\bin\curl.exe" %runmsys% curl -L --retry 5 --retry-delay 2 --max-time 30 --retry-all-errors https://gitlab.freedesktop.org/api/v4/projects/27606/packages/generic/mesa-libclc/%mesaliibclcver%/mesa-libclc.pc.in -o "%USERPROFILE%\Downloads\mesa-libclc.pc.in"
@IF EXIST "%USERPROFILE%\Downloads\mesa-libclc.pc.in" (
@IF EXIST "%llvminstloc%\clc\share\pkgconfig\mesa-libclc.pc.in" del "%llvminstloc%\clc\share\pkgconfig\mesa-libclc.pc.in"
@MOVE "%USERPROFILE%\Downloads\mesa-libclc.pc.in" "%llvminstloc%\clc\share\pkgconfig"
)

@IF NOT EXIST "%USERPROFILE%\Downloads\spirv64-mesa3d-.spv" IF EXIST "%msysloc%\usr\bin\curl.exe" %runmsys% curl -L --retry 5 --retry-delay 2 --max-time 30 --retry-all-errors https://gitlab.freedesktop.org/api/v4/projects/27606/packages/generic/mesa-libclc/%mesaliibclcver%/spirv64-mesa3d-.spv -o "%USERPROFILE%\Downloads\spirv64-mesa3d-.spv"
@IF EXIST "%USERPROFILE%\Downloads\spirv64-mesa3d-.spv" (
@IF EXIST "%llvminstloc%\clc\share\mesa-clc\spirv64-mesa3d-.spv" del "%llvminstloc%\clc\share\mesa-clc\spirv64-mesa3d-.spv"
@MOVE "%USERPROFILE%\Downloads\spirv64-mesa3d-.spv" "%llvminstloc%\clc\share\mesa-clc"
)

@IF NOT EXIST "%USERPROFILE%\Downloads\spirv-mesa3d-.spv" IF EXIST "%msysloc%\usr\bin\curl.exe" %runmsys% curl -L --retry 5 --retry-delay 2 --max-time 30 --retry-all-errors https://gitlab.freedesktop.org/api/v4/projects/27606/packages/generic/mesa-libclc/%mesaliibclcver%/spirv-mesa3d-.spv -o "%USERPROFILE%\Downloads\spirv-mesa3d-.spv"
@IF EXIST "%USERPROFILE%\Downloads\spirv-mesa3d-.spv" (
@IF EXIST "%llvminstloc%\clc\share\mesa-clc\spirv-mesa3d-.spv" del "%llvminstloc%\clc\share\mesa-clc\spirv-mesa3d-.spv"
@MOVE "%USERPROFILE%\Downloads\spirv-mesa3d-.spv" "%llvminstloc%\clc\share\mesa-clc"
)

@echo libexecdir=${pcfiledir}/../mesa-clc >"%llvminstloc%\clc\share\pkgconfig\mesa-libclc.pc"
@for /f skip^=1^ delims^= %%a IN ('type "%llvminstloc%\clc\share\pkgconfig\mesa-libclc.pc.in"') DO @echo %%a >>"%llvminstloc%\clc\share\pkgconfig\mesa-libclc.pc"
@echo.

:finishmesaclc
@rem Reset environment after Mesa-libclc build.
@cd "%devroot%\"
