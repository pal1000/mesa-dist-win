# Usage guidelines for build.cmd
  * [1. Acquire mesa source code, dependencies and build tools](#1-acquire-mesa-source-code-dependencies-and-build-tools)
  * [2. Setting environment variables and prepare the build](#2-setting-environment-variables-and-prepare-the-build)
  * [3. Build process](#3-build-process)
  * [4. Miscellaneous and build location](#4-miscellaneous-and-build-location)
  
## 1. Acquire mesa source code, dependencies and build tools

- Visual Studio 2015 or 2017 (Visual 2015 Express may not work due to lack of MFC and ATL support);

Visual Studio has to be installed in its default location. For Visual Studio 2017 you need to install the following components under Desktop Development with C++: Visual Studio 2015 toolset [as Scons doesn't support Visual Studio 2017 yet](https://bugs.freedesktop.org/show_bug.cgi?id=100202), MFC and ATL, CMake tools, Windows 8.1 and 10 SDKs.

- [7-zip](http://www.7-zip.org/download.html) or [7-zip portable](https://portableapps.com/apps/utilities/7-zip_portable)

We'll use this to extract all depencies packed in tar.gz or tar.xz archives.
Before continuing prepare an empty folder to extract the rest of dependencies into. I'll call this `.`.

- Mesa source code: [Mirror 1](https://www.mesa3d.org/archive/), [Mirror 2](https://mesa.freedesktop.org/archive/);

Extract in `.`. Be warned that the archive is double packed. Rename extracted folder to `mesa`.
- [Git for Windows 32 or 64-bit](https://git-scm.com/download/win); 

You can use the portable version if you don't want to bloat your system too much.
- [LLVM source code](http://llvm.org/);

LLVM 5.0 is not yet supported. See [Mesa bug 102318](https://bugs.freedesktop.org/show_bug.cgi?id=102318). A patch is included in this repository in `patches/scons-llvm5.patch` for Mesa3D source code to make it work which requires git in order to apply. This build script will try to apply it automatically. To apply manually, browse in Command Prompt to Mesa3D source code, then use `git apply` command with the location of the patch file as parametter. 

Extract LLVM code in `.`. Rename extracted folder to `llvm`. If you use Visual Studio 2017, LLVM 4.0 is the only version that supports it.
- [Ninja build system](https://github.com/ninja-build/ninja/releases)

Optional, it reduces LLVM build size as it works with single configuration. Unlike Visual Studio MsBuild which require a Release and a Debug configuration at minimum. 
If used, extract Ninja in `.\ninja`. My script asks if you want to do this before starting LLVM build. LLVM must be built in release mode with install target. This build script does it automatically or you can look [here](https://wiki.qt.io/MesaLlvmpipe).
- S3 texture compression library source code;

S3 texture compression library is optional. Build it only if you need it. It implements 5 S3 texture compression extensions. You will need to clone S3 texture compression library source code repository using git. Go to folder where you installed git and open git-cmd.bat. Change current folder to dependencies dropping folder, the one I called `.`. Execute `git clone git://people.freedesktop.org/~mareko/libtxc_dxtn dxtn`. It is also recommended that before building Mesa to enable S3TC texture cache by modifying inside Mesa source code in src/gallium/drivers/llvmpipe/lp_tex_sample.h the value of LP_USE_TEXTURE_CACHE to 1. It should become

`#define LP_USE_TEXTURE_CACHE 1`

You can also enable S3TC texture cache by applying a patch included in this repository in `patches/s3tc.patch` to Mesa3D source code if you have git installed. This build script will try to apply it automatically. To apply manually, browse in Command Prompt to Mesa3D source code, then use `git apply` command with the location of the patch file as parametter.

This will improve S3 texture compression performance significantly.

- [CMake 32 or 64 bit](https://cmake.org/download/#latest);

You may use the installer or you can extract the zipped version in `.\cmake`.
- Mingw-w64 i686 and x86_64;

Optional. Download web-installer from [here](https://sourceforge.net/projects/mingw-w64/). You need to run web installer once for each target architecture (i686 means 32-bit, x86_64 means 64-bit). Install in `.\mingw-w64\x86` for 32-bit builds and `.\mingw-w64\x64` for 64-bit builds. You need both as each one can only build for their matching architecture. Leave all other setings as default. You only need mingw-w64 if you want to build S3 texture compression library. Teoretically mesa could be built the same way but [it doesn't work due to a Scons bug](https://bugs.freedesktop.org/show_bug.cgi?id=94072).
- [Flex and Bison](https://sourceforge.net/projects/winflexbison/);

Extract in `.\flexbison`.
- [Python 32 or 64 bit](https://www.python.org/);

Use Python 2.7. Python 3.x is not fully supported by Scons and leads to Python crash at this moment. Use the installer. Make sure it's dropped in `.\python` if you don't want to add it to PATH system-wide. Make sure pip is installed. Sometimes it isn't. If it isn't get it from [here](https://pip.pypa.io/en/stable/installing/).
- [pywin32 for Python 2.7](https://sourceforge.net/projects/pywin32/files/);

It must match in architecture with Python.
- [Scons for python 2.7](https://sourceforge.net/projects/scons/files/scons/);

It must match in architecture with Python.
Get Scons installer executable, ignore the zipped version. DO NOT use Scons 2.5.0. It doesn't work as it shipped incomplete as stated in [2.5.1 release notes](https://bitbucket.org/scons/scons/raw/8d7fac5a5e9c9a1de4b81769c7c8c0032c82a9aa/src/CHANGES.txt).
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
mingw-w64 if used | `.\mingw64\bin\;` for 64-bit and `.\mingw32\bin\;` for 32-bit
Ninja build system if used | `.\ninja\;`
LLVM | `.\llvm\bin\;`

Python and CMake installers can set PATH automatically during installation. This build script automates this whole process but you must respect the relative paths between the script and the sources and tools. If you folowed my instructions this should have been accomplished already.

This way the script would be able to set PATH variable correctly and you'll no longer need to set anything from this point forward.

## 3. Build process
The script is located at `.\mesa-dist-win\buildscript\build.cmd`. Now run it.
The script acts like a Wizard asking for the following during execution:
- architecture for which you want to build mesa - type "y" for x64, otherwise x86 is selected;
- if you need to build LLVM.  You only need to do it once for each architecture you target when new version is out and this doesn't happen very often;
- if you are running Visual Studio 2017 and Ninja build system is installed, the script asks if you want to build LLVM with MSVC 2015 toolset instead of 2017;
- if you want to build LLVM with Ninja build system instead of Msbuild (only if you opted for default toolset, e.g. MSVC 2017 toolset with Visual Studio 2017 or MSVC 2015 toolset with Visual Studio 2015);
- if you want to build S3 texture compression library (only asked if mingw-w64 is detected and library source code is present in the appropriate location);
- if you want to build mesa or quit;
- if want to build OpenSWR driver;
- if you want to build off-screen rendering drivers;
- if you want to build graw driver.

## 4. Miscellaneous and build location
All paths are relative to dependencies dropping folder, the one I called `.`.

CMake build system is created in:
- for 32 bit: .\llvm\cmake-x86;
- for 64-bit: .\llvm\cmake-x64.

Mesa llvmpipe and softpipe drivers are dropped in:
- for 32-bit: .\mesa\build\windows-x86\gallium\targets\libgl-gdi;
- for 64-bit: .\mesa\build\windows-x86_64\gallium\targets\libgl-gdi.

and are both named opengl32.dll.

Mesa OpenSWR drivers are dropped in:
- for 32-bit: .\mesa\build\windows-x86\gallium\drivers\swr;
- for 64-bit: .\mesa\build\windows-x86_64\gallium\drivers\swr.

and are named swrAVX.dll and swrAVX2.dll after their instruction set requirements. You need both llvmpipe/softpipe and OpenSWR driver suitable to your CPU for OpenSWR to work. OpenSWR drivers are loaded when requested by llvmpipe/softpipe drivers. They can't run on their own.

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

After Mesa build completes it will deploy all binaries in: 
- for 32-bit .\mesa-dist-win\bin\x86;
- for 64-bit .\mesa-dist-win\bin\x64.
