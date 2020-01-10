# Table of Contents
- [Downloads](#downloads)
- [Note for enterprise environments](#note-for-enterprise-environments)
- [About Mingw package](#about-mingw-package)
- [Mingw and MSVC Package contents](#mingw-and-msvc-package-contents)
- [Installation and usage](#installation-and-usage)
- [Legacy software compatibility](#legacy-software-compatibility)
- [OpenGL context configuration override](#opengl-context-configuration-override)
- [How to set environment variables](#how-to-set-environment-variables)
# Downloads
Mesa 19.3.2 builds with Visual Studio and MSYS2 Mingw-w64 are now available in [releases section](https://github.com/pal1000/mesa-dist-win/releases).
# Note for enterprise environments
IT security policy may restrict or even outright prohibit running 3rd-party unsigned executables. If this is the case you can extract Mesa3D drivers using [7-Zip](https://www.7-zip.org/).
# About Mingw package
Mingw package is recommended in most cases over MSVC as it has better performance but it also has some caveats:
- it requires a CPU with [SSSE3](https://en.wikipedia.org/wiki/SSSE3#CPUs_with_SSSE3);
- swr driver is not available due to build failure see [1](https://gitlab.freedesktop.org/mesa/mesa/merge_requests/362#note_130059) and [2](https://ci.appveyor.com/project/Alexpux/mingw-packages/builds/23168385/job/xx1p90m245mmhgkk);
- test suite and standalone OpenGL ES drivers won't be available until switch to Meson build which is blocked by [this issue](https://gitlab.freedesktop.org/mesa/mesa/issues/2012).

If you need to migrate from Mingw to MSVC binaries you have to make sure you replace `opengl32.dll` from Mingw package with MSVC counterpart otherwise swr driver won't load even if you set `GALLIUM_DRIVER=swr`.
# Mingw and MSVC Package contents
The following Mesa3D drivers and build artifacts are shipped in each release:
- [llvmpipe](https://www.mesa3d.org/llvmpipe.html) and softpipe bundle. File name: opengl32.dll. llvmpipe is the default desktop OpenGL driver. Both llvmpipe and softpipe are available for both x86 and x64. softpipe can be selected by setting environment variable GALLIUM_DRIVER=softpipe.
- [GLAPI shared library](https://www.mesa3d.org/egl.html). It is currently available only for MSVC binaries since Mesa3D 19.3.0 when it was brought back thanks to switch to Meson build. It was removed from Scons build in 18.3.0 due to problems with osmesa build in this configuration, see [this commit](https://gitlab.freedesktop.org/mesa/mesa/commit/45bacc4b63d83447c144d14cb075eaf7a458c429). File name: libglapi.dll. Required by llvmpipe, softpipe and swr if Mesa3D is built with shared glapi.
- [swr](http://openswr.org/). File names: swrAVX.dll, swrAVX2.dll, swrSKX.dll, swrKNL.dll. An alternative desktop OpenGL driver developed by Intel.  Available only in MSVC package and only for x64, x86 is [officially unsupported](https://bugs.freedesktop.org/show_bug.cgi?id=102564#c5). There are currently 4 DLLs, only one being loaded based on what the user CPU can do. By default Mesa uses llvmpipe. You can switch to swr by setting GALLIUM_DRIVER environment variable value to swr either globally or in a batch file. See [How to set environment variables](#how-to-set-environment-variables).
- [OpenGL ES standalone drivers](https://www.mesa3d.org/opengles.html). These drivers are currently only available for MSVC binaries since Mesa3D 19.3.0 when they were brought back thanks to switch to Meson build. They were removed from Scons build since Mesa 18.3 due to support being suspended upstream for same reason as for shared glapi which they depend on. File names: libGLESv1_CM.dll and libGLESv2.dll. OpenGL ES 1.x, 2.0 and 3.0 standalone drivers available for 32-bit and 64-bit applications.
- [osmesa](https://www.mesa3d.org/osmesa.html). File name: osmesa.dll. 2 versions of osmesa, off-screen rendering driver. They are located in osmesa-gallium and osmesa-swrast subdirectories. Available for both x86 and x64. This driver is used in special cases by software that is designed to use Mesa code to render without any kind of window system or operating system dependency. osmesa gallium supports OpenGL 3.x and newer while osmesa swrast also known as osmesa classic only supports OpenGL 2.1 but it has some unique capabilities. osmesa integration with standalone GLLES drivers is currently available only for MSVC binaries since Mesa3D 19.3.0 when it was brought back thanks to switch to Meson build. It was removed from Scons build in 18.3.0 due to [build issues]((https://bugs.freedesktop.org/show_bug.cgi?id=106843) which may impact integration with softpipe, llvmpipe and swr.
- graw. File names: graw.dll, graw_null.dll. This is Mesa3D plug-in library. It is not a driver. Available for both x86 and x64. This is used in special cases by software that is designed to use Mesa3D code internal APIs. While Mesa3D includes both a full version and a headless version, headless version is available only for MSVC binaries since Mesa3D 19.3.0 thanks to switch to Meson build.
- test suite. Many executable tests added thanks to MSVC binaries switch to Meson build in Mesa3D 19.3.0.
- libraries and headers generated at build time for both 32-bit and 64-bit builds are in a separate archive called development pack. Note that build time generated headers depend on source code headers, so you may need Mesa3D source code because only build time headers are included.

Build instructions, if you want to replicate my builds, are available [here](https://github.com/pal1000/mesa-dist-win/tree/master/buildscript).
# Installation and usage
First choose between Mingw and MSVC package. See [About Mingw package](#about-mingw-package) section for details. Before extracting release package close all programs that use Mesa if any is running. After extraction you will have access to 2 deployment options, both located in the directory you installed Mesa. Both deployment utilities have a start-over mechanism so you can do all deployments you need in one session.
- A system-wide deployment tool. While intended for systems lacking hardware accelerated OpenGL support like virtual machines in cloud environments, it can also be used on any Windows system to replace the inbox software rendering OpenGL 1.1 driver extending OpenGL support for use cases where hardware accelerated OpenGL is not available like RDP connections. Due to potential issues with Virtualbox VMs running Windows it is recommended to disable 3D acceleration in such VMs if Mesa3D desktop OpenGL driver is installed inside them using the system-wide deployment tool, see [#9](https://github.com/pal1000/mesa-dist-win/issues/9).
- A per-application deployment tool, used to deploy Mesa3D for a single program regardless of hardware accelerated OpenGL support being present or not.
Per-app deployment utility changes are persistent and are being kept across upgrades and re-installations.
Per-app deployment utility helps you save storage and makes things easier as you won't have to manually copy DLLs from Mesa installation directory as it creates symbolic links to whatever Mesa drivers you opt-in to use.
This behavior ensures all programs that use Mesa use the same up-to-date version.
Per-app deployment utility only asks for path to directory containing application executable, application executable filename (optional, it can remain blank but if specified can force some programs to use Mesa3D when they won't otherwise), if the app is 64-bit or 32-bit and the drivers you need.
32-bit applications have their names marked in Task Manager while running.
Most applications will use Mesa regardless of GPU capabilities, but some applications may be smart enough to load OpenGL from system directory only.
By providing the application filename, a .local file is generated in an attempt to force the application to use Mesa3D when it doesn't want to.
Also, [Federico Dossena](https://github.com/adolfintel)'s [Mesainjector](http://downloads.fdossena.com/Projects/Mesa3D/Injector/index.php) can be used to workaround this issue as well.
[Build instructions for Mesainjector](http://fdossena.com/?p=mesa/injector_build.frag).
### Important notes about errors related to missing `libglapi.dll`
You may experience them with programs that use any Mesa3D desktop OpenGL driver via per app deployment tool, system wide deployment is unaffected. You may experience them under following circumstances:
- when using Mesa3D 19.3.0 and you switch from Mingw release package to MSVC release package;
- when updating from a release that isn't between 18.1.2.600-1 and 18.2.6.

To correct them regardless of cause you have to re-deploy. If you don't remember if an affected program is 32-bit or 64-bit, right click on opengl32.dll shortcut in the folder where the program executable is located and select open file location. If location ends in x64 then it's 64-bit otherwise it's 32-bit.
Same problem with same solution applies to osmesa if you are upgrading from 17.3.5.501-1 or older.
### Usage notes
- Old applications from early 200x and older may need MESA_EXTENSION_MAX_YEAR environment variable set, see [legacy software compatibility section](#legacy-software-compatibility).
- Applications requiring OpenGL 3.2 or newer may need [OpenGL context configuration override](#opengl-context-configuration-override).
# Legacy software compatibility
Old applications from early 200x and older may need MESA_EXTENSION_MAX_YEAR environment variable set to avoid buffer overflows. It expects a year number as value, most commonly used being 2001. It trims the extensions list returned by Mesa3D to extensions released up to and including provided year as Mesa3D extensions list is sorted by year.

Ex: `set MESA_EXTENSION_MAX_YEAR=2001`. See [How to set environment variables](#how-to-set-environment-variables).
# OpenGL context configuration override
With release of [OpenGL 3.1](https://en.wikipedia.org/wiki/OpenGL#OpenGL_3.1) many features marked as deprecated in OpenGL 3.0 have been removed and since OpenGL 3.2 launch this OpenGL specification branch is known as OpenGL Core profile. Also in OpenGL 3.3 a new branch of the OpenGL specification known as forward compatible context was introduced which removes the OpenGL 3.0 deprecated features that were not removed in OpenGL 3.1.
Most proprietary drivers implemented the exemptions from these changes offered in the form of GL_ARB_compatibility extension for OpenGL 3.1 and compatibility contexts for OpenGL 3.2 and above.
Due to complexity and especially lack of correct implementation tests for GL_ARB_compatibility and compatibility contexts, Mesa3D developers chose to retain features deprecated in OpenGL 3.0 and implement Core profile and forward compatible contexts.
Mesa 18.1 introduced GL_ARB_compatibility support making the first step toward having compatibility contexts support in the future.
Because GL_ARB_compatibility is only for OpenGL 3.1, programs requesting OpenGL compatibility context won't get above OpenGL 3.0 for Mesa 18.0 and 3.1 for Mesa 18.1.
Unfortunately these kind of programs are prevalent on Windows where developers tend to avoid using context flags required by Core profile.
Fortunately Mesa3D provides a mechanism to override the OpenGL context requested.
There are 2 environment variables that override OpenGL context configuration:
- MESA_GL_VERSION_OVERRIDE

It is used to specify OpenGL context version and type.
It expects a value in the following format

OpenGLMajorVersion.OpenGLMinorVersion{FC|COMPAT].

FC means a forward compatible context.
COMPAT means a compatibility context for OpenGL 3.2 and newer and GL_ARB_compatibility being available for OpenGL 3.1.
Absence of any string after version number means the Mesa3D default context type for OpenGL version specified which is as follows: deprecated features enabled for OpenGL 3.0, GL_ARB_compatibility enabled for OpenGL 3.1 since Mesa 18.1 and Core profile for OpenGL 3.2 and above.
Examples: 3.3FC means OpenGL 3.3 forward compatible context, 3.1COMPAT means OpenGL 3.1 compatibility context or to be more accurate OpenGL 3.1 with GL_ARB_compatibility , 3.2 means OpenGL 3.2 core profile.
The default value is 3.1COMPAT for Mesa 18.1 and 3.0COMPAT for Mesa 18.0.

A very important feature provided by this variable is the possibility to configure an incomplete OpenGL context.
Programs can only request up to the highest OpenGL context with Khronos certification as complete from Mesa3D driver in use.
Currently both llvmpipe and swr are certified for OpenGL 3.3, yet the rpcs3 context configuration sample uses OpenGL 4.3 and it works.
This is because despite the context not being complete, the required extensions by rpcs3 are in place.
Since Mesa 17.3 values meant for OpenGL 4.6 are recognized.

- MESA_GLSL_VERSION_OVERRIDE

Used to specify shading language version.
Supported values are version numbers converted to integer: 110, 120, 130, 140. 150, 330, 400, 410, 420, 430, 440, 450 and 460. Value 460 is only recognized since Mesa 17.3. Value 130 for example matches GLSL 1.30. It is always a good idea to keep OpenGL context and shading language versions in sync to avoid programs confusion which may result in crashes or glitches. This can happen because most applications rely on proprietary drivers behavior of having OpenGL and GLSL versions in sync. [Here](https://en.wikipedia.org/wiki/OpenGL_Shading_Language#Versions) is the OpenGL - GLSL correlation table.
Default values: 140 for Mesa 18.1 and 130 for Mesa 18.0 if MESA_GL_VERSION_OVERRIDE is undefined or 330 otherwise.
# How to set environment variables
Under Windows the easiest way to set environment variables is by writing batch files. You'll most likely need to do so:
- for every application requiring OpenGL 3.2 or newer in compatibility profile or 4.0 or newer in core profile;
- if your want to use swr instead of llvmpipe for desktop OpenGL;
- if you need to trim extensions list for old programs compatibility.

Simply open Notepad, write the batch script. When saving, end the file name with .bat or .cmd, change save as type to all files and change save location to where the application executable is located. If you have some skill with batch scripts you can change the current directory during script execution using CD command opening the possibility to save the script anywhere you want as shown in [rpcs3](https://github.com/pal1000/mesa-dist-win/blob/master/examples/rpcs3.cmd) and [GPU Caps Viewer](https://github.com/pal1000/mesa-dist-win/blob/master/examples/GPUCapsViewer.cmd) examples.
Documentation of most environment variables used by Mesa is available [here](https://mesa3d.org/envvars.html).
Complete examples are available [here](https://github.com/pal1000/mesa-dist-win/tree/master/examples).

You can set multiple environment variables on same batch script to mix the functionality provided by Mesa3D.
