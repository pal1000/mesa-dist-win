@set TITLE=Building Mesa3D
@TITLE %TITLE%

@rem Determine Mesa3D build environment root folder and convert the path to it into DOS 8.3 format to avoid quotes mess.
@cd "%~dp0"
@cd ..\..\
@for %%a in ("%cd%") do @set mesa=%%~sa

@rem Select target architecture
@call %mesa%\mesa-dist-win\buildscript\modules\abi.cmd

@rem Analyze environment. Get each dependency status: 0=missing, 1=standby/load manually in PATH, 2=cannot be unloaded.
@rem Not all dependencies can have all these states.

@rem Look for MSYS2 build environment
@call %mesa%\mesa-dist-win\buildscript\modules\msys.cmd

@rem Search for compiler toolchain. Hard fail if none found
@call %mesa%\mesa-dist-win\buildscript\modules\toolchain.cmd

@rem If using MSVC search for Python. State tracking is pointless as it is loaded once and we are done. Hard fail if missing.
@IF %toolchain%==msvc call %mesa%\mesa-dist-win\buildscript\modules\discoverpython.cmd

@rem If using MSVC select build system to use with Mesa3D.
@IF %toolchain%==msvc call %mesa%\mesa-dist-win\buildscript\modules\selectmesabldsys.cmd

@rem If using MSVC search for Python packages. Install missing packages automatically. Ask to do an update to all packages.
@IF %toolchain%==msvc call %mesa%\mesa-dist-win\buildscript\modules\pythonpackages.cmd

@rem If using MSVC check for remaining dependencies: cmake, ninja, winflexbison, git and pkg-config if applies.
@IF %toolchain%==msvc call %mesa%\mesa-dist-win\buildscript\modules\otherdependencies.cmd

@rem Build throttle.
@call %mesa%\mesa-dist-win\buildscript\modules\throttle.cmd

@rem Backup PATH before building anything to easily keep environment clean.
@set oldpath=%PATH%

@rem If using MSVC do LLVM build.
@IF %toolchain%==msvc call %mesa%\mesa-dist-win\buildscript\modules\llvm.cmd

@rem If using MSYS2 Mingw-w64 GCC update MSYS2 packages
@IF %toolchain%==gcc call %mesa%\mesa-dist-win\buildscript\modules\msysupdate.cmd

@rem If using MSYS2 Mingw-w64 GCC install necessary packages
@IF %toolchain%==gcc call %mesa%\mesa-dist-win\buildscript\modules\msyspackages.cmd

@rem Dump build environment information
@call %mesa%\mesa-dist-win\buildscript\modules\envdump.cmd

@rem Mesa3D build.
@call %mesa%\mesa-dist-win\buildscript\modules\mesa3d.cmd

@rem Create distribution
@call %mesa%\mesa-dist-win\buildscript\modules\dist.cmd