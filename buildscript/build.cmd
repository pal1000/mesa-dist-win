@set TITLE=Building Mesa3D
@TITLE %TITLE%

@rem Determine Mesa3D build environment root folder.
@cd /d "%~dp0"
@cd ..\..\
@set CD=
@set devroot=%CD%
@IF %devroot:~0,1%%devroot:~-1%=="" set devroot=%devroot:~1,-1%
@IF "%devroot:~-1%"=="\" set devroot=%devroot:~0,-1%

@set projectname=mesa-dist-win
@set "ERRORLEVEL="

@rem Create folder to store generated resource files, MSYS2 shell scripts, Python virtual environment and Powershell temporary downloads.
@IF NOT EXIST "%devroot%\%projectname%\buildscript\assets\" md "%devroot%\%projectname%\buildscript\assets"

@rem Init bot mode
@if NOT EXIST "%devroot%\%projectname%\buildscript\bots\" md "%devroot%\%projectname%\buildscript\bots"
@for /f tokens^=^* %%a IN ("%date%%time%") DO @set bottimestamp=%%a
@set bottimestamp=%bottimestamp: =%
@set bottimestamp=%bottimestamp:/=%
@set bottimestamp=%bottimestamp::=%
@set bottimestamp=%bottimestamp:.=%

@rem Command line option to disable out of tree patches for Mesa3D
@IF "%1"=="disableootpatch" set disableootpatch=1
@IF "%disableootpatch%"=="1" set TITLE=%TITLE% ^(out of tree patches disabled^)
@IF "%disableootpatch%"=="1" TITLE %TITLE%

@rem Default bot mode disabled
@IF NOT defined botmode set botmode=0
@if %botmode% EQU 0 echo @set botmode=^1>"%devroot%\%projectname%\buildscript\bots\bot-%bottimestamp%.cmd"

@rem Analyze environment. Get each dependency status: 0=missing, 1=standby/load manually in PATH, 2=cannot be unloaded.
@rem Not all dependencies can have all these states.

@rem Version control
@call "%devroot%\%projectname%\buildscript\modules\git.cmd"

@rem Look for MSYS2 build environment
@call "%devroot%\%projectname%\buildscript\modules\msys.cmd"

@rem Search for compiler toolchain. Hard fail if none found
@call "%devroot%\%projectname%\buildscript\modules\toolchain.cmd"

@rem Locate Windows SDK even when building with MinGW
@call "%devroot%\%projectname%\buildscript\modules\winsdkloc.cmd"

@rem MSVC: Select C/C++ toolset
@IF %toolchain%==msvc call "%devroot%\%projectname%\buildscript\modules\msvcpp.cmd"

@rem Verify if out of tree patches can be applied.
@call "%devroot%\%projectname%\buildscript\modules\patching.cmd"

@rem Select target architecture
@call "%devroot%\%projectname%\buildscript\modules\abi.cmd"

@rem MSVC: Select between legacy and current LLVM version
@IF %toolchain%==msvc call "%devroot%\%projectname%\buildscript\modules\selectllvm.cmd"

@rem If using MSVC search for Python. State tracking is pointless as it is loaded once and we are done. Hard fail if missing.
@IF %toolchain%==msvc call "%devroot%\%projectname%\buildscript\modules\discoverpython.cmd" 3 9

@rem If using MSVC search for Python packages. Install missing packages automatically. Ask to do an update to all packages.
@IF %toolchain%==msvc call "%devroot%\%projectname%\buildscript\modules\pythonpackages.cmd"

@rem Build throttle.
@call "%devroot%\%projectname%\buildscript\modules\throttle.cmd"

@rem If using MSVC check for additional dependencies: cmake, ninja and nuget.
@IF %toolchain%==msvc call "%devroot%\%projectname%\buildscript\modules\cmake.cmd"
@IF %toolchain%==msvc call "%devroot%\%projectname%\buildscript\modules\ninja.cmd"
@IF %toolchain%==msvc call "%devroot%\%projectname%\buildscript\modules\nuget.cmd"

@rem If using MSVC do LLVM build.
@IF %toolchain%==msvc call "%devroot%\%projectname%\buildscript\modules\llvm.cmd"

@rem Offer option to build with clang
@call "%devroot%\%projectname%\buildscript\modules\clang.cmd"

@rem Get Meson build location
@call "%devroot%\%projectname%\buildscript\modules\locatemeson.cmd"

@rem MSVC: Lookup/build a pkg-config implementation
@IF %toolchain%==msvc call "%devroot%\%projectname%\buildscript\modules\pkg-config.cmd"

@rem If using MSVC do CLonD3D12 build
@IF %toolchain%==msvc call "%devroot%\%projectname%\buildscript\modules\clon12.cmd"

@rem If using MSVC do SPIR-V Tools build
@IF %toolchain%==msvc call "%devroot%\%projectname%\buildscript\modules\spirv.cmd"

@rem If using MSVC do VA-API library build
@IF %toolchain%==msvc call "%devroot%\%projectname%\buildscript\modules\libva.cmd"

@rem Offer to update MSYS2 packages even if using MSVC to get MSYS2 flex-bison update coverage
@call "%devroot%\%projectname%\buildscript\modules\msysupdate.cmd"

@rem Install MSYS2 necessary packages. Install MSYS packages even if using MSVC for alternative flex and bison support
@IF EXIST "%msysloc%" call "%devroot%\%projectname%\buildscript\modules\msyspackages.cmd"
@IF %toolchain%==msvc call "%devroot%\%projectname%\buildscript\modules\winflexbison.cmd"

@rem Check glslangValidator availability
@call "%devroot%\%projectname%\buildscript\modules\glslangval.cmd"

@rem Build zstd compressor
@IF %toolchain%==msvc call "%devroot%\%projectname%\buildscript\modules\zstd.cmd"

@rem Build LLVM OpenCL stack
@IF %toolchain%==msvc IF EXIST "%llvminstloc%\%abi%\lib\cmake\llvm\LLVMConfig.cmake" if defined llvmbuildconf call "%devroot%\%projectname%\buildscript\modules\llvmspv.cmd"
@IF %toolchain%==msvc call "%devroot%\%projectname%\buildscript\modules\libclc.cmd"

@rem If using MSYS2 Mingw-w64 select Vulkan SDK
@IF NOT %toolchain%==msvc call "%devroot%\%projectname%\buildscript\modules\vulkan.cmd"

@rem Binary resource editor
@call "%devroot%\%projectname%\buildscript\modules\resourcehacker.cmd"

@rem Mesa3D build.
@call "%devroot%\%projectname%\buildscript\modules\mesa3d.cmd"

@rem Create distribution
@IF EXIST "%devroot%\mesa\build\%toolchain%-%abi%\" call "%devroot%\%projectname%\buildscript\modules\dist.cmd"

@rem Add version info to binaries
@call "%devroot%\%projectname%\buildscript\modules\addversioninfo.cmd"

@rem Dump build environment information
@call "%devroot%\%projectname%\buildscript\modules\envdump.cmd"

@rem Finish bot mode configuration
@if %botmode% EQU 0 echo @call "%%~dp0..\build.cmd">>"%devroot%\%projectname%\buildscript\bots\bot-%bottimestamp%.cmd"

@call "%devroot%\%projectname%\bin\modules\break.cmd"
@exit /B