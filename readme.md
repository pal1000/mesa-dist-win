**Table of Contents**

- [Downloads](#downloads)
- [Package contents](#package-contents)
- [Installation and usage](#installation-and-usage)
- [OpenGL context configuration override](#opengl-context-configuration-override)
  
# Downloads
Mesa 18.1.0 builds are now available in [releases section](https://github.com/pal1000/mesa-dist-win/releases)

# Package contents
The following Mesa3D drivers are shipped in each release:
- [llvmpipe](https://www.mesa3d.org/llvmpipe.html) and softpipe bundle. file name: opengl32.dll. llvmpipe is the default desktop OpenGL driver. Both llvmpipe and softpipe are available for both x86 and x64. softpipe can be selected by setting environment variable GALLIUM_DRIVER=softpipe.
- [swr](http://openswr.org/). File names: swrAVX.dll, swrAVX2.dll. An alternative desktop OpenGL driver developed by Intel.  Available for x64 only, x86 is [officially unsupported](https://bugs.freedesktop.org/show_bug.cgi?id=102564#c5). There are currently 2 DLLs, only one being loaded based on what the user CPU can do. 2 more will join soon matching the existing flavors of AVX512 instruction set, see issue [#2](https://github.com/pal1000/mesa-dist-win/issues/2). By default Mesa uses llvmpipe. You can switch to swr by setting GALLIUM_DRIVER environment variable value to swr either globally or in a batch file. See [How to set environment variables](#how-to-set-environment-variables).
- [osmesa](https://www.mesa3d.org/osmesa.html). File name: osmesa.dll. 2 versions of osmesa, off-screen rendering driver. They are located in osmesa-gallium and osmesa-swrast subdirectories. Available for both x86 and x64. This driver is used in special cases by software that is designed to use Mesa code to render without any kind of window system or operating system dependency. osmesa gallium supports OpenGL 3.x and newer while osmesa swrast also known as osmesa classic only supports OpenGL 2.1 but it has some unique capabilities.
- graw. File name: graw.dll. This is Mesa3D plug-in library. It is not a driver. Available for both x86 and x64. This is used in special cases by software that is designed to use Mesa code. While Mesa includes a full version bearing the build target of graw-gdi and a headless version bearing the build target of graw-null, only the full version is included. The headless version can be easily added upon request in a later release. 

Build instructions, if you want to replicate my builds, are available [here](https://github.com/pal1000/mesa-dist-win/tree/master/buildscript).

# Installation and usage
Before running the installer close all programs that use Mesa if any is running. After running the installer you will have access to 2 deployment options, both located in the directory you installed Mesa. Both deployment utilities have a start-over mechanism so you can do all deployments you need in one session.
- A system-wide deployment tool. While intended for systems lacking hardware accelerated OpenGL support like virtual machines in cloud environments, it can also be used on any Windows system to replace the inbox software rendering OpenGL 1.1 driver extending OpenGL support for use cases where hardware accelerated OpenGL is not available like RDP connections.
- A per-application deployment tool. You only need to use it for programs you didn't deploy Mesa before as the per-app deployment utility changes persist across upgrades and re-installations. The per-app deployment utility helps you save storage and makes things easier as you won't have to manually copy DLLs from Mesa installation directory as it creates symbolic links to whatever Mesa drivers you opt-in to use. This behavior ensures all programs that use Mesa use the same up-to-date version. Per-app deployment utility only asks for path to directory containing application executable, if the app is 64-bit or 32-bit and the drivers you need. 32-bit applications have their names marked in Task Manager while running. Most applications will use mesa regardless of GPU capabilities, but some applications may be smart enough to load OpenGL from system directory only. Use [Federico Dossena](https://github.com/adolfintel)'s Mesainjector to workaround this issue: [Build guide](http://fdossena.com/?p=mesa/injector_build.frag), [VMWare ThinApp capture](http://fdossena.com/mesa/MesaInjector_Capture.7z). Upgrade from 17.3.5.501-1 and older versions breaks osmesa drivers deployments made with per-app deployment tool. You'll have to redo the osmesa deployments.

Since v17.0.1.391 in-place upgrade is fully supported. Since v17.0.1.391-2 S3 texture compression is supported. v17.0.4.391-1 requires uninstall of previous versions. Applications requiring OpenGL 3.2 or newer may need [OpenGL context configuration override](#opengl-context-configuration-override).

# OpenGL context configuration override
With release of [OpenGL 3.1](https://en.wikipedia.org/wiki/OpenGL#OpenGL_3.1) many features marked as deprecated in OpenGL 3.0 have been removed and since OpenGL 3.2 launch this OpenGL specification branch is known as OpenGL Core profile. Also in OpenGL 3.3 a new branch of the OpenGL specification known as forward compatible context was introduced which removes the OpenGL 3.0 deprecated features that were not removed in OpenGL 3.1. Most proprietary drivers implemented the exemptions from these changes offered in the form of GL_ARB_compatibility extension for OpenGL 3.1 and compatibility contexts for OpenGL 3.2 and above. Due to complexity and especially lack of correct implementation tests for GL_ARB_compatibility and compatibility contexts, Mesa3D developers chose to retain features deprecated in OpenGL 3.0 and implement Core profile and forward compatible contexts down to OpenGL 3.0. Mesa 18.1 introduced GL_ARB_compatibility support making the first step toward having compatibility contexts support in the future. Because GL_ARB_compatibility is only for OpenGL 3.1, programs requesting OpenGL compatibility context won't get above OpenGL 3.0 for Mesa 18.0 and 3.1 for Mesa 18.1. Unfortunately these kind of programs are prevalent on Windows where developers tend to avoid using context flags required by Core profile. Fortunately Mesa3D provides a mechanism to override the OpenGL context requested. There are 2 environment variables that override OpenGL context configuration:
- MESA_GL_VERSION_OVERRIDE

It is used to specify OpenGL context version and type.
It expects a value in the following format

OpenGLMajorVersion.OpenGLMinorVersion{FC|COMPAT].

FC means a forward compatible context. COMPAT means a compatibility context for OpenGL 3.2 and newer and GL_ARB_compatibility being available for OpenGL 3.1. Absence of any string after version number means the Mesa3D default context type for OpenGL version specified which is as follows: deprecated features enabled for OpenGL 3.0, GL_ARB_compatibility enabled for OpenGL 3.1 since Mesa 18.1 and Core profile for OpenGL 3.2 and above. Examples: 3.3FC means OpenGL 3.3 forward compatible context, 3.1COMPAT means OpenGL 3.1 compatibility context or to be more accurate OpenGL 3.1 with GL_ARB_compatibility , 3.2 means OpenGL 3.2 core profile. The default value is 3.1COMPAT for Mesa 18.1 and 3.1 for Mesa 18.0.

A very important feature provided by this variable is the possibility to configure an incomplete OpenGL context. Programs can only request up to the highest OpenGL context with Khronos certification as complete from Mesa3D driver in use. Currently both llvmpipe and swr are certified for OpenGL 3.3, yet the rpcs3 context configuration sample uses OpenGL 4.3 and it works. This is because despite the context not being complete, the required extensions by rpcs3 are in place. Since Mesa 17.3 values meant for OpenGL 4.6 are recognized.

- MESA_GLSL_VERSION_OVERRIDE

Used to specify shading language version.
Supported values are version numbers converted to integer: 110, 120, 130, 140. 150, 330, 400, 410, 420, 430, 440, 450 and 460. Value 460 is only recognized since Mesa 17.3. Value 130 for example matches GLSL 1.30. It is always a good idea to keep OpenGL context and shading language versions in sync to avoid programs confusion which may result in crashes or glitches. This can happen because most applications rely on proprietary drivers behavior of having OpenGL and GLSL versions in sync. [Here](https://en.wikipedia.org/wiki/OpenGL_Shading_Language#Versions) is the OpenGL - GLSL correlation table.
Default values: 140 for Mesa 18.1 and 130 for Mesa 18.0 if MESA_GL_VERSION_OVERRIDE is undefined or 330 otherwise.

# How to set environment variables
Under Windows the easiest way to set environment variables is by writing batch files for every application requiring OpenGL 3.2 or newer that is using Mesa or if your want to use swr instead of llvmpipe for Desktop OpenGL.
Simply open Notepad, write the batch script. When saving, end the file name with .bat or .cmd, change save as type to all files and change save location to where the application executable is located. If you have some skill with batch scripts you can change the current directory during script execution using CD command opening the possibility to save the script anywhere you want as shown in [rpcs3](https://github.com/pal1000/mesa-dist-win/blob/master/examples/rpcs3.cmd) and [GPU Caps Viewer](https://github.com/pal1000/mesa-dist-win/blob/master/examples/GPUCapsViewer.cmd) examples.
Documentation of most environment variables used by Mesa is available [here](https://mesa3d.org/envvars.html).
Complete examples are available [here](https://github.com/pal1000/mesa-dist-win/tree/master/examples).

There no conflict between GALLIUM_DRIVER variable used to change the desktop OpenGL driver and OpenGL context configuration override. You can mix them if necessary.
