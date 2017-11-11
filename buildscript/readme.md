# Usage guidelines for build.cmd
  * [1. Acquire mesa source code, dependencies and build tools](#1-acquire-mesa-source-code-dependencies-and-build-tools)
  * [2. Setting environment variables and prepare the build](#2-setting-environment-variables-and-prepare-the-build)
  * [3. Build process](#3-build-process)
  * [4. Miscellaneous and build location](#4-miscellaneous-and-build-location)
  
## 1. Acquire mesa source code, dependencies and build tools

- Visual Studio 2017;

Visual Studio has to be installed in its default location. You need to install the following components under Desktop Development with C++: MFC and ATL, CMake tools, Windows 8.1 SDK and latest Windows 10 SDK.

- [7-zip](http://www.7-zip.org/download.html) or [7-zip portable](https://portableapps.com/apps/utilities/7-zip_portable)

We'll use this to extract all depencies packed in tar.gz or tar.xz archives.
Before continuing prepare an empty folder to extract the rest of dependencies into. I'll call this `.`.

- Mesa source code: [Mirror 1](https://www.mesa3d.org/archive/), [Mirror 2](https://mesa.freedesktop.org/archive/);

Extract in `.`. Be warned that the archive is double packed. Rename extracted folder to `mesa`.
- [Git for Windows 32 or 64-bit](https://git-scm.com/download/win); 

You can use the portable version if you don't want to bloat your system too much, but you have to add it to PATH.
- [LLVM source code](http://llvm.org/);

Extract LLVM code in `.`. Rename extracted folder to `llvm`. If you use Visual Studio 2017, LLVM 4.0 is the minimum version that supports it.
- [Ninja build system](https://github.com/ninja-build/ninja/releases)

Optional, it reduces LLVM build size as it works with single configuration. Unlike Visual Studio MsBuild which require a Release and a Debug configuration at minimum. 
If used, extract Ninja in `.\ninja`. My script asks if you want to do this before starting LLVM build. LLVM must be built in release mode with install target. This build script does it automatically or you can look [here](https://wiki.qt.io/MesaLlvmpipe).
- S3 texture compression library source code;

S3 texture compression library is optional. Build it only if you need it. Mesa 17.3 integrated it, now that the S3TC patent expired, but you still need to enable S3TC texture cache though. libtxc_dxtn implements 5 S3 texture compression extensions. You will need to clone S3 texture compression library source code repository using git. Go to folder where you installed git and open git-cmd.bat. Change current folder to dependencies dropping folder, the one I called `.`. Execute `git clone git://people.freedesktop.org/~mareko/libtxc_dxtn dxtn`.

It is recommended that before building Mesa to enable S3TC texture cache by modifying inside Mesa source code in src/gallium/drivers/llvmpipe/lp_tex_sample.h the value of LP_USE_TEXTURE_CACHE to 1. It should become

`#define LP_USE_TEXTURE_CACHE 1`

You can also enable S3TC texture cache by applying a patch included in this repository in `patches/s3tc.patch` to Mesa3D source code if you have git installed. This build script will try to apply it automatically. To apply manually, browse in Command Prompt to Mesa3D source code, then use `git apply` command with the location of the patch file as parametter.

This will improve S3 texture compression performance significantly.

- [CMake 32 or 64 bit](https://cmake.org/download/#latest);

You may use the installer or you can extract the zipped version in `.\cmake`.
- [MSYS2 Mingw-w64](https://sourceforge.net/projects/msys2/files/Base/);

Optional. You only need MSYS2 if you want to build S3 texture compression library. Install the one suitable for your host in `.\msys64` or `.\msys32`. After installation completes let it open the MSYS Terminal. Execute `pacmam -Syu` and let it update. At the end it will hang, so you'll have to terminate `pacman.exe` from Task Manager then close the window. In Start search for MSYS and Open MSYS2 MSYS. Run the following commands in order, accepting all the prompts:

`pacman -Syu`

`pacman -S mingw-w64-i686-toolchain`

`pacman -S mingw-w64-x86_64-toolchain`

- Standalone Mingw-w64 i686 and x86_64;

Optional. Alternative for MSYS2 Mingw-w64. You only need mingw-w64 if you want to build S3 texture compression library. Teoretically mesa could be built the same way but [it doesn't work due to a Scons bug](https://bugs.freedesktop.org/show_bug.cgi?id=94072). Download web-installer from [here](https://sourceforge.net/projects/mingw-w64/). You need to run web installer once for each target architecture (i686 means 32-bit, x86_64 means 64-bit). Install in `.\mingw-w64\x86` for 32-bit builds and `.\mingw-w64\x64` for 64-bit builds. You need both as each one can only build for their matching architecture. Leave all other setings as default.
- [Flex and Bison](https://sourceforge.net/projects/winflexbison/);

Extract in `.\flexbison`.
- [Python 32 or 64 bit](https://www.python.org/);

Use Python 2.7. Mesa3D Scons build system was written using Python 2 syntax. Trying to use Python 3 leads to Python crash at this moment. Use the installer. Make sure it's dropped in `.\python` if you don't want to add it to PATH system-wide. Make sure pip is installed. Sometimes it isn't. If it isn't get it from [here](https://pip.pypa.io/en/stable/installing/).
- [pywin32 for Python 2.7](https://sourceforge.net/projects/pywin32/files/);
It must match in architecture with Python.

- Wheel for python 2.7. Required to download Scons via pypi. The build script installs it automatically. To install manually do `pip install wheel` with python being in PATH.
- [Scons for python 2.7](https://sourceforge.net/projects/scons/files/scons/);

The build script gets the latest version of Scons automatically.
- mako module for Python 2.7. Install with pip install mako. This script installs mako automatically. It also attempts to update all Python modules.
- Get this script.

You will need to clone its repository using git. Go to folder where you installed git and open git-cmd.bat. Change current folder to dependencies dropping folder, the one I called `.`. Execute `git clone https://github.com/pal1000/mesa-dist-win mesa-dist-win`.

## 2. Setting environment variables and prepare the build
If you didn't follow my instructions you need to add the location of the following components to PATH:

Dependency component | Paths relative to their installation directories (you have to convert them to absolute paths)
-------------------- | ---------------------------------------------------------------------------------------------
flex and bison | `.\;`
Python | `.\;` and `.\Scripts\;`
CMake | `.\bin\;`
MSYS2 mingw-w64 if used | `.\usr\bin\;` and `.\mingw64\bin\;` for 64-bit and `.\mingw32\bin\;` for 32-bit respectively
Standalone mingw-w64 if used | `.\mingw64\bin\;` for 64-bit and `.\mingw32\bin\;` for 32-bit
Ninja build system if used | `.\ninja\;`
LLVM | `.\llvm\bin\;`

Python and CMake installers can set PATH automatically during installation. This build script automates this whole process but you must respect the relative paths between the script and the sources and tools. If you folowed my instructions this should have been accomplished already.

This way the script would be able to set PATH variable correctly and you'll no longer need to set anything from this point forward.

## 3. Build process
The script is located at `.\mesa-dist-win\buildscript\build.cmd`. Now run it.
The script acts like a Wizard asking for the following during execution:
- if you want to update/install required python modules (mako and markupsafe);
- architecture for which you want to build mesa - type "y" for x64, otherwise x86 is selected;
- if you need to build LLVM.  You only need to do it once for each architecture you target when new version is out and this doesn't happen very often;
- if you want to build LLVM with Ninja build system instead of Msbuild;
- if Git is installed and Mesa code is missing, ask if you don't want to download Mesa code using Git and abort execution;
- if you intend to download Mesa using Git, you are asked to specify which branch (valid entries: 17.2, 17.3 ...);
- if you want to build Mesa3D;
- if want to build OpenSWR driver;
- if you want to build off-screen rendering drivers;
- if you want to build graw driver;
- if you want to do a clean build;
- if you want to build S3 texture compression library (only asked if at least a flavor of mingw-w64 is detected and library source code is present in the appropriate location);
- what flavor of Mingw-w64 to build S3TC with (only asked if both MSYS2 and standalone Mingw-w64 are detected, 64-bit MSYS2 is preferred over 32-bit if both installed);
- if you want update MSYS2 system and packages before building S3TC (only if you opted for building S3TC with MSYS2 Mingw-w64);
- if you want to organize binaries in a single location (distribution creation).

## 4. Miscellaneous and build location
All paths are relative to dependencies dropping folder, the one I called `.`.

CMake build system is created in:
- for 32 bit: .\llvm\cmake-x86;
- for 64-bit: .\llvm\cmake-x64.

Mesa llvmpipe and softpipe drivers are dropped in:
- for 32-bit: .\mesa\build\windows-x86\gallium\targets\libgl-gdi;
- for 64-bit: .\mesa\build\windows-x86_64\gallium\targets\libgl-gdi.

and are both named opengl32.dll.

Mesa OpenSWR drivers are dropped in.\mesa\build\windows-x86_64\gallium\drivers\swr.

[They only support 64-bit officially](https://bugs.freedesktop.org/show_bug.cgi?id=102564#c5). They are named swrAVX.dll and swrAVX2.dll after their instruction set requirements. You need both llvmpipe/softpipe and OpenSWR driver suitable to your CPU for OpenSWR to work. OpenSWR drivers are loaded when requested by llvmpipe/softpipe drivers. They can't run on their own.

S3 texture compresion binaries are dropped in:
- for 32-bit: .\dxtn\x86;
- for 64-bit: .\dxtn\x64.

Mesa3D off-screen renderers are dropped in:
- 32-bit gallium: .\mesa\build\windows-x86\gallium\targets\osmesa;
- 64-bit gallium: .\mesa\build\windows-x86_64\gallium\targets\osmesa;
- 32-bit swrast: .\mesa\build\windows-x86\mesa\drivers\osmesa;
- 64-bit swrast: .\mesa\build\windows-x86_64\mesa\drivers\osmesa.

Graw libraries are dropped in:
- 32-bit: .\mesa\build\windows-x86\gallium\targets\graw-gdi;
- 64-bit: .\mesa\build\windows-x86_64\gallium\targets\graw-gdi.

Finalized distribution is deployed in: 
- for 32-bit .\mesa-dist-win\bin\x86;
- for 64-bit .\mesa-dist-win\bin\x64.
