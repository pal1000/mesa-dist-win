Usage guidelines for build.cmd
------------------------------
1. Acquire mesa source code, dependencies and build tools
--------------------------------------------------------
-Visual Studio Community (at this moment Visual Studio 2013 and 2015 are supported, 2015 recommended).
Only C/C++ compiler and libraries targeting Win32 API are needed.
-Mesa source code: ftp://ftp.freedesktop.org/pub/mesa/
-LLVM source code: http://llvm.org/
To build Mesa 13 you have to use LLVM 3.7.1. Newer versions don't work because Mesa attempts to link against the removed 
llvmipa.lib see: 
https://www.phoronix.com/forums/forum/linux-graphics-x-org-drivers/opengl-vulkan-mesa-gallium3d/28305-compiling-mesa-with-llvm-on-x86_64-in-windows-7
-CMake 32 and 64 bit: https://cmake.org/download/#latest
The installer automatically sets the PATH for you. But beware if you want to build for both x86 and x64 you will end up with
duplicate entry in PATH. You definitely want to avoid this. I recommend use the zipped version and let build.cmd set PATH
at runtime.
-Flex and Bison: https://sourceforge.net/projects/winflexbison/
-m4:
32-bit: https://sourceforge.net/projects/msys2/files/REPOS/MSYS2/i686/
64-bit: https://sourceforge.net/projects/msys2/files/REPOS/MSYS2/x86_64/
Just search for it in these huge pages. Your web browser might freeze for a bit. Your need 7-Zip to extract linux archives
in which m4 is compressed.
-Python 32 and 64 bit: https://www.python.org/
Use Python 2.7. Python 3.x is not supported by Scons. Make sure pip is installed. Sometimes it isn't. If it isn't get it 
from here: https://pip.pypa.io/en/stable/installing/
-pywin32 for Python 32 and 64 bit: https://sourceforge.net/projects/pywin32/files/
-Scons for python: https://sourceforge.net/projects/scons/files/scons/
DO NOT use Scons 2.5.0. It doesn't work as it shipped incomplete:
https://bitbucket.org/scons/scons/raw/8d7fac5a5e9c9a1de4b81769c7c8c0032c82a9aa/src/CHANGES.txt
-mako module for Python 32 and 64 bit. Install with pip install mako. build.cmd installs mako automatically. It also 
attempts to update all Python modules. 

2. Setting environment variables and prepare the build
------------------------------------------------------
You need to add the location of the following components to PATH:
-flex and bison;
-m4;
-Python;
-CMake.
build.cmd script automates this whole process but you must respect the relative paths between the script and the sources and
tools. You must provide Visual Studio installation folder via vstudio variable and Visual Studio generator code name to 
CMake via toolchain variable in the script. They are currently set to default values for Visual Studio 2015.
You can find out the generator code name by running CMake --help to Command Prompt. 
Assuming the script is located in current folder "." then each tool and code sources must be located as follows:
-m4 32-bit: .\projects\mesa\m4\x86;
-m4 64-bit: .\projects\mesa\m4\x64;
-CMake 32-bit: .\projects\mesa\cmake\x86;
-CMake 64-bit: .\projects\mesa\cmake\x64;
-Python 32-bit: .\projects\mesa\Python\x86;
-Python 64-bit: .\projects\mesa\Python\x64;
-Flex and bison: .\projects\mesa\flexbison;
-LLVM source code: .\projects\mesa\llvm;
-Mesa source code: .\projects\mesa\mesa.
This way the script would be able to set PATH variable correctly and you'll no longer need to set anything from this point 
forward.

3. Build process
----------------
The script acts like a Wizard asking for the following during execution:
-architecture for which you want to build mesa - eg. x86 or x64;
-if you want to build LLVM. LLVM build takes a long time, about 1h30m, fortunately you only need to do it once for each
architecture you target when new version is out and this doesn't happen very often;
-if you want to build mesa or quit. After mesa build completes, because scons closes Command prompt on finish I run it via 
"cmd /k", so after the script completes you are returned to Command Prompt.

4.Miscelaneous and build location
---------------------------------
CMake build system is created in:
-32 bit: .\projects\mesa\llvm\cmake-x86;
-64-bit: .\projects\mesa\llvm\cmake-x64.
Mesa llvmpipe and softpipe drivers are dropped in:
-32-bit: .\projects\mesa\mesa\build\windows-x86\gallium\targets\libgl-gdi
-64-bit: .\projects\mesa\mesa\build\windows-x86_64\gallium\targets\libgl-gdi
and are both named opengl32.dll.