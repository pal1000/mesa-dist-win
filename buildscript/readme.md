# Usage guidelines for build.cmd
  * [1. Acquire mesa source code, dependencies and build tools](#1-acquire-mesa-source-code-dependencies-and-build-tools)
  * [2. Setting environment variables and prepare the build](#2-setting-environment-variables-and-prepare-the-build)
  * [3. Build process](#3-build-process)
  * [4. Miscellaneous and build location](#4-miscellaneous-and-build-location)
  
## 1. Acquire mesa source code, dependencies and build tools

- Visual Studio 2017;

Visual Studio has to be installed in its default location. You only need components from within Desktop Development with C++ category. Beside default selected components MFC, ATL and a Windows SDK is required. Latest Windows 10 SDK is highly recommended. You may opt-out in this exact order of CMake Tools and Windows 10 SDK in Visual Studio installer and manually install standalone version of Windows 10 SDK instead as it is sometimes newer. If you want to use standalone Windows 10 SDK make sure you install Windows SDK for Desktop C++ x86 and amd64 apps components.
- [7-zip](http://www.7-zip.org/download.html) or [7-zip portable](https://portableapps.com/apps/utilities/7-zip_portable)

We'll use this to extract all depencies packed in tar.gz or tar.xz archives.
Before continuing prepare an empty folder to extract the rest of dependencies into. I'll call this `.`.

- [Git for Windows 32 or 64-bit](https://git-scm.com/download/win); 

You can use the portable version if you don't want to bloat your system too much, but you have to add the following locations to PATH: 
a. for 64-bit Git: %gitlocation%\bin;%gitlocation%\mingw64\bin;%gitlocation%\cmd
b. for 32-bit Git: %gitlocation%\bin;%gitlocation%\mingw32\bin;%gitlocation%\cmd
Replace %gitlocation% with the actual location where you unpacked Git Portable.
- Mesa source code: [Mirror 1](https://www.mesa3d.org/archive/), [Mirror 2](https://mesa.freedesktop.org/archive/);

The build script can grab Mesa3D code if Git is in PATH. It asks for the branch to pull from. Otherwise manually extract in `.`. Be warned that the archive is double packed. Rename extracted folder to `mesa`.
- [LLVM source code](http://llvm.org/);

Extract LLVM code in `.`. Rename extracted folder to `llvm`. LLVM 4.0 is the minimum version supported by this build scrpt as Visual Studio 2017 is the only version supported. Required to build high-performance drivers and libraries llvmpipe, swr, osmesa gallium JIT and graw.
- [Ninja build system](https://github.com/ninja-build/ninja/releases)

Optional, it reduces LLVM build size as it works with single configuration. Unlike Visual Studio MsBuild which requires a Release and a Debug configuration at minimum. Development on Ninja stalled shortly after 1.8.2 release for unknown reason though. If used, extract Ninja in `.\ninja`. My script asks if you want to do this before starting LLVM build. LLVM must be built in release mode with install target. This build script does it automatically or you can look [here](https://wiki.qt.io/MesaLlvmpipe).

- [CMake 32 or 64 bit](https://cmake.org/download/#latest);

You may use the installer or you can extract the zipped version in `.\cmake`. Required to build LLVM just-in-time recompiler used by Mesa high-performance drivers and libraries llvmpipe, swr, osmesa gallium JIT and graw.
- [Flex and Bison](https://sourceforge.net/projects/winflexbison/);

Extract in `.\flexbison`.
- [Python 32 or 64 bit](https://www.python.org/);

Use Python 2.7. Mesa3D Scons build system was written using Python 2 syntax. Trying to use Python 3 leads to Python crash at this moment. Use the installer. Make sure it's dropped in `.\python` if you don't want to add it to PATH system-wide. Make sure pip is installed. Sometimes it isn't. If it isn't get it from [here](https://pip.pypa.io/en/stable/installing/).
- [pywin32 for Python 2.7](https://github.com/mhammond/pywin32/releases);

It must match in architecture with Python. There is a bug in the installer. For true successful installation you have to open Command Prompt as admin, browse to the folder holding pywin32 installer using CD command and run it from there.
- Update setuptools for python. When setuptools is up-to-date you can successfully install Scons via Pypi without having to install wheel. The build script updates it automatically. To update manually do `pip install -U setuptools` with python being in PATH.
- [Scons for python 2.7](https://sourceforge.net/projects/scons/files/scons/);

The build script gets the latest version of Scons automatically.
- mako module for Python 2.7 and MarkupSafe dependency. Install with pip install mako. This script installs mako automatically. It also attempts to update all Python modules.
- Get this script.

You will need to clone its repository using git. Go to folder where you installed git and open git-cmd.bat. Change current folder to dependencies dropping folder, the one I called `.`. Execute `git clone https://github.com/pal1000/mesa-dist-win mesa-dist-win`.

Mesa 17.3 and newer have built-in S3TC suppport, now that the S3TC patent expired, but you still need to enable S3TC texture cache though by modifying inside Mesa source code in src/gallium/drivers/llvmpipe/lp_tex_sample.h the value of LP_USE_TEXTURE_CACHE to 1. It should become

`#define LP_USE_TEXTURE_CACHE 1`

You can also enable S3TC texture cache by applying a patch included in this repository in `patches/s3tc.patch` to Mesa3D source code if you have git installed. This build script will try to apply it automatically. To apply manually, browse in Command Prompt to Mesa3D source code, then use `git apply` command with the location of the patch file as parametter.

This will improve S3 texture compression performance significantly.
## 2. Setting environment variables and prepare the build
If you didn't follow my instructions you need to add the location of the following components to PATH:

Dependency component | Paths relative to their installation directories (you have to convert them to absolute paths)
-------------------- | ---------------------------------------------------------------------------------------------
flex and bison | `.\;`
Python | `.\;` and `.\Scripts\;`
CMake | `.\bin\;`
Ninja build system if used | `.\ninja\;`
LLVM | `.\llvm\bin\;`

Python and CMake installers can set PATH automatically during installation. This build script automates this whole process but you must respect the relative paths between the script and the sources and tools. If you folowed my instructions this should have been accomplished already.

This way the script would be able to set PATH variable correctly and you'll no longer need to set anything from this point forward.

## 3. Build process
The script is located at `.\mesa-dist-win\buildscript\build.cmd`. Now run it.
The script acts like a Wizard asking for the following during execution:
- if you want to update/install required python modules (setuptools, pip, pywin32, scons, mako and MarkupSafe);
- architecture for which you want to build mesa - type "y" for x64, otherwise x86 is selected;
- if you want to build LLVM.  You only need to do it once for each architecture you target when new version is out and this doesn't happen very often, also it is no longer mandatory if you only want softpipe, osmesa swrast and a slowed down osmesa gallium;
- if building LLVM asks if you want to build with Ninja build system instead of Msbuild if Ninja is in PATH;
- if Git is installed and Mesa code is missing, asks if you don't want to download Mesa code using Git and abort execution;
- if you intend to download Mesa using Git, you are asked to specify which branch (valid entries: 17.2, 17.3 ...);
- if you want to build Mesa3D;
- if LLVM is available asks if you want to use it;
- if LLVM is missing asks if you want to build without it;
- if LLVM is used you are asked if you want to build swr, graw respectively;
- if you want to build off-screen rendering driver(s);
- if you want to do a clean build;
- if you want to organize binaries in a single location (distribution creation).

## 4. Miscellaneous and build location
All paths are relative to dependencies dropping folder, the one I called `.`.

CMake build system is created in:
- for 32 bit: .\llvm\cmake-x86;
- for 64-bit: .\llvm\cmake-x64.

CMake binaries are created in:
- for 32 bit: .\llvm\x86;
- for 64-bit: .\llvm\x64.

Mesa llvmpipe and softpipe drivers are dropped in:
- for 32-bit: .\mesa\build\windows-x86\gallium\targets\libgl-gdi;
- for 64-bit: .\mesa\build\windows-x86_64\gallium\targets\libgl-gdi.

and are both named opengl32.dll.

Mesa swr drivers are dropped in.\mesa\build\windows-x86_64\gallium\drivers\swr.

[They only support 64-bit officially](https://bugs.freedesktop.org/show_bug.cgi?id=102564#c5). They are named swrAVX.dll and swrAVX2.dll after their instruction set requirements. You need both llvmpipe/softpipe and swr driver suitable to your CPU for swr to work. swr drivers are loaded when requested by llvmpipe/softpipe drivers. They can't run on their own.

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
