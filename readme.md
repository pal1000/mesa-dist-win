# Table of Contents
- [Downloads](#downloads)
- [Known issues](#known-issues)
- [Differences between MSVC and MinGW packages](#differences-between-msvc-and-mingw-packages)
- [Mingw and MSVC Package contents](#mingw-and-msvc-package-contents)
- [Installation and usage](#installation-and-usage)
- [Legacy software compatibility](#legacy-software-compatibility)
- [OpenGL context configuration override](#opengl-context-configuration-override)
- [How to set environment variables](#how-to-set-environment-variables)
# Downloads
Mesa 21.0.3 builds with Visual Studio and MSYS2 Mingw-w64 are now available in [releases section](https://github.com/pal1000/mesa-dist-win/releases).
# Known issues
- 64-bit binaries in both MSVC and MinGW packages require a CPU with AVX even though they shouldn't

This is due to 64-bit binaries containing swr driver which leaks AVX usage into common code. This is an upstream bug reported [here](https://gitlab.freedesktop.org/mesa/mesa/-/issues/4437), [here](https://gitlab.freedesktop.org/mesa/mesa/-/issues/3860) and [here](https://github.com/msys2/MINGW-packages/issues/7530).
- Mesa `opengl32.dll` from MinGW package depends on [Vulkan runtime](https://vulkan.lunarg.com/sdk/home#windows) since 21.0.0

This is an [upstream regression](https://gitlab.freedesktop.org/mesa/mesa/-/issues/3855) introduced when zink driver was patched to support Windows.
- [zink driver cannot be tested with SwiftShader on Windows](https://gitlab.freedesktop.org/mesa/mesa/-/issues/4292)

`ZINK_USE_LAVAPIPE=true` doesn't work.
- Programs can behave like there is no OpenGL support when using Mesa `opengl32.dll` since 21.0.0

This is not a defect but rather a behavior change of Mesa when environment variables are misconfigured. It usually happens when selecting a Mesa driver that doesn't exist in release package used or it fails to initialize due to host system not meeting hardware requirements or lacking dependencies. Reading [differences between MSVC and MinGW packages](#differences-between-msvc-and-mingw-packages) and [Mingw and MSVC Package contents](#mingw-and-msvc-package-contents) should aid in troubleshooting.
- Important notes about errors related to missing `libglapi.dll`

You may experience them with programs that use any Mesa3D desktop OpenGL driver via per app deployment tool, system wide deployment is unaffected. You may experience them if shared glapi is missing from release package. shared glapi has been consistently available in both MSVC and MinGW packages since 20.0.2.

To correct these errors regardless of cause you have to re-deploy. If you don't remember if an affected program is 32-bit or 64-bit, right click on opengl32.dll shortcut in the folder where the program executable is located and select open file location. If location ends in x64 then it's 64-bit, otherwise it's 32-bit.

Same problem with same solution applies to osmesa if you are upgrading from 17.3.5.501-1 or older.
# Differences between MSVC and MinGW packages
- MinGW package requires a CPU with [SSSE3](https://en.wikipedia.org/wiki/SSSE3#CPUs_with_SSSE3) with benefit of providing 3-5% performance boost with software rendering drivers;
- MinGW package contains zink driver since 21.0.0 while MSVC package introduced GLonD3D12 at the same time;
- SPIR-V to DXIL tool introduced in 21.0.0 is only available in MSVC package;
- MinGW package uses ZSTD for certain compression tasks since 20.1.8.

If you need to migrate from Mingw to MSVC binaries you just need to replace Mesa binaries folder from Mingw package with MSVC counterpart.
# Mingw and MSVC Package contents
The following Mesa3D drivers and build artifacts are shipped in each release:
- [llvmpipe](https://www.mesa3d.org/llvmpipe.html). llvmpipe is a Desktop OpenGL software renderer intended as fallback when hardware acceleration is not possible. It can only handle very light gaming with good performance. This is the default Mesa3D desktop OpenGL driver when GLonD3D12 is either unavailable or fails to load. It's available for both x86 and x64 as part of Mesa3D Desktop OpenGL bundle `opengl32.dll`. When it's not the default driver select it by setting  environment variable `GALLIUM_DRIVER=llvmpipe`.
- softpipe is a reference implementation of a Desktop OpenGL software renderer with no focus towards gaming performance. It's available for both x86 and x64 as part of Mesa3D Desktop OpenGL bundle `opengl32.dll`. Select it by setting  environment variable `GALLIUM_DRIVER=softpipe`.
- [GLAPI shared library](https://www.mesa3d.org/egl.html). File name: libglapi.dll. When present in release package it's required by all Mesa3D OpenGL and OpenGL ES drivers. Since 20.0.2 it is available in both MSVC and MSYS2 Mingw-w64 packages.
- [GLonD3D12](https://docs.mesa3d.org/drivers/d3d12.html). It's available for both x86 and x64 as part of Mesa3D Desktop OpenGL bundle `opengl32.dll` and standalone as `openglon12.dll` and it's only available in MSVC package. In addition to officially requiring Windows 10 v10.0.19041.488 or newer, it also depends on DirectX IL for redistribution - `dxil.dll` to load, which can be installed via [deployment tools](#installation-and-usage). When available and if it can load, this is the default Mesa3D desktop OpenGL driver on D3D12 GPU accelerated systems. This driver introduced in 21.0.0 is operating as wrapper returning D3D12 API calls. Due to this nature it can use GPU accelleration. If it's not selected by default you can test it with Direct3D WARP software renderer built into Windows by setting `GALLIUM_DRIVER=d3d12` and `LIBGL_ALWAYS_SOFTWARE=1` environment variables. The standalone copy doesn't need `GALLIUM_DRIVER=d3d12` being set and it can only be installed via system-wide deployment tool. The standalone GLonD3D12 and Mesa3D Desktop OpenGL bundle replace each other when using system-wide deployment tool but you can reverse it any time. 
- [zink](https://docs.mesa3d.org/drivers/zink.html). This driver introduced for Windows in 21.0.0 it's available for both x86 and x64 as part of Mesa3D Desktop OpenGL bundle `opengl32.dll` and it's only available in MinGW package. Siimilarly to GLonD3D12, it operates as wrapper returning Vulkan API calls. Due to this nature it uses GPU accelleration. Select it via `GALLIUM_DRIVER=zink` environment variable, but note that it requires at least 1 Vulkan device and Vulkan loader/[runtime](https://vulkan.lunarg.com/sdk/home#windows) to initialize. zink ignores Vulkan CPU type devices, so you can't test it with SwiftShader.
- [swr](https://openswr.org/). File names: swrAVX.dll, swrAVX2.dll, swrSKX.dll, swrKNL.dll. Even though it resides outside of Mesa3D Desktop OpenGL bundle `opengl32.dll` it still depends on it. This alternative desktop OpenGL software rendering driver developed by Intel is optimized for visualization software. It's available in MSVC package and since 20.1.7 in MinGW package as well. It only supports x64, x86 is [officially unsupported](https://bugs.freedesktop.org/show_bug.cgi?id=102564#c5). There are currently 4 DLLs, only one being loaded based on what the user CPU can do. You can switch to swr by setting GALLIUM_DRIVER environment variable value to swr.
- [OpenGL ES standalone drivers](https://www.mesa3d.org/opengles.html). File names: libGLESv1_CM.dll and libGLESv2.dll. OpenGL ES 1.x, 2.x and 3.x standalone drivers available for 32-bit and 64-bit applications. Since 20.0.2 they are available in both MSVC and MSYS2 Mingw-w64 packages.
- lavapipe Vulkan CPU driver is available in both MSVC and MinGW packages since 21.1.0. Note that some programs may ignore Vulkan CPU type devices on purpose. Unlike OpenGL drivers, deployment for Vulkan drivers is done through [Vulkan runtime](https://vulkan.lunarg.com/sdk/home#windows) using [ICD discovery](https://github.com/KhronosGroup/Vulkan-Loader/blob/master/loader/LoaderAndLayerInterface.md#icd-discovery) method. Note that Vulkan runtime commes bundled with graphics drivers supporting Vulkan so manually installing it may not be necessary.
- [osmesa](https://www.mesa3d.org/osmesa.html). File name: osmesa.dll. Available for both x86 and x64. This driver is used in special cases by software that is designed to use Mesa code to render without any kind of window system or operating system dependency. Since 21.0.0 only osmesa gallium remained. It supports OpenGL 3.x and newer. Since 20.0.2 osmesa integration with standalone GLLES drivers is available in both MSVC and MSYS2 Mingw-w64 packages.
- graw. File names: graw.dll, graw_null.dll. This is Mesa3D plug-in library mainly used by unit tests. It is not a driver. Available for both x86 and x64 and in full (with window system support) and headless (no window) versions. This is used in special cases by software that is designed to use Mesa3D code internal APIs. Since 20.0.2 both full and headless versions are available in both MSVC and MSYS2 Mingw-w64 packages.
- SPIR-V to DXIL tool and library are only available in MSVC package since 21.0.0. File names: spirv_to_dxil.dll and spirv2dxil.exe.
- test suite. Many executable unit tests.
- libraries and headers generated at build time for both 32-bit and 64-bit builds are located in a separate archive called development pack. Note that build time generated headers depend on source code headers, so you may need Mesa3D source code because only build time headers are included.

Build instructions, if you want to replicate my builds, are available [here](https://github.com/pal1000/mesa-dist-win/tree/master/buildscript).
# Installation and usage
First choose between Mingw and MSVC package. See [About Mingw package](#about-mingw-package) section for details. Before [extracting](https://www.7-zip.org/) release package close all programs that use Mesa if any is running. After extraction you will have access to 2 deployment options, both located in the directory you installed Mesa. Both deployment utilities have a start-over mechanism so you can do all deployments you need in one session.
- A system-wide deployment tool. While intended for systems lacking hardware accelerated OpenGL support like virtual machines in cloud environments, it can also be used on any Windows system to replace the inbox software rendering OpenGL 1.1 driver extending OpenGL support for use cases where hardware accelerated OpenGL is not available like RDP connections. Due to potential issues with Virtualbox VMs running Windows it is recommended to disable 3D acceleration in such VMs if Mesa3D desktop OpenGL driver is installed inside them using the system-wide deployment tool, see [#9](https://github.com/pal1000/mesa-dist-win/issues/9).
- A per-application deployment tool, used to deploy Mesa3D for a single program regardless of hardware accelerated OpenGL support being present or not.
Per-app deployment utility changes are persistent and are being kept across upgrades and re-installations.
Per-app deployment utility helps you save storage and makes things easier as you won't have to manually copy DLLs from Mesa installation directory as it creates symbolic links to whatever Mesa drivers you opt-in to use.
This behavior ensures all programs that use Mesa use the same up-to-date version.
Per-app deployment utility asks for path to directory containing application executable, application executable filename (optional, it can remain blank but if specified can force some programs to use Mesa3D when they won't otherwise), if the app is 64-bit or 32-bit and the drivers you need.
32-bit applications have their names marked in Task Manager while running.
Most applications will use Mesa regardless of GPU capabilities, but some applications may be smart enough to load OpenGL from system directory only.
By providing the application filename, a .local file is generated in an attempt to force the application to use Mesa3D when it doesn't want to.
Also, [Federico Dossena](https://github.com/adolfintel)'s [Mesainjector](https://downloads.fdossena.com/Projects/Mesa3D/Injector/index.php) can be used to workaround this issue as well.
[Build instructions for Mesainjector](https://fdossena.com/?p=mesa/injector_build.frag).
### Usage notes
- Old applications from early 200x and older may need MESA_EXTENSION_MAX_YEAR environment variable set, see [legacy software compatibility section](#legacy-software-compatibility).
- Applications requiring OpenGL 3.2 or newer may need [OpenGL context configuration override](#opengl-context-configuration-override).

Examples on OpenGL context configuration override, switch to swr driver and old applications compatibility are available [here](https://github.com/pal1000/mesa-dist-win/tree/master/examples).
# Legacy software compatibility
Old applications from early 200x and older may need MESA_EXTENSION_MAX_YEAR environment variable set to avoid buffer overflows. It expects a year number as value, most commonly used being 2001. It trims the extensions list returned by Mesa3D to extensions released up to and including provided year as Mesa3D extensions list is sorted by year.

Ex: `set MESA_EXTENSION_MAX_YEAR=2001`. See [How to set environment variables](#how-to-set-environment-variables).
# OpenGL context configuration override
With release of [OpenGL 3.1](https://en.wikipedia.org/wiki/OpenGL#OpenGL_3.1) many features marked as deprecated in OpenGL 3.0 have been removed and since OpenGL 3.2 launch this OpenGL specification branch is known as OpenGL core profile. Also in OpenGL 3.3 a new branch of the OpenGL specification known as forward compatible context was introduced which removes the OpenGL 3.0 deprecated features that were not removed in OpenGL 3.1.
Most proprietary drivers implemented the exemptions from these changes offered in the form of GL_ARB_compatibility extension for OpenGL 3.1 and compatibility contexts for OpenGL 3.2 and above.
Due to complexity and especially lack of correct implementation tests for GL_ARB_compatibility and compatibility contexts, Mesa3D developers chose to retain features deprecated in OpenGL 3.0 and implement core profile and forward compatible contexts.
Mesa 18.1 introduced GL_ARB_compatibility support making the first step toward having compatibility contexts support in the future.
Because GL_ARB_compatibility is only for OpenGL 3.1, programs requesting OpenGL compatibility context won't get above OpenGL 3.0 for Mesa 18.0 and 3.1 for Mesa 18.1 and newer.
Unfortunately these kind of programs are prevalent on Windows where developers tend to avoid using context flags required by core profile.
Fortunately Mesa3D provides a mechanism to override the OpenGL context requested.
There are 2 environment variables that override OpenGL context configuration:
- MESA_GL_VERSION_OVERRIDE

It is used to specify OpenGL context version and type.
It expects a value in the following format

OpenGLMajorVersion.OpenGLMinorVersion{FC|COMPAT].

FC means a forward compatible context.
COMPAT means a compatibility context for OpenGL 3.2 and newer and GL_ARB_compatibility being enabled for OpenGL 3.1.
Absence of any string after version number means the Mesa3D default context type for OpenGL version specified which is as follows: deprecated features enabled for OpenGL 3.0, GL_ARB_compatibility enabled for OpenGL 3.1 since Mesa 18.1 and core profile for OpenGL 3.2 and above.
Examples: 3.3FC means OpenGL 3.3 forward compatible context, 3.1COMPAT means OpenGL 3.1 with GL_ARB_compatibility , 3.2 means OpenGL 3.2 core profile.
The default value is 3.1COMPAT for Mesa 18.1 and 3.0COMPAT for Mesa 18.0.

A very important feature provided by this variable is the possibility to configure an incomplete OpenGL context.
Programs can only request up to the highest OpenGL context with Khronos certification as complete from Mesa3D driver in use.
Currently llvmpipe is certified for OpenGL 4.5 in core profile / forward compatible context and 3.1 in compatibility profile. Currently swr is certified for OpenGL 3.3 in core profile / forward compatible context and 3.1 in compatibility profile.
Since Mesa 17.3 values meant for OpenGL 4.6 are recognized.

- MESA_GLSL_VERSION_OVERRIDE

Used to specify shading language version.
Supported values are version numbers converted to integer: 110, 120, 130, 140. 150, 330, 400, 410, 420, 430, 440, 450 and 460. Value 460 is only recognized since Mesa 17.3. Value 130 for example matches GLSL 1.30. It is always a good idea to keep OpenGL context and shading language versions in sync to avoid programs confusion which may result in crashes or glitches. This can happen because most applications rely on proprietary drivers behavior of having OpenGL and GLSL versions in sync. [Here](https://en.wikipedia.org/wiki/OpenGL_Shading_Language#Versions) is the OpenGL - GLSL correlation table.
Default values: 140 for Mesa 18.1 and 130 for Mesa 18.0 if MESA_GL_VERSION_OVERRIDE is undefined or 330 otherwise.
# How to set environment variables
Under Windows the easiest way to set environment variables is by writing batch files. You'll most likely need to do so:
- for every application requiring OpenGL 3.2 or newer in compatibility profile or 4.0 for swr and 4.6 for llvmpipe or newer in core profile;
- if you want to use swr instead of llvmpipe for desktop OpenGL;
- if you need to trim extensions list for old programs compatibility.

Simply open Notepad, write the batch script. When saving, end the file name with .bat or .cmd, change save as type to all files and change save location to where the application executable is located. If you have some skill with batch scripts you can change the current directory during script execution using CD command opening the possibility to save the script anywhere you want as shown in [rpcs3](https://github.com/pal1000/mesa-dist-win/blob/master/examples/rpcs3.cmd) and [GPU Caps Viewer](https://github.com/pal1000/mesa-dist-win/blob/master/examples/GPUCapsViewer.cmd) examples.
Documentation of most environment variables used by Mesa is available [here](https://docs.mesa3d.org/envvars.html).
Complete examples are available [here](https://github.com/pal1000/mesa-dist-win/tree/master/examples).

You can set multiple environment variables on same batch script to mix the functionality provided by Mesa3D.
