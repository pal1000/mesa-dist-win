# Usage guidelines for build.cmd
  * [1. Acquire mesa source code, dependencies and build tools](#1-acquire-mesa-source-code-dependencies-and-build-tools)
  * [2. Setting environment variables and prepare the build](#2-setting-environment-variables-and-prepare-the-build)
  * [3. Build process](#3-build-process)
  * [4. Miscellaneous and build location](#4-miscellaneous-and-build-location)
  
## 1. Acquire mesa source code, dependencies and build tools

- Visual Studio 2015 or 2017 (Visual 2015 Express may not work due to lack of MFC and ATL support); 

For Visual Studio 2017 you need to install the following components under Desktop Development with C++: Visual Studio 2015 toolset [as Scons doesn't support Visual Studio 2017 yet](https://bugs.freedesktop.org/show_bug.cgi?id=100202), MFC and ATL, CMake tools, Windows 8.1 and 10 SDKs and Standard library modules.
- Mesa source code: ftp://ftp.freedesktop.org/pub/mesa/;
- [LLVM source code](http://llvm.org/);

[LLVM 4.0 is not supported yet with Visual Studio build of Mesa](https://bugs.freedesktop.org/show_bug.cgi?id=100201). If you use Visual Studio 2017 you have to patch LLVM 3.9.1 by replacing `_MSC_VER == 1900` with `_MSC_VER >= 1900 && _MSC_VER < 2000` in lib\DebugInfo\PDB\DIA\DIASession.cpp inside llvm source code or build LLVM with MSVC 2015 toolset aided by [Ninja build system](https://github.com/ninja-build/ninja/releases). My script asks if you want to do this before starting LLVM build. You can use Ninja build system regardless of what toolset you use to build LLVM, if you desire so.
LLVM must be built in install mode. This build script does it automatically or you can look [here](https://wiki.qt.io/MesaLlvmpipe).
- [S3 texture compresion library source code](https://cgit.freedesktop.org/~mareko/libtxc_dxtn/)

S3 texture compression library is optional. Build it only if you need it. It implements 5 S3 texture compression extensions. You will need [git](https://git-scm.com/) to download S3 texture compression library source code. It is also recommended that before building Mesa to modify inside Mesa source code in src/gallium/drivers/llvmpipe/lp_tex_sample.h the value of LP_USE_TEXTURE_CACHE to 1. It should become

`#define LP_USE_TEXTURE_CACHE 1`

This will improve S3 texture compression performance significantly.

- [CMake 32 or 64 bit](https://cmake.org/download/#latest);

The installer automatically sets the PATH for you. You only need either 32 or 64-bit cmake. This script was tuned to use the zipped version as it sets PATH at runtime.
- Mingw-w64 i686 and x86_64;

Optional. You need both as each one can only build for their matching architecture. You only need mingw-w64 if you want to build S3 texture compression library. Teoretically mesa could be built the same way but [it doesm't work due to a Scons bug](https://bugs.freedesktop.org/show_bug.cgi?id=94072). Download web-installer from [here](https://sourceforge.net/projects/mingw-w64/). You need to run web installer once for each target architecture (i686 means 32-bit, x86_64 means 64-bit). If build script is located in current directory . then change the installation directory to .\mingw-w64\x86 for 32-bit and .\mingw-w64\x64 for 64-bit. Leave everything else as default.
- [Flex and Bison](https://sourceforge.net/projects/winflexbison/);
- [Python 32 or 64 bit](https://www.python.org/);

Use Python 2.7. Python 3.x is not fully supported by Scons and leads to Python crash at this moment. Make sure pip is installed. Sometimes it isn't. If it isn't get it from [here](https://pip.pypa.io/en/stable/installing/).
- [pywin32 for Python 2.7](https://sourceforge.net/projects/pywin32/files/);

It must match in architecture with Python.
- [Scons for python 2.7](https://sourceforge.net/projects/scons/files/scons/);

It must match in architecture with Python.
Get Scons installer executable, ignore the zipped version. DO NOT use Scons 2.5.0. It doesn't work as it shipped incomplete as stated in [2.5.1 release notes](https://bitbucket.org/scons/scons/raw/8d7fac5a5e9c9a1de4b81769c7c8c0032c82a9aa/src/CHANGES.txt).
- mako module for Python 2.7. Install with pip install mako. build.cmd installs mako automatically. It also attempts to update all Python modules.

## 2. Setting environment variables and prepare the build
You need to add the location of the following components to PATH:

Dependency component | Paths relative to their installation directories (you have to convert them to absolute paths)
-------------------- | ---------------------------------------------------------------------------------------------
flex and bison | `.\;`
Python | `.\;` and `.\Scripts\;`
CMake | `.\bin\;`
mingw-w64 if used | `.\mingw64\bin\;` for 64-bit and `.\mingw32\bin\;` for 32-bit
Ninja build system if used | `.\ninja\;`

build.cmd script automates this whole process but you must respect the relative paths between the script and the sources and tools. Assuming the script is located in current folder "." then each tool and code source must be located as follows:
- CMake: .\cmake;
- Python: .\Python;
- Flex and bison: .\flexbison;
- LLVM source code: .\llvm;
- Mesa source code: .\mesa;
- S3 texture compression library source code: .\dxtn;
- Mingw-w64 i686 (32-bit): .\mingw-w64\x86;
- Mingw-w64 x86_64 (64-bit): .\mingw-w64\x64;
- Ninja build system: .\ninja;

This way the script would be able to set PATH variable correctly and you'll no longer need to set anything from this point forward.

## 3. Build process

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
All paths are relative to script location.

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

After Mesa build completes it will deploy all its binaries in: 
- for 32-bit .\mesa-dist-win\bin\x86;
- for 64-bit .\mesa-dist-win\bin\x64.
