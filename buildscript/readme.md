# Usage guidelines for build.cmd
  * [1. Acquire mesa source code, dependencies and build tools](#1-acquire-mesa-source-code-dependencies-and-build-tools)
  * [2. Setting environment variables and prepare the build](#2-setting-environment-variables-and-prepare-the-build)
  * [3. Build process](#3-build-process)
  * [4. Miscellaneous and build location](#4-miscellaneous-and-build-location)
  
## 1. Acquire mesa source code, dependencies and build tools

- Visual Studio 2017 Community; 

Despite the fact that Visual Studio 2013 and 2015 are supported by Mesa3D, this script has been upgraded for exclusive Visual Studio 2017 compatibility. Due to major changes made by Microsoft to the location of the Native tools I had to drop Visual Studio 2015 support.
You need to install the following Visual Studio components under Desktop Development with C++: Visual Studio 2015 toolchain [as Mesa3D doesn't support Visual Studio 2017 yet](https://bugs.freedesktop.org/show_bug.cgi?id=100202), MFC and ATL support and CMake tools.
- Mesa source code: ftp://ftp.freedesktop.org/pub/mesa/;
- [LLVM source code]( http://llvm.org/);
- [S3 texture compresion library source code](https://cgit.freedesktop.org/~mareko/libtxc_dxtn/)

S3 texture compression library is optional. Build it only if you need it. You will need [git](https://git-scm.com/) to download S3 texture compression library source code.
To build Mesa 13 you have to use LLVM 3.7.1. Newer versions don't work because Mesa attempts to link against the removed llvmipa.lib, [see this forum post](https://www.phoronix.com/forums/forum/software/programming-compilers/903537-llvm-3-9-0-missing-llvmipa). Also [LLVM 4.0 is not supported yet with Visual Studio build](https://bugs.freedesktop.org/show_bug.cgi?id=100201).
- [CMake 32 and 64 bit](https://cmake.org/download/#latest);

The installer automatically sets the PATH for you. But beware if you want to build for both x86 and x64 you will end up with duplicate entry in PATH. You definitely want to avoid this. I recommend use the zipped version and let build.cmd set PATH at runtime.
- Mingw-w64 i686 and x86_64;

Optional. Only if you want to build S3 texture compression library. Teoretically mesa could be built the same way but [it doesm't work due to a Scons bug](https://bugs.freedesktop.org/show_bug.cgi?id=94072). Download web-installer from [here](https://sourceforge.net/projects/mingw-w64/). You need to run web installer once for each target architecture (i686 means 32-bit, x86_64 means 64-bit). If build script is located in current directory . then change the installation directory to .\mingw-w64-x86 for 32-bit and .\mingw-w64-x64 for 64-bit. Leave everything else as default.
- [Flex and Bison](https://sourceforge.net/projects/winflexbison/);
- m4: [32-bit](https://sourceforge.net/projects/msys2/files/REPOS/MSYS2/i686/), [64-bit](https://sourceforge.net/projects/msys2/files/REPOS/MSYS2/x86_64/);

Just search for m4 in these huge pages. Your web browser might freeze for a bit. You'll need 7-Zip to extract linux archives in which m4 is compressed.
- [Python 32 and 64 bit](https://www.python.org/);

Use Python 2.7. Python 3.x is not supported by Scons. Make sure pip is installed. Sometimes it isn't. If it isn't get it from [here](https://pip.pypa.io/en/stable/installing/).
- [pywin32 for Python 32 and 64 bit](https://sourceforge.net/projects/pywin32/files/);
- [Scons for python 32 and 64-bit](https://sourceforge.net/projects/scons/files/scons/);

Get Scons installer executables, ignore the zipped versions. DO NOT use Scons 2.5.0. It doesn't work as it shipped incomplete as stated in [2.5.1 release notes](https://bitbucket.org/scons/scons/raw/8d7fac5a5e9c9a1de4b81769c7c8c0032c82a9aa/src/CHANGES.txt).
- mako module for Python 32 and 64 bit. Install with pip install mako. build.cmd installs mako automatically. It also attempts to update all Python modules. 

## 2. Setting environment variables and prepare the build
You need to add the location of the following components to PATH:
- flex and bison;
- m4;
- Python;
- CMake;
- mingw-w64 if used.

build.cmd script automates this whole process but you must respect the relative paths between the script and the sources and tools. 
Assuming the script is located in current folder "." then each tool and code source must be located as follows:
- m4 32-bit: .\m4\x86;
- m4 64-bit: .\m4\x64;
- CMake 32-bit: .\cmake\x86;
- CMake 64-bit: .\cmake\x64;
- Python 32-bit: .\Python\x86;
- Python 64-bit: .\Python\x64;
- Flex and bison: .\flexbison;
- LLVM source code: .\llvm;
- Mesa source code: .\mesa;
- S3 texture compression library .\dxtn;
- Mingw-w64 i686 (32-bit): .\mingw-w64-x86
- Mingw-w64 x86_64 (64-bit): .\mingw-w64-x64 

This way the script would be able to set PATH variable correctly and you'll no longer need to set anything from this point forward.

## 3. Build process

The script acts like a Wizard asking for the following during execution:
- architecture for which you want to build mesa - type "y " for x64, otherwise x86 is selected;
- if you need to build LLVM.  You only need to do it once for each architecture you target when new version is out and this doesn't happen very often;
- if you want to build S3 texture compression library;

Only asked if mingw-w64 is detected and library source code is present in the appropriate location
- if you want to build mesa or quit;
- if want to build OpenSWR driver. 

After mesa build completes, because scons closes Command prompt on finish, I run it via "cmd /k", so after the script completes you are returned to Command Prompt. You'll have to manually close it.

## 4. Miscellaneous and build location

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
