**Table of Contents**

- [Downloads](#downloads)
- [Installation and usage](#installation-and-usage)
- [Manual OpenGL context configuration](#manual-opengl-context-configuration) 
  
# Downloads
Mesa 17.2.1 builds are now available in [releases section](https://github.com/pal1000/mesa-dist-win/releases)

By default mesa uses llvmpipe. You can switch to OpenSWR by setting GALLIUM_DRIVER environment variable value to swr either globally or in a batch file. Mesa environment variables documentation is available [here](https://mesa3d.org/envvars.html). Build instructions, if you want to replicate my builds, are available [here](https://github.com/pal1000/mesa-dist-win/tree/master/buildscript).
# Installation and usage
The quick deployment utility will help you save storage when deploying Mesa as it creates symlinks to whatever Mesa drivers you opt-in to use. It only asks for path to folder containing application executable, if the app is 64-bit or 32-bit and the drivers you need. Most applications will use mesa regardless of GPU capabilities, but some applications may be smart enough to load OpenGL from system directory only. Use [Federico Dossena](https://github.com/adolfintel)'s Mesainjector to workaround this issue: [Build guide](http://fdossena.com/?p=mesa/injector_build.frag), [VMWare ThinApp capture](http://fdossena.com/mesa/MesaInjector_Capture.7z). Since v17.0.1.391 in-place upgrade is fully supported. Since v17.0.1.391-2 S3 texture compression is supported. v17.0.4.391-1 requires uninstall of previous versions. Applications requiring OpenGL 3.1 or newer may need [Manual OpenGL context configuration](#manual-opengl-context-configuration).

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

A very important feature provided by this variable is the posibility to configure an incomplete OpenGL context. Programs can only request up to the highest OpenGL context with Khronos certification as complete from Mesa3D driver in use. Currently both llvmpipe and OpenSWR are certified for OpenGL 3.3, yet the rpcs3 context configuration sample uses OpenGL 4.3 and it works. This is because despite the context not being complete, the required extensions by rpcs3 are in place.

- MESA_GLSL_VERSION_OVERRIDE

Used to specify shading language version.
Supported values are version numbers converted to integer: 110, 120, 130, 140. 150, 330, 400, 410, 420, 430, 440, 450.
130 for example matches GLSL 1.30. It is always a good idea to keep OpenGL context and shading language versions in sync to avoid programs confusion which may result in crashes or glitches. This can happen because most applications rely on proprietary drivers behavior of having OpenGL and GLSL versions in sync. [Here](https://en.wikipedia.org/wiki/OpenGL_Shading_Language#Versions) is the OpenGL - GLSL correlation table.
Default values: 130 if MESA_GL_VERSION_OVERRIDE is undefined or 330 otherwise. Value 460 refering GLSL 4.60 would be supported at some point in the future. It is expected to be available with Mesa 17.3.

Under Windows the easiest way to set these 2 environment variables is by writing batch files for every application requiring OpenGL >= 3.1 that is using Mesa. 
Simply open Notepad, write the batch script. When saving, end the file name with .bat or .cmd, change save as type to all files and change save location to where the application executable is located. If you have some skill with batch scripts you can change the current directory during script execution using CD command openning the posibility to save the script anywhere you want as shown in [rpcs3](https://github.com/pal1000/mesa-dist-win/blob/master/glcontextsamples/rpcs3.cmd) and [GPU Caps Viewer](https://github.com/pal1000/mesa-dist-win/blob/master/glcontextsamples/GPUCapsViewer.cmd) examples.

Complete examples are available [here](https://github.com/pal1000/mesa-dist-win/tree/master/glcontextsamples).


