**Table of Contents**

- [Downloads](#downloads)
- [Package contents](#package-contents)
- [Installation and usage](#installation-and-usage)
- [Manual OpenGL context configuration](#manual-opengl-context-configuration) 
  
# Downloads
Mesa 17.3.5 builds are now available in [releases section](https://github.com/pal1000/mesa-dist-win/releases)

# Package contents
The following Mesa3D drivers are shipped in each release:
- [llvmpipe](https://www.mesa3d.org/llvmpipe.html). file name: opengl32.dll. It is the default desktop OpenGL driver.
- [swr](http://openswr.org/). File names: swrAVX.dll, swrAVX2.dll. An alternative desktop OpenGL driver developped by Intel. There are currently 2 DLLs, only one being loaded based on what the user CPU can do. 2 more will join soon matching the exting flavors of AVX512 instruction set, see issue [#2](https://github.com/pal1000/mesa-dist-win/issues/2). By default Mesa uses llvmpipe. You can switch to swr by setting GALLIUM_DRIVER environment variable value to swr either globally or in a batch file. See [How to set environment variables](#how-to-set-environment-variables).
- [osmesa](https://www.mesa3d.org/osmesa.html). File names: osmesa-swrast.dll, osmesa-gallium.dll. 2 versions of osmesa, off-screen rendering driver. This is used in special cases by software that is designed to use Mesa code to render without any kind of winndow system or operating system dependency. swrast variant runs without LLVM JIT, being much slower than gallium version, but it has unique features.
- graw. File name: graw.dll. This is Mesa3D plug-in library. It is not a driver. This is used in special cases by software that is designed to use Mesa code. While Mesa includes a full version bearing the build target of graw-gdi and a headless version bearing the build target of graw-null, only the full version is included. The headless version can be easily added upon request in a later release. 

Build instructions, if you want to replicate my builds, are available [here](https://github.com/pal1000/mesa-dist-win/tree/master/buildscript).

# Installation and usage
Before running the installer close all programs that use Mesa if any is running. After running the installer you need to run the quick deployment utility located in the directory you installed Mesa. You only need to do this for programs you didn't deployed Mesa before as the quick deployment utility changes persist across upgrades and reinstallations. The quick deployment utility has a start-over mechanism so you can do all deployments you need in one go. The quick deployment utility will help you save storage and makes things easier as you won't have to manually copy DLLs from Mesa installation directory as it creates symlinks to whatever Mesa drivers you opt-in to use. This behavior ensures all programs that use Mesa use the same up-to-date version. Quick deployment utility only asks for path to directory containing application executable, if the app is 64-bit or 32-bit and the drivers you need. 32-bit applications have their names marked in Task Manager while running. Most applications will use mesa regardless of GPU capabilities, but some applications may be smart enough to load OpenGL from system directory only. Use [Federico Dossena](https://github.com/adolfintel)'s Mesainjector to workaround this issue: [Build guide](http://fdossena.com/?p=mesa/injector_build.frag), [VMWare ThinApp capture](http://fdossena.com/mesa/MesaInjector_Capture.7z). Since v17.0.1.391 in-place upgrade is fully supported. Since v17.0.1.391-2 S3 texture compression is supported. v17.0.4.391-1 requires uninstall of previous versions. Applications requiring OpenGL 3.1 or newer may need [Manual OpenGL context configuration](#manual-opengl-context-configuration).

# Manual OpenGL context configuration
With release of [OpenGL 3.1](https://en.wikipedia.org/wiki/OpenGL#OpenGL_3.1) features marked as deprecated in OpenGL 3.0 have been removed. Most proprietary drivers opted to implement the exemption from this rule offered in the form of GL_ARB_compatibility extension. Due to complexity and especially lack of correct implementation tests, Mesa3D opted for an easier solution. Implemented core profile and core+forward compatible contexts introduced with OpenGL 3.2 as alternative to GL_ARB_compatibility to support OpenGL 3.0 and up and use the already existing compatibility context to implement GL_ARB_compatibility functionality slowly but steadly, but without official support. This implementation being unsupported is not exposed as GL_ARB_compatibility. Because of this, applications that only set compatibility OpenGL context won't get above OpenGL 3.0.

Context types description:

Context type | Description
------------ | -----------
Compatibility context | This is the original OpenGL context. Intended for old applications requiring up to and including OpenGL 3.0 or which use both old and recent OpenGL features. It can be used for OpenGL 3.1 and up to simulate GL_ARB_compatibility, but being unsupported for OpenGL 3.1 and up it is neither exposed as GL_ARB_compatibility nor it can be automatically requested by applications via context flags for OpenGL 3.1 and up.
Core profile | Removes legacy features deprecated with OpenGL 3.0.
Core+foeward compatible context | Removes legacy features deprecated with OpenGL 3.0 and provide if possible features from OpenGL contexts newer than the one requested.

Because Mesa3D doesn't expose GL_ARB_compatibility, OpenGL contexts above 3.0 are not available unless explicitly requested by applications through context flags. Unfortunately this is bad news for most Windows applications because they only set the basic compatibility context expecting and relying on GL_ARB_compatibility support to access OpenGL 3.1 or higher contexts. Fortunately Mesa3D provides a mechanism to manually configure OpenGL contexts for applications that don't do this automatically. There are 2 environment variables that control OpenGL context configuration:
- MESA_GL_VERSION_OVERRIDE

It is used to specify OpenGL context version and type.
It expects a value in the following format

OpenGLMajorVersion.OpenGLMinorVersion{FC|COMPAT].

FC means a core+forward compatible context, COMPAT means a compatibility context, absence of any string after version number means a core profile context. Examples: 3.3FC means OpenGL 3.3 core+forward compatible context, 3.1COMPAT means OpenGL 3.1 compatibility context, 3.2 means OpenGL 3.2 core profile. The default value is 3.0COMPAT.

A very important feature provided by this variable is the posibility to configure an incomplete OpenGL context. Programs can only request up to the highest OpenGL context with Khronos certification as complete from Mesa3D driver in use. Currently both llvmpipe and swr are certified for OpenGL 3.3, yet the rpcs3 context configuration sample uses OpenGL 4.3 and it works. This is because despite the context not being complete, the required extensions by rpcs3 are in place. Since Mesa 17.3 values meant for OpenGL 4.6 are recognized.

- MESA_GLSL_VERSION_OVERRIDE

Used to specify shading language version.
Supported values are version numbers converted to integer: 110, 120, 130, 140. 150, 330, 400, 410, 420, 430, 440, 450 and 460. Value 460 is only recognized since Mesa 17.3. Value 130 for example matches GLSL 1.30. It is always a good idea to keep OpenGL context and shading language versions in sync to avoid programs confusion which may result in crashes or glitches. This can happen because most applications rely on proprietary drivers behavior of having OpenGL and GLSL versions in sync. [Here](https://en.wikipedia.org/wiki/OpenGL_Shading_Language#Versions) is the OpenGL - GLSL correlation table.
Default values: 130 if MESA_GL_VERSION_OVERRIDE is undefined or 330 otherwise.

# How to set environment variables
Under Windows the easiest way to set environment variables is by writing batch files for every application requiring OpenGL >= 3.1 that is using Mesa or if your want to use swr instead of llvmpipe for Desktop OpenGL.
Simply open Notepad, write the batch script. When saving, end the file name with .bat or .cmd, change save as type to all files and change save location to where the application executable is located. If you have some skill with batch scripts you can change the current directory during script execution using CD command openning the posibility to save the script anywhere you want as shown in [rpcs3](https://github.com/pal1000/mesa-dist-win/blob/master/examples/rpcs3.cmd) and [GPU Caps Viewer](https://github.com/pal1000/mesa-dist-win/blob/master/examples/GPUCapsViewer.cmd) examples.
Documentation of most environment variables used by Mesa is available [here](https://mesa3d.org/envvars.html).
Complete examples are available [here](https://github.com/pal1000/mesa-dist-win/tree/master/examples).

There no conflict between swr driver and manual GL context configuration. You can mix them if necessary.
