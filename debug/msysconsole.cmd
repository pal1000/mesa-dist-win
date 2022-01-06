@cd "%~dp0"
@cd ..\..\
@for %%a in ("%cd%") do @set devroot=%%~sa
@set projectname=mesa-dist-win
@call %devroot%\%projectname%\buildscript\modules\msys.cmd
@call %devroot%\%projectname%\buildscript\modules\msysupdate.cmd
@call %devroot%\%projectname%\buildscript\modules\git.cmd
@IF %msysstate% EQU 0 (
@echo Fatal error: MSYS2 is missing.
@pause
@exit
)

:selectshell
@echo Select shell:
@echo 1. MSYS2 (default)
@echo 2. MINGW32
@echo 3. MINGW64
@echo 4. CLANG32
@echo 5. CLANG64
@echo 6. UCRT64
@set /p shell=Enter choice:
@echo.
@if "%shell%"=="" set shell=1
@IF "%shell%"=="1" set "MSYSTEM="
@IF "%shell%"=="2" set MSYSTEM=MINGW32
@IF "%shell%"=="3" set MSYSTEM=MINGW64
@IF "%shell%"=="4" set MSYSTEM=CLANG32
@IF "%shell%"=="4" %msysloc%\usr\bin\bash --login -c "$(/usr/bin/cygpath -m ${devroot})/${projectname}/buildscript/modules/clang32.sh"
@IF "%shell%"=="5" set MSYSTEM=CLANG64
@IF "%shell%"=="6" set MSYSTEM=UCRT64
@IF NOT "%shell%"=="1" IF NOT "%shell%"=="2" IF NOT "%shell%"=="3" IF NOT "%shell%"=="4" IF NOT "%shell%"=="5" IF NOT "%shell%"=="6" GOTO selectshell

:command
@set msyscmd=
@set /p msyscmd=Enter MSYS2 command:
@echo.
@set msyscmd=%msyscmd:"=%
@set msyscmd=%msyscmd:\=/%
@IF /I "%msyscmd%"=="exit" exit
@IF /I "%msyscmd%"=="clearcache" set msyscmd=pacman -Sc --noconfirm
@IF /I "%msyscmd%"=="cleancache" set msyscmd=pacman -Sc --noconfirm
@IF /I "%msyscmd%"=="shell" GOTO selectshell
@IF /I "%msyscmd%"=="setup" IF %shell% EQU 1 set msyscmd=pacman -S flex bison patch tar mingw-w64-i686-{python-mako,meson,pkgconf,vulkan-devel,libelf,zstd,gdb,llvm,gcc} mingw-w64-x86_64-{python-mako,meson,pkgconf,vulkan-devel,libelf,zstd,gdb,llvm,gcc} --needed
@IF /I "%msyscmd%"=="setup" IF %shell% GTR 3 IF %shell% LSS 6 set msyscmd=pacman -S flex bison patch tar ${MINGW_PACKAGE_PREFIX}-{python-mako,meson,pkgconf,vulkan-devel,libelf,zstd,gdb,clang} --needed
@IF /I "%msyscmd%"=="setup" set msyscmd=pacman -S flex bison patch tar ${MINGW_PACKAGE_PREFIX}-{python-mako,meson,pkgconf,vulkan-devel,libelf,zstd,gdb,llvm,gcc} --needed
@IF %gitstate% GTR 0 %msysloc%\usr\bin\bash --login -c "PATH=${PATH}:${gitloc};%msyscmd%"
@IF %gitstate% EQU 0 %msysloc%\usr\bin\bash --login -c "%msyscmd%"
@echo.
@GOTO command