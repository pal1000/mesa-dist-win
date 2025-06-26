# Table of Contents
- [Downloads](#downloads)
- [Sponsorship](#sponsorship)
- [Known issues](#known-issues)
- [Differences between MSVC and MinGW packages](#differences-between-msvc-and-mingw-packages)
- [Mingw and MSVC Package contents](#mingw-and-msvc-package-contents)
  - [OpenGL and OpenGL ES common shared libraries](#opengl-and-opengl-es-common-shared-libraries)
  - [Microsoft CLonD3D12, GLonD3D12, Dozen Vulkan driver and D3D12 VA-API common dependency](#microsoft-clond3d12-glond3d12-dozen-vulkan-driver-and-d3d12-va-api-common-dependency)
  - [Desktop OpenGL drivers](#desktop-opengl-drivers)
  - [OpenGL off-screen rendering driver](#opengl-off-screen-rendering-driver)
  - [OpenGL ES drivers and EGL library](#opengl-es-drivers-and-egl-library)
  - [Vulkan drivers](#vulkan-drivers)
  - [OpenCL drivers, compilers and backends](#opencl-drivers-compilers-and-backends)
  - [Direct3D drivers, libraries and tools](#direct3d-drivers-libraries-and-tools)
  - [VA-API drivers](#va-api-drivers)
  - [Testing library and tools](#testing-library-and-tools)
  - [Development packages](#development-packages)
  - [Debug packages](#debug-packages)
- [Build Mesa3D yourself](#build-mesa3d-yourself)
- [Installation and usage](#installation-and-usage)
  - [Usage notes](#usage-notes)
- [Uninstall Mesa3D](#uninstall-mesa3d)
- [Legacy software compatibility](#legacy-software-compatibility)
- [OpenGL context configuration override](#opengl-context-configuration-override)
- [How to set environment variables](#how-to-set-environment-variables)
# Downloads
Mesa 25.1.4 builds with Visual Studio and MSYS2 Mingw-w64 are now available in [releases section](https://github.com/pal1000/mesa-dist-win/releases).
# Sponsorship
mesa-dist-win project was given a sponsorship that was extended until November 1st 2024. Sponsorship consists in a free VPS on French node to use as build machine with 12 GB RAM, 6 threads [AMD EPYC 7763](https://www.amd.com/en/products/cpu/amd-epyc-7763) and 150 GB NVMe SSD from [Petrosky](https://petrosky.io/pal1000), a virtual private server hosting company thanks to [@Directox01](https://github.com/Directox01).

![sponsorship-petrosky-2025](https://github.com/user-attachments/assets/86b9856c-6b98-452c-947d-5cd8843981a6)
![Screenshot_20221205_065713](https://user-images.githubusercontent.com/1138235/205717369-21062d47-7c66-4e6a-8427-6560f9aeaaf7.png)
# Known issues
This is a list of all comonly encountered issues with known solutions or workarounds. A specific release is only affected by a subset of them.
- `libgallium_wgl.dll` missing error with Mesa3D OpenGL ES and desktop OpenGL drivers

This is encountered with existing per application deployments made with 21.2.x or older when updating to 21.3.0 or newer. Just redo per app deployment to fix it. Gallium megadriver separation from `opengl32.dll` was a very invasive change that existing per app deployments didn't stand a chance against. If you don't remember if an affected program is 32-bit or 64-bit, right click on `opengl32.dll` shortcut in the folder where the program executable is located and select open file location. If location ends in x64 then it's 64-bit, otherwise it's 32-bit.
- `libEGL.dll` missing error with Mesa3D OpenGL ES

This is encountered with existing per application deployments made with 21.2.x or older when updating to 21.3.0 or newer. Just redo per app deployment to fix it. The EGL support was a very invasive change that existing per app deployments didn't stand a chance against. If you don't remember if an affected program is 32-bit or 64-bit, right click on `opengl32.dll` shortcut in the folder where the program executable is located and select open file location. If location ends in x64 then it's 64-bit, otherwise it's 32-bit.
- `libvulkan-1.dll` missing error with Mesa3D `opengl32.dll` from MinGW release package

Only releases prior to 22.2.0 for which zink driver was built with MSYS2 MinGW-W64 vulkan-devel package group are affected. Run `fix-libvulkan-1.dll-missing-error.cmd` from MinGW release package to correct it. This tool supports unattended execution via `auto` command line option. This tool is only bundled in MinGW release package when needed otherwise it's intentionally missing. The decision to use this Vulkan SDK over LunarG's is done based on which comes with newer loader and headers.
- 64-bit binaries in both MSVC and MinGW packages require a CPU with AVX even though they shouldn't

This is no longer an issue as of Mesa 22.0 or newer. This issue is caused by 64-bit binaries containing swr driver which leaks AVX usage into common code. This is an upstream bug reported [here](https://gitlab.freedesktop.org/mesa/mesa/-/issues/4437), [here](https://gitlab.freedesktop.org/mesa/mesa/-/issues/3860) and [here](https://github.com/msys2/MINGW-packages/issues/7530).
- Mesa `opengl32.dll` from MinGW package depends on [Vulkan runtime](https://vulkan.lunarg.com/sdk/home#windows) since 21.0.0

 This was fixed in 22.2.0 by containing this requirement to zink driver explicit usage. This is an [upstream regression](https://gitlab.freedesktop.org/mesa/mesa/-/issues/3855) introduced when zink driver was patched to support Windows.
- Programs can behave like there is no OpenGL support when using Mesa `opengl32.dll` since 21.0.0

This is not a defect but rather a behavior change of Mesa when environment variables are misconfigured. It usually happens when selecting a Mesa driver that doesn't exist in release package used or it fails to initialize due to host system not meeting hardware requirements or lacking dependencies. Reading [differences between MSVC and MinGW packages](#differences-between-msvc-and-mingw-packages) and [Mingw and MSVC Package contents](#mingw-and-msvc-package-contents) should aid in troubleshooting.
- Important notes about errors related to missing `libglapi.dll`

You may experience them with programs that use any Mesa3D desktop OpenGL driver via per app deployment tool, system wide deployment is unaffected. You may experience them if per app deployment was done before shared glapi support was introduced. shared glapi has been consistently available in both MSVC and MinGW packages between 20.0.2 and 24.3.4.

To correct these errors regardless of cause you have to re-deploy. If you don't remember if an affected program is 32-bit or 64-bit, right click on `opengl32.dll` shortcut in the folder where the program executable is located and select open file location. If location ends in x64 then it's 64-bit, otherwise it's 32-bit.

Same problem with same solution applies to osmesa if you are upgrading from 17.3.5.501-1 or older.
# Differences between MSVC and MinGW packages
- MinGW package requires a CPU with [SSSE3](https://en.wikipedia.org/wiki/SSSE3#CPUs_with_SSSE3) with benefit of providing 3-5% performance boost with software rendering drivers;
- d3d10sw introduced in 21.2.0 is only available in MSVC package;
- Support for x86 32-bit build in MinGW has been restored but without LLVM support to workaround [#156](https://github.com/pal1000/mesa-dist-win/issues/156) so no openclon12, llvmpipe or lavapipe and performance is much lower in osmesa and for software fallback emulated features aka. NIR lowering in zink and d3d12 (both OpenGL and VA-API).
.

If you need to migrate from Mingw to MSVC binaries you just need to replace Mesa binaries folder from Mingw package with MSVC counterpart.
# Mingw and MSVC Package contents
The following Mesa3D drivers and build artifacts are shipped in each release:
### OpenGL and OpenGL ES common shared libraries
- GLAPI shared library. File name: `libglapi.dll`. Removed an no longer needed since 25.0.0. Its presence was required when providing both OpenGL and OpenGL ES support. Mesa3D off-screen renderer and all Mesa3D OpenGL and OpenGL ES drivers depended on it when present. Between 20.0.2 and 24.3.4 it was available in both MSVC and MSYS2 Mingw-w64 packages.
- Gallium OpenGL megadriver. File name: `libgallium_wgl.dll`. When present it contains all Mesa3D desktop OpenGL drivers instead of `opengl32.dll`. It debuted in 21.3.0. Mesa3D EGL library and OpenGL ES drivers depend on it when present.
- Mesa3D WGL runtime. File name: `opengl32.dll`. This used to contain all Mesa3D desktop OpenGL drivers and OpenGL ES depended on it, but since 21.3.0 it was reduced to only being a loader for gallium OpenGL megadriver, so only programs using Mesa3D desktop OpenGL drivers via per-application deployment depend on it now.
### Microsoft CLonD3D12, GLonD3D12, Dozen Vulkan driver and D3D12 VA-API common dependency
- DirectX IL for redistribution. File name: `dxil.dll`. This binary redistributable is provided in Windows SDK and DirectX Shader Compiler and packaged during release process. [Deployment tools](#installation-and-usage) install it as necessary.
### Desktop OpenGL drivers
- [llvmpipe](https://www.mesa3d.org/llvmpipe.html). llvmpipe is a Desktop OpenGL software renderer intended as fallback when hardware acceleration is not possible. It can only handle very light gaming with good performance. This is the default Mesa3D desktop OpenGL driver when GLonD3D12 is either unavailable or fails to load. It's available for both x86 and x64 as part of Mesa3D Desktop OpenGL bundle `opengl32.dll` or `libgallium_wgl.dll` if the latter is available. When it's not the default driver select it by setting environment variable `GALLIUM_DRIVER=llvmpipe`.
- softpipe is a reference implementation of a Desktop OpenGL software renderer with no focus towards gaming performance. It's available for both x86 and x64 as part of Mesa3D Desktop OpenGL bundle `opengl32.dll` or `libgallium_wgl.dll` if the latter is available. Select it by setting  environment variable `GALLIUM_DRIVER=softpipe`.
- [GLonD3D12](https://docs.mesa3d.org/drivers/d3d12.html). It's available for both x86 and x64 in MSVC package and since 22.2.0 in MinGW package as well as part of Mesa3D Desktop OpenGL bundle `opengl32.dll` or `libgallium_wgl.dll` if the latter is available and prior to 22.3.0 as standalone `openglon12.dll` as well. In addition to officially requiring Windows 10 v10.0.19041.488 or newer, it also depends on DirectX IL for redistribution - `dxil.dll` to load, which can be installed via [deployment tools](#installation-and-usage). When available and if it can load, this is the default Mesa3D desktop OpenGL driver on D3D12 GPU accelerated systems. This driver introduced in 21.0.0 is operating as wrapper returning D3D12 API calls. Due to this nature it can use GPU acceleration. If it's not selected by default you can test it with Direct3D WARP software renderer built into Windows by setting `GALLIUM_DRIVER=d3d12` and `LIBGL_ALWAYS_SOFTWARE=1` environment variables. The standalone copy doesn't need `GALLIUM_DRIVER=d3d12` being set and it can only be installed via system-wide deployment tool. The standalone GLonD3D12 and Mesa3D Desktop OpenGL bundle replace each other when using system-wide deployment tool but you can reverse it any time. 
- [zink](https://docs.mesa3d.org/drivers/zink.html). This driver introduced in MinGW package in 21.0.0 and MSVC package in 21.2.0 it's available for both x86 and x64 as part of Mesa3D Desktop OpenGL bundle `opengl32.dll` or `libgallium_wgl.dll` if the latter is available. Similarly to GLonD3D12, it operates as wrapper returning Vulkan API calls. Due to this nature it uses GPU acceleration by default but it supports software rendering too. Select it via `GALLIUM_DRIVER=zink` environment variable, but note that it requires at least 1 Vulkan device and Vulkan loader/[runtime](https://vulkan.lunarg.com/sdk/home#windows) to initialize. zink ignored Vulkan CPU type devices by default until 22.1.0. Nowdays it uses a [priority system](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/15857) that automatically selects a Vulkan CPU type device if no higher priority Vulkan type device exists. You can test zink with Vulkan CPU type devices only by setting `LIBGL_ALWAYS_SOFTWARE=1` (Mesa 22.1.0 and newer) or `ZINK_USE_LAVAPIPE=true` (deprecated in Mesa 22.1.0).
- [swr](https://openswr.org/). This driver is no longer available in Mesa 22.0 and newer. File names: `swrAVX.dll`, `swrAVX2.dll`, `swrSKX.dll`, `swrKNL.dll`. Even though it resides outside of Mesa3D Desktop OpenGL bundle `opengl32.dll` or `libgallium_wgl.dll` if the latter is available, it still depends on it. This alternative desktop OpenGL software rendering driver developed by Intel is optimized for visualization software. It's available in MSVC package and since 20.1.7 in MinGW package as well. It only supports x64, x86 is [officially unsupported](https://bugs.freedesktop.org/show_bug.cgi?id=102564#c5). There are currently 4 DLLs, only one being loaded based on what the user CPU can do. You can switch to swr by setting GALLIUM_DRIVER environment variable value to swr.
### OpenGL off-screen rendering driver
- [osmesa](https://www.mesa3d.org/osmesa.html). File name: `osmesa.dll`. Available for both x86 and x64. Removed in 25.1.0 in favor of EGL. This driver is used in special cases by software that is designed to use Mesa code to render without any kind of window system or operating system dependency. Since 21.0.0 only osmesa gallium remained. It supports OpenGL 3.x and newer. Since 20.0.2 osmesa integration with standalone GLLES drivers is available in both MSVC and MSYS2 Mingw-w64 packages requiring `libglapi.dll` in the process until 25.0.0.
### OpenGL ES drivers and EGL library
- [EGL library](https://www.mesa3d.org/egl.html). File name: `libEGL.dll`. Mesa3D EGL library used by OpenGL ES drivers. This debuted in 21.3.0 and it's available for 32-bit and 64-bit applications in both MSVC and MSYS2 packages. It depends on desktop OpenGL bundle `opengl32.dll` or `libgallium_wgl.dll` if the latter is available.
- [OpenGL ES standalone drivers](https://www.mesa3d.org/opengles.html). File names: `libGLESv1_CM.dll` and `libGLESv2.dll`. OpenGL ES 1.x, 2.x and 3.x standalone drivers available for 32-bit and 64-bit applications. Since 20.0.2 they are available in both MSVC and MSYS2 Mingw-w64 packages. They depend on Mesa3D EGL library if available and desktop OpenGL bundle `opengl32.dll` or `libgallium_wgl.dll` if the latter is available.
### Vulkan drivers
- lavapipe Vulkan CPU driver is available in both MSVC and MinGW packages since 21.1.0. File names: `lvp_icd.x86_64.json`, `lvp_icd.x86.json`, `vulkan_lvp.dll`. Note that some programs may ignore Vulkan CPU type devices on purpose. For information on how to deploy see [usage notes](#usage-notes).
- Microsoft dozen Vulkan driver is available since 22.1.0 in MSVC package and since 22.2.0 in MinGW package as well. This driver relies on D3D12 API to function and it can use GPU acceleration on supported systems. File names: `dzn_icd.x86_64.json`, `dzn_icd.x86.json`, `vulkan_dzn.dll`. For information on how to deploy see [usage notes](#usage-notes).
- Vulkan driver for AMD graphics (radv) is no longer available since 22.1.0 per @zmike [suggestion](https://github.com/pal1000/mesa-dist-win/issues/103) as it won't work anytime soon. RADV was available in both MSVC and MinGW packages since 21.2.0. 32-bit binary of it was available since Mesa 22.0. File names: `radeon_icd.x86_64.json`, `radeon_icd.x86.json`, `libvulkan_radeon.dll` and `vulkan_radeon.dll`. For information on how to deploy see [usage notes](#usage-notes).
### OpenCL drivers, compilers and backends
- Microsoft OpenCL stack. File names: `clon12compiler.dll` (compiler), `openclon12.dll` (ICD) and `WinPixEventRuntime.dll` (x64 only dependency). These components introduced in 21.0.0 are finally provided by mesa-dist-win since 21.3.0 (compiler only) and 21.3.6-2 respectively. CLonD3D12 driver is available as an OpenCL ICD. For information on how to deploy see [usage notes](#usage-notes). CLonD3D12 officially requires Windows 10 v10.0.19041.488 or newer and it depends on DirectX IL for redistribution - `dxil.dll` to load, which can be installed via [deployment tools](#installation-and-usage). CLonD3D12 is operating as wrapper returning D3D12 API calls. Due to this nature it can use D3D12 GPU acceleration if available otherwise Windows built-in WARP software rendering is used. When using WARP CLonD3D12 used to advertize CL_DEVICE_TYPE_GPU, but this changed in 23.0.0 to CL_DEVICE_TYPE_CPU, see https://github.com/microsoft/OpenCLOn12/issues/19. Some programs ignore drivers with CL_DEVICE_TYPE_CPU set on purpose. The old behavior prior to 23.0.0 can be restored since Mesa 24.0.3 by seting `CLON12_WARP_IS_HARDWARE` environment variable value to 1.
- clover OpenCL stack has been removed from release package in 22.1.1 until Windows support is finalized as it's currently [unusable](https://github.com/pal1000/mesa-dist-win/issues/88). File names: `MesaOpenCL.dll` (ICD), `OpenCL.dll` (standalone runtime), and `pipe_swrast.dll` (pipe loader). The runtime can be deployed with per app deployment tool since 21.3.7 or on older versions via copy-paste along with all available pipe loaders which it depends on. While deployed, the runtime hides all other OpenCL ICDs present on the system and only lets software use Mesa3D clover as the only OpenCL driver. For information on how to deploy the ICD see [usage notes](#usage-notes).
### Direct3D drivers, libraries and tools
- D3D10 software renderer is available in MSVC package since 21.2.0. File name: `d3d10sw.dll`. This is a drop in replacement for Microsoft WARP and unfortunately there is no clean way of [deploying](https://gitlab.freedesktop.org/mesa/mesa/-/blob/main/src/gallium/targets/d3d10sw/README.md) it.
- SPIR-V to DXIL tool and library are available in MSVC package since 21.0.0 and since 22.2.0 in MinGW package as well. File names: `libspirv_to_dxil.dll`, `spirv_to_dxil.dll` and `spirv2dxil.exe`.
### VA-API drivers
- VA-API D3D12 driver. File names: `vaon12_drv_video.dll`. This driver was made available in 22.3.0. Just like GLonD3D12, CLonD3D12 and dozen this is a layered driver running on top of Direct3D 12 API so it can use GPU acceleration if available. Deployment instructions have been [documented by Microsoft](https://devblogs.microsoft.com/directx/video-acceleration-api-va-api-now-available-on-windows/). Per application deployment tool has been updated to assist in this process.
### Testing library and tools
- Gallium raw interface. This deprecated component has been [removed in Mesa3D 22.3.0](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/19099). File names: `graw.dll`, `graw_null.dll`. This is a dummy gallium driver without any graphics API mainly used for testing. Available for both x86 and x64 and in full (with window system support) and headless (no window) versions. Since 20.0.2 both windowed and windowless versions are available in both MSVC and MSYS2 Mingw-w64 packages.
- test suite. Many executable unit tests.
### Development packages
Headers and libraries for both 32-bit and 64-bit builds are located in a separate archive called development pack.
### Debug packages
Starting with 22.2.0 a MSVC debug info package containing debug symbols in PDB format and a MinGW asserts enabled debug optimized build package are available. MinGW debug binaries can be used as drop-in replacements for their release counterparts. With software using per application deployment, this should be seamless, but for system-wide deployment, re-deployment is necessary to switch from release to debug builds and vice-versa. For more info on MinGW debugging, see [debug/mingw-start-debugging.sh](https://github.com/pal1000/mesa-dist-win/blob/master/debug/mingw-start-debugging.sh)
# Build Mesa3D yourself
Build instructions, if you want to replicate my builds, are available [here](https://github.com/pal1000/mesa-dist-win/tree/master/buildscript).
# Installation and usage
First choose between Mingw and MSVC package. See [Differences between MSVC and MinGW packages](#differences-between-msvc-and-mingw-packages) section for details. Before [extracting](https://www.7-zip.org/) release package close all programs that use Mesa if any is running. After extraction you will have access to 2 deployment options, both located in the directory you installed Mesa. Both deployment utilities have a start-over mechanism so you can do all deployments you need in one session. The deployment tools only support OpenGL and OpenGL ES components of Mesa3D plus OpenCL clover standalone.
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

Examples on OpenGL context configuration override, switch to other driver and old applications compatibility are available [here](https://github.com/pal1000/mesa-dist-win/tree/master/examples).
- The official Mesa3D documentation is available [here](https://docs.mesa3d.org/).
- OpenCL ICDs deployment is done through [registration of ICD file](https://github.com/KhronosGroup/OpenCL-ICD-Loader/blob/master/README.md#opencl-icd-loader-tests) with [system OpenCL runtime](https://github.com/KhronosGroup/OpenCL-ICD-Loader/blob/master/README.md#table-of-debug-environment-variables) (e.g. `opencl.dll` from `Windows\system32`). If you don't have system OpenCL runtime you can get it by installing [Intel OpenCL CPU runtime](https://www.intel.com/content/www/us/en/developer/tools/opencl-cpu-runtime/overview.html). It works for AMD CPUs as well.
- Deployment for Vulkan drivers is done through [Vulkan runtime](https://vulkan.lunarg.com/sdk/home#windows) using [ICD discovery](https://github.com/KhronosGroup/Vulkan-Loader/blob/master/docs/LoaderDriverInterface.md#driver-discovery) method. Note that Vulkan runtime comes bundled with graphics drivers supporting Vulkan so manually installing it may not be necessary.
# Uninstall Mesa3D
1. Run system wide deployment and perform uninstall operation if available, then exit;
2. Download and run [Everything tool](https://www.voidtools.com/) (any flavor should work);
3. Run per application deployment tool and leave it running;
4. In Everything tool, in text field under menu enter `libgallium_wgl.dll attrib:L ` and keep Everything tool running;
5. For each search result in Everything tool:
- open its location in Windows Explorer via Open Path or Open File location context menu option;
- find *.local files and remove them, but only if you are certain you specified a filename during deployment to that location;
- copy location from address bar and feed it to per application deployment tool;
- send no to all deployments until you are asked to do more deployments, send yes there.
6. Repeat steps 4 and 5 using osmesa.dll and graw.dll filenames respectively the same way was done for libgallium_wgl.dll;
7. Close per application deployment and Everything tools;
8. Revert any registry changes and any environment variables that configure Vulkan runtime to use any of Mesa3D Vulkan drivers, see [usage notes](#usage-notes) for clues on what potential changes you may have to revert;
9. Repeat step 8, but for OpenCL.

WARNING: Programs for which certain files have been overwritten by per application deployment tool may need re-installation/repair. Per application deployment tool detects and warns about this deployment scenario since 22.0.0.
# Legacy software compatibility
Old applications from early 200x and older may need MESA_EXTENSION_MAX_YEAR environment variable set to avoid buffer overflows. It expects a year number as value, most commonly used being 2001. It trims the extensions list returned by Mesa3D to extensions released up to and including provided year as Mesa3D extensions list is sorted by year.

Ex: `set MESA_EXTENSION_MAX_YEAR=2001`. See [How to set environment variables](#how-to-set-environment-variables).
# OpenGL context configuration override
With release of [OpenGL 3.1](https://en.wikipedia.org/wiki/OpenGL#OpenGL_3.1) many features marked as deprecated in OpenGL 3.0 have been removed and since OpenGL 3.2 launch this OpenGL specification branch is known as OpenGL core profile. Also in OpenGL 3.3 a new branch of the OpenGL specification known as forward compatible context was introduced which removes the OpenGL 3.0 deprecated features that were not removed in OpenGL 3.1.
Most proprietary drivers implemented the exemptions from these changes offered in the form of GL_ARB_compatibility extension for OpenGL 3.1 and compatibility contexts for OpenGL 3.2 and above.
Due to complexity and especially lack of correct implementation tests for GL_ARB_compatibility and compatibility contexts, Mesa3D developers chose to delay work in this area until Mesa 18.1 introduced GL_ARB_compatibility support and then Mesa 21.3 bumped compatibility contexts support to OpenGL 4.5 for llvmpipe.
In conclusion programs requesting OpenGL compatibility context won't get above OpenGL 3.0 for Mesa 18.0, 3.1 for Mesa 18.1 and 4.5 for Mesa 21.3 and newer.
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
The default value for llvmpipe driver is 4.5COMPAT for Mesa>=21.3, 3.1COMPAT for Mesa>=18.1 and 3.0COMPAT for Mesa<=18.0.

A very important feature provided by this variable is the possibility to configure an incomplete OpenGL context.
Programs can only request up to the highest OpenGL context with Khronos certification as complete from Mesa3D driver in use.
Currently llvmpipe is certified for OpenGL 4.5 in all OpenGL profiles. Currently swr and GLonD3D12 are certified for OpenGL 3.3 in core profile / forward compatible context and 3.1 in compatibility profile. zink OpenGL support depends on underlying Vulkan driver.
Since Mesa 17.3 values meant for OpenGL 4.6 are recognized.

- MESA_GLSL_VERSION_OVERRIDE

Used to specify shading language version.
Supported values are version numbers converted to integer: 110, 120, 130, 140. 150, 330, 400, 410, 420, 430, 440, 450 and 460. Value 460 is only recognized since Mesa 17.3. Value 130 for example matches GLSL 1.30. It is always a good idea to keep OpenGL context and shading language versions in sync to avoid programs confusion which may result in crashes or glitches. This can happen because most applications rely on proprietary drivers behavior of having OpenGL and GLSL versions in sync. [Here](https://en.wikipedia.org/wiki/OpenGL_Shading_Language#Versions) is the OpenGL - GLSL correlation table.
Default values for llvmpipe: 450 for Mesa 21.3, 140 for Mesa 18.1 and 130 for Mesa 18.0 if MESA_GL_VERSION_OVERRIDE is undefined or matching core profile's otherwise.
# How to set environment variables
Under Windows the easiest way to set environment variables is by writing batch files. You'll most likely need to do so:
- for every application requiring higher OpenGL and GLSL versions than what is exposed by selected Mesa3D driver by default;
- if you want to select a non-default driver for desktop OpenGL;
- if you need to trim extensions list for old programs compatibility.

Simply open Notepad, write the batch script. When saving, end the file name with .bat or .cmd, change save as type to all files and change save location to where the application executable is located. If you have some skill with batch scripts you can change the current directory during script execution using CD command opening the possibility to save the script anywhere you want as shown in [rpcs3](https://github.com/pal1000/mesa-dist-win/blob/master/examples/rpcs3.cmd) and [GPU Caps Viewer](https://github.com/pal1000/mesa-dist-win/blob/master/examples/GPUCapsViewer.cmd) examples.
Documentation of most environment variables used by Mesa is available [here](https://docs.mesa3d.org/envvars.html).
Complete examples are available [here](https://github.com/pal1000/mesa-dist-win/tree/master/examples).

You can set multiple environment variables on same batch script to mix the functionality provided by Mesa3D.
