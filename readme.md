**Table of Contents**

- [Downloads](#downloads)
- [Installation](#installation)
	- [1. Locally for a certain application](#1-locally-for-a-certain-application)
	- [2. System wide](#2-system-wide)
		- [Installation procedure](#installation-procedure)
- [Getting 3D acceleration to work in Virtualbox VMs when GPU supplied OpenGL doesn't work, without paying for expensive code signing certificate](#getting-3d-acceleration-to-work-in-virtualbox-vms-when-gpu-supplied-opengl-doesnt-work-without-paying-for-expensive-code-signing-certificate)
  
# Downloads
Mesa 17.0.0 builds are now available in [releases section](https://github.com/pal1000/mesa-dist-win/releases)

You need both llvmpipe/softpipe and OpenSWR driver files for OpenSWR to work. OpenSWR driver is loaded when requested by llvmpipe/softpipe driver. It can't run on its own. By default mesa uses llvmpipe. You can switch to OpenSWR by setting GALLIUM_DRIVER environment variable value to swr . Mesa environment variables documentation is available [here](https://mesa3d.org/envvars.html). Build instructions, if you want to replicate my builds, are available [here](https://github.com/pal1000/mesa-dist-win/tree/master/buildscript).
# Installation
## 1. Locally for a certain application
Just drop the DLLs where your application executable is located. Rename opengl32sw.dll / opengl64sw.dll to opengl32.dll. Application will use mesa regardless of GPU capabilities. 
## 2. System wide
All applications that cannot use the GPU will use mesa automatically - Virtualbox, Aida64 system utilities and Java JRE 8 Update 60 and newer on Windows 10 on SandyBridge or older hardware lacking dGPU or eGPU,  with certain exceptions when bugs are involved - e.g. PCSX2 due to issue [1817](https://github.com/PCSX2/pcsx2/issues/1817). In this case opt for local deployment instead.
### Installation procedure
After downloading from releases section, extract the zip archive and install using the INF file. OpenSWR needs to be installed separately from openswr\x86 for 32-bit Windows and both openswr\x86 and openswr\x64 for 64-bit Windows.
# Getting 3D acceleration to work in Virtualbox VMs when GPU supplied OpenGL doesn't work, without paying for expensive code signing certificate
Unimplemented
