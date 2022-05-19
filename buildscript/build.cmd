@set TITLE=Building Mesa3D
@TITLE %TITLE%

@rem Determine Mesa3D build environment root folder and convert the path to it into DOS 8.3 format to avoid quotes mess.
@cd "%~dp0"
@cd ..\..\
@set CD=
@set devroot=%CD%
@IF %devroot:~0,1%%devroot:~-1%=="" set devroot=%devroot:~1,-1%
@IF "%devroot:~-1%"=="\" set devroot=%devroot:~0,-1%

@set projectname=mesa-dist-win
@set "ERRORLEVEL="

@rem Create folder to store generated resource files and MSYS2 shell scripts
@IF NOT EXIST "%devroot%\%projectname%\buildscript\assets\" md "%devroot%\%projectname%\buildscript\assets"

@rem Command line option to disable out of tree patches for Mesa3D
@IF "%1"=="disableootpatch" set disableootpatch=1
@IF "%disableootpatch%"=="1" set TITLE=%TITLE% ^(out of tree patches disabled^)
@IF "%disableootpatch%"=="1" TITLE %TITLE%

@rem Analyze environment. Get each dependency status: 0=missing, 1=standby/load manually in PATH, 2=cannot be unloaded.
@rem Not all dependencies can have all these states.

@rem Look for MSYS2 build environment
@call "%devroot%\%projectname%\buildscript\modules\msys.cmd"

@rem Search for compiler toolchain. Hard fail if none found
@call "%devroot%\%projectname%\buildscript\modules\toolchain.cmd"

@rem Select target architecture
@call "%devroot%\%projectname%\buildscript\modules\abi.cmd"

@rem Offer option to build with clang
@call "%devroot%\%projectname%\buildscript\modules\clang.cmd"

@rem If using MSVC search for Python. State tracking is pointless as it is loaded once and we are done. Hard fail if missing.
@IF %toolchain%==msvc call "%devroot%\%projectname%\buildscript\modules\discoverpython.cmd"

@rem If using MSVC search for Python packages. Install missing packages automatically. Ask to do an update to all packages.
@IF %toolchain%==msvc call "%devroot%\%projectname%\buildscript\modules\pythonpackages.cmd"

@rem Build throttle.
@call "%devroot%\%projectname%\buildscript\modules\throttle.cmd"

@rem Version control
@call "%devroot%\%projectname%\buildscript\modules\git.cmd"

@rem Verify if out of tree patches can be applied.
@call "%devroot%\%projectname%\buildscript\modules\patching.cmd"

@rem Get Meson build location
@call "%devroot%\%projectname%\buildscript\modules\locatemeson.cmd"

@rem If using MSVC check for remaining dependencies: cmake, ninja, winflexbison, nuget and pkg-config if applies.
@IF %toolchain%==msvc call "%devroot%\%projectname%\buildscript\modules\cmake.cmd"
@IF %toolchain%==msvc call "%devroot%\%projectname%\buildscript\modules\ninja.cmd"
@IF %toolchain%==msvc call "%devroot%\%projectname%\buildscript\modules\winflexbison.cmd"
@IF %toolchain%==msvc call "%devroot%\%projectname%\buildscript\modules\nuget.cmd"
@IF %toolchain%==msvc call "%devroot%\%projectname%\buildscript\modules\pkg-config.cmd"

@rem If using MSVC do CLonD3D12 build
@IF %toolchain%==msvc call "%devroot%\%projectname%\buildscript\modules\clon12.cmd"

@rem If using MSVC do SPIR-V Tools build
@IF %toolchain%==msvc call "%devroot%\%projectname%\buildscript\modules\spirv.cmd"

@rem If using MSVC do LLVM build.
@IF %toolchain%==msvc call "%devroot%\%projectname%\buildscript\modules\llvm.cmd"
@IF %toolchain%==msvc call "%devroot%\%projectname%\buildscript\modules\libclc.cmd"

@rem If using MSYS2 Mingw-w64 update MSYS2 packages
@IF NOT %toolchain%==msvc call "%devroot%\%projectname%\buildscript\modules\msysupdate.cmd"

@rem If using MSYS2 Mingw-w64 install necessary packages
@IF NOT %toolchain%==msvc call "%devroot%\%projectname%\buildscript\modules\msyspackages.cmd"

@rem If using MSYS2 Mingw-w64 select Vulkan SDK
@IF NOT %toolchain%==msvc call "%devroot%\%projectname%\buildscript\modules\vulkan.cmd"

@rem Binary resource editor
@call "%devroot%\%projectname%\buildscript\modules\resourcehacker.cmd"

@rem Dump build environment information
@call "%devroot%\%projectname%\buildscript\modules\envdump.cmd"

@rem Mesa3D build.
@call "%devroot%\%projectname%\buildscript\modules\mesa3d.cmd"

@rem Create distribution
@call "%devroot%\%projectname%\buildscript\modules\dist.cmd"