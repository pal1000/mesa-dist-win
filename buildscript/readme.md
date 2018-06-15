# Build script usage guidelines
* [1. Acquire mesa source code, dependencies and build tools](#1-acquire-mesa-source-code-dependencies-and-build-tools)
* [2. Setting environment variables and prepare the build](#2-setting-environment-variables-and-prepare-the-build)
* [3. Build process](#3-build-process)
* [4. Miscellaneous and build location](#4-miscellaneous-and-build-location)

## 1. Acquire mesa source code, dependencies and build tools

- Visual Studio 2017;

Visual Studio has to be installed in its default location. You only need components from within Desktop Development with C++ category. Beside default selected components MFC, ATL and a Windows SDK is required. Latest Windows 10 SDK is highly recommended. You may opt-out in this exact order of CMake Tools and Windows 10 SDK in Visual Studio installer and manually install standalone version of Windows 10 SDK instead as it is sometimes newer. If you want to use standalone Windows 10 SDK make sure you install Windows SDK for Desktop C++ x86 and amd64 apps components.
- [7-zip](http://www.7-zip.org/download.html) or [7-zip portable](https://portableapps.com/apps/utilities/7-zip_portable)

We'll use this to extract all dependencies packed in tar.gz or tar.xz archives.
Before continuing prepare an empty folder to extract the rest of dependencies into. I'll call this `.`.

- [Git for Windows 32 or 64-bit](https://git-scm.com/download/win);

Highly recommended, but not mandatory. Required if you want to build Mesa3D osmesa library having GLES support enabled, osmesa won’t have GLES support however. You can use the portable version if you don't want to bloat your system too much, but you have to either launch the build script from within git-cmd.exe session (git-cmd.exe is located in Git installation directory) or run git-cmd.exe with this build script as argument (ex assuming git was installed in c:\dev\git and this project repository was cloned in c:\dev\mesa-dist-win , the build script launch command looks like this - "c:\dev\git\git-cmd.exe" "c:\dev\mesa-dist-win\buildscript\build.cmd").
- Mesa source code: [Mirror 1](https://gitlab.freedesktop.org/mesa/mesa), [Mirror 2](https://www.mesa3d.org/archive/), [Mirror 3](https://mesa.freedesktop.org/archive/);

The build script can grab Mesa3D code if Git is in PATH. It asks for the branch to pull from. Otherwise manually extract in `.`. Be warned that the archive is double packed. Rename extracted folder to `mesa`.
- [LLVM source code](http://llvm.org/);

Extract LLVM code in `.`. Rename extracted folder to `llvm`. LLVM 4.0 is the minimum version supported by this build scrpt as Visual Studio 2017 is the only version supported. Required to build high-performance drivers llvmpipe and swr and JIT speed-up for other drivers and libraries. LLVM must be built in release mode with install target. This build script does it automatically or you can look [here](https://wiki.qt.io/MesaLlvmpipe).
- [Ninja build system](https://github.com/ninja-build/ninja/releases)

Optional, it reduces LLVM build size as it works with single configuration and also it is much faster and gentler with the storage device unlike Visual Studio MsBuild which requires a Release and a Debug configuration at minimum. If used, extract Ninja in `.\ninja`. If ninja is available my script asks if you want to use it when building LLVM.

- [CMake 32 or 64 bit](https://cmake.org/download/#latest);

You may use the installer or you can extract the zipped version in `.\cmake`. Required to build LLVM just-in-time recompiler used by Mesa high-performance drivers llvmpipe and swr and JIT speed-up for other drivers and libraries.
- [Flex and Bison](https://sourceforge.net/projects/winflexbison/);

Extract in `.\flexbison`.
- [Python 32 or 64 bit](https://www.python.org/);

Use Python 2.7. Mesa3D Scons build system was written using Python 2 syntax. Trying to use Python 3 leads to Python crash at this moment. Use the installer. Make sure pip is installed. Sometimes it isn't. If it isn't get it from [here](https://pip.pypa.io/en/stable/installing/). If you don't want to add Python to PATH you can either install it in `.\python` or if you have Python launcher component of Python 3.x installed for whatever reason you can install it anywhere you want. If using Python launcher pick a Python 2.7 installation. Python 3.x can only build LLVM for now. It can't build Mes3D on Windows yet, but developers are working upstream on a Meson build for Mesa3D which is a Python 3.x native. For those who want to attempt a Mesa3D build with Meson there is the command line switch `/enablemeson`, but obviously it doesn't work yet due to lack of upstream support.
- [pywin32 for Python 2.7](https://github.com/mhammond/pywin32/releases);

It must match in architecture with Python. There is a bug in the installer. For true successful installation you have to open Command Prompt as admin, browse to the folder holding pywin32 installer using CD command and run it from there.
- Update setuptools for python via `python -m pip install -U setuptools` when Python is in PATH or currrent folder. You can successfully install Scons via Pypi without having to install wheel when setuptools is up-to-date if you are still on Python 2.7.14. For some reason with Python 2.7.15 wheel is mandatory. Install it with `python -m pip install -U wheel`. The build script updates setuptools and installs wheel automatically.
- [Scons for python 2.7](https://sourceforge.net/projects/scons/files/scons/);

The build script gets the latest version of Scons automatically.
- mako module for Python 2.7 and MarkupSafe dependency. Install with `python -m pip install mako`. This script installs mako automatically. It also attempts to update all Python modules.
- Get this script.

You will need to clone its repository using git. Go to folder where you installed git and open git-cmd.bat. Change current folder to dependencies dropping folder, the one I called `.`. Execute `git clone https://github.com/pal1000/mesa-dist-win mesa-dist-win`.

Mesa 17.3 and newer have built-in S3TC support, now that the S3TC patent expired, but you still need to enable S3TC texture cache though by modifying inside Mesa source code in src/gallium/drivers/llvmpipe/lp_tex_sample.h the value of LP_USE_TEXTURE_CACHE to 1. It should become

`#define LP_USE_TEXTURE_CACHE 1`

You can also enable S3TC texture cache by applying a patch included in this repository in `patches/s3tc.patch` to Mesa3D source code if you have git installed. This build script will try to apply it automatically. To apply manually, browse in Command Prompt to Mesa3D source code, then use `git apply` command with the location of the patch file as parameter.

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

Python and CMake installers can set PATH automatically during installation. This build script automates this whole process but you must respect the relative paths between the script and the sources and tools. If you followed my instructions this should have been accomplished already.

This way the script would be able to set PATH variable correctly and you'll no longer need to set anything from this point forward.

## 3. Build process
The script is located at `.\mesa-dist-win\buildscript\build.cmd`. Now run it.
The script acts like a Wizard asking questions during execution:
- architecture for which you want to build mesa - type "y" for x64, otherwise x86 is selected;
- if Python launcher is available a list of Python installations is displayed. If you pick a Python 3.x installation, or your main Python installation is version 3.x, in normal mode you can only build LLVM as it supports both Python 2.7 and 3.x, but if the script is running with the experimental `/enablemeson` command line switch a build of Mesa3D with Meson is attempted;
- if you want to update/install required python modules (setuptools, pip, pywin32, scons, meson, mako and MarkupSafe);
- if you want to build LLVM.  You only need to do it once for each architecture you target, also it is no longer mandatory if you are not interested in llvmpipe, swr or JIT speed-ups;
- if building LLVM it asks if you want to build with Ninja build system instead of Msbuild if Ninja is in PATH;
- if Git is installed and Mesa code is missing it asks if you want to download Mesa code using Git and build;
- if you intend to download Mesa using Git, you are asked to specify which branch (valid entries: 17.2, 17.3 ...);
- if you want to build Mesa3D if you weren't asked already;
- if LLVM is available it asks if you want to use it;
- if LLVM is missing it asks if you want to build without it;
- if you want to build Mesa3D with OpenMP support;
- if you want to build Mesa3D with floating-point textures and renderbuffers support;
- if LLVM is used and if it's a 64-bit build you are asked if you want to build swr;
- if you want to build GLAPI and GLES support;
- if you want to do an express configuration of Mesa3D build which includes libgl-gdi, graw-gdi, graw-null and osmesa targets by default with OpenGL ES added if GLES and GLAPI support is enabled;
- if you didn't opt-in for express configuration you are asked if you want to build off-screen rendering driver(s);
- if you didn't opt-in for express configuration you are asked if you want to build graw;
- if you want to do a clean build;
- if you want to organize binaries in a single location (distribution creation).

## 4. Miscellaneous and build location
All paths are relative to dependencies dropping folder, the one I called `.`.

CMake build system is created in:
- for 32 bit: .\llvm\buildsys-x86;
- for 64-bit: .\llvm\buildsys-x64.

CMake binaries are created in:
- for 32 bit: .\llvm\x86;
- for 64-bit: .\llvm\x64.

Mesa llvmpipe and softpipe drivers are dropped in:
- for 32-bit: .\mesa\build\windows-x86\gallium\targets\libgl-gdi;
- for 64-bit: .\mesa\build\windows-x86_64\gallium\targets\libgl-gdi.

and are both named opengl32.dll.

Mesa GLAPI shared libraries and OpenGL ES drivers are dropped in:
- for 32-bit: .\mesa\build\windows-x86\mapi\shared-glapi;
- for 64-bit: .\mesa\build\windows-x86_64\mapi\shared-glapi.

Both shared libraries are named libglapi.dll. OpenGL ES 1.x drivers are named libGLESv1_CM.dll and OpenGL ES 2.0 and 3.0 drivers are named libGLESv2.dll.

Mesa swr drivers are dropped in.\mesa\build\windows-x86_64\gallium\drivers\swr.

[They only support 64-bit officially](https://bugs.freedesktop.org/show_bug.cgi?id=102564#c5). They are named swrAVX.dll and swrAVX2.dll after their instruction set requirements. You need both llvmpipe/softpipe and swr driver suitable to your CPU for swr to work. swr drivers are loaded when requested by llvmpipe/softpipe drivers. They can't run on their own.

Mesa3D off-screen rendering drivers are dropped in:
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
