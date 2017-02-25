**Table of Contents**

- [Downloads](#downloads)
- [Installation](#installation)
- [Getting 3D acceleration to work in Virtualbox VMs when GPU supplied OpenGL doesn't work, without paying for expensive code signing certificate](#getting-3d-acceleration-to-work-in-virtualbox-vms-when-gpu-supplied-opengl-doesnt-work-without-paying-for-expensive-code-signing-certificate)
  
# Downloads
Mesa 17.0.0 builds are now available in [releases section](https://github.com/pal1000/mesa-dist-win/releases)

By default mesa uses llvmpipe. You can switch to OpenSWR by setting GALLIUM_DRIVER environment variable value to swr . Mesa environment variables documentation is available [here](https://mesa3d.org/envvars.html). Build instructions, if you want to replicate my builds, are available [here](https://github.com/pal1000/mesa-dist-win/tree/master/buildscript).
# Installation
By default Mesa installer performs a system-wide installation. All applications that cannot use the GPU will use mesa automatically - Virtualbox, Aida64 system utilities and Java JRE 8 Update 60 and newer on Windows 10 on SandyBridge or older hardware lacking dGPU or eGPU,  with certain exceptions, when bugs are involved - e.g. PCSX2 due to issue [1817](https://github.com/PCSX2/pcsx2/issues/1817). In this case opt for local deployment instead. The installer has created a shortcut to it on desktop (Mesa3D local deployment utility). It only asks for path to folder containing application executable and if the app is 64-bit or 32-bit. When local deployment is used application will use mesa regardless of GPU capabilities.
# Getting 3D acceleration to work in Virtualbox VMs when GPU supplied OpenGL doesn't work, without paying for expensive code signing certificate
Unimplemented
