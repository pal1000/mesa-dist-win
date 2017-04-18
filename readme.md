**Table of Contents**

- [Downloads](#downloads)
- [Installation and usage](#installation-and-usage)
  
# Downloads
Mesa 17.0.4 builds are now available in [releases section](https://github.com/pal1000/mesa-dist-win/releases)

By default mesa uses llvmpipe. You can switch to OpenSWR by setting GALLIUM_DRIVER environment variable value to swr . Mesa environment variables documentation is available [here](https://mesa3d.org/envvars.html). Build instructions, if you want to replicate my builds, are available [here](https://github.com/pal1000/mesa-dist-win/tree/master/buildscript).
# Installation and usage
The quick deployment utility will help you save storage when deploying Mesa as it creates symlinks to whatever Mesa drivers you opt-in to use. It only asks for path to folder containing application executable, if the app is 64-bit or 32-bit and the drivers you need. Most applications will use mesa regardless of GPU capabilities, but some applications may be smart enough to load OpenGL from system directory only. Use Federico Dossena's Mesainjector to workaround this issue: [Build guide](http://fdossena.com/?p=mesa/injector_build.frag), [VMWare ThinApp capture](http://fdossena.com/mesa/MesaInjector_Capture.7z). Since v17.0.1.391 in-place upgrade is fully supported. Since v17.0.1.391-2 S3 texture compression is supported. v17.0.4.391-1 requires uninstall of previous versions.
