**Table of Contents**

- [Downloads](#downloads)
- [Installation](#installation)
	- [1. Locally for a certain application](#1-locally-for-a-certain-application)
	- [2. System wide](#2-system-wide)
		- [Installation procedure](#installation-procedure)
	- [Upgrading mesa](#upgrading-mesa)
- [Using with PCSX2](#using-with-pcsx2)
- [Getting 3D acceleration to work in Virtualbox VMs when GPU supplied OpenGL doesn't work, without paying for expensive code signing certificate](#getting-3d-acceleration-to-work-in-virtualbox-vms-when-gpu-supplied-opengl-doesnt-work-without-paying-for-expensive-code-signing-certificate)
  
# Downloads
Mesa 17.0.0 builds are now available:
- [32-bit llvmpipe and softpipe drivers](https://github.com/pal1000/mesa-dist-win/blob/master/builds/17.0.0/x86/opengl32.dll?raw=true);
- [64-bit llvmpipe and softpipe drivers](https://github.com/pal1000/mesa-dist-win/blob/master/builds/17.0.0/x64/opengl32.dll?raw=true);
- [32-bit OpenSWR driver for AVX capable CPUs](https://github.com/pal1000/mesa-dist-win/blob/master/builds/17.0.0/x86/swrAVX.dll?raw=true);
- [64-bit OpenSWR driver for AVX2 capable CPUs](https://github.com/pal1000/mesa-dist-win/blob/master/builds/17.0.0/x86/swrAVX2.dll?raw=true);
- [32-bit OpenSWR driver for AVX capable CPUs](https://github.com/pal1000/mesa-dist-win/blob/master/builds/17.0.0/x64/swrAVX.dll?raw=true);
- [64-bit OpenSWR driver for AVX2 capable CPUs](https://github.com/pal1000/mesa-dist-win/blob/master/builds/17.0.0/x64/swrAVX2.dll?raw=true);

You need both llvmpipe/softpipe and OpenSWR driver files for OpenSWR to work. OpenSWR driver is loaded when requested by llvmpipe/softpipe driver. It can't run on its own. By default mesa uses llvmpipe. You can switch to OpenSWR by setting GALLIUM_DRIVER environment variable value to swr . Mesa environment variables documentation is available [here](https://mesa3d.org/envvars.html). Build instructions, if you want to replicate my builds, are available [here](https://github.com/pal1000/mesa-dist-win/tree/master/builds).
# Installation
## 1. Locally for a certain application
Just drop the DLLs where your application executable is located. Application will use mesa regardless of GPU capabilities. 
## 2. System wide
All applications that cannot use the GPU will use mesa automatically with certain exceptions when bugs are involved.  Examples include Virtualbox, Aida64 system utilities and Java JRE 8 Update 60 and newer on Windows 10 on SandyBridge or older hardware lacking dGPU or eGPU. PCSX2, while Gsdx OpenGL plugin cannot run on almost all systems with Intel iGPU lacking dGPU or eGPU, see [pcsx2/pcsx2#345](https://github.com/PCSX2/pcsx2/issues/345) and [pcsx2/pcsx2#1716](https://github.com/PCSX2/pcsx2/issues/1716), it may won't use mesa on first try due to [pcsx2/pcsx2#1817](https://github.com/PCSX2/pcsx2/issues/1817).
### Installation procedure
- rename downloaded opengl32.dll llvmpipe/softpipe driver to something unique like opengl32sw.dll or mesadrv.dll. You can do it for both 32-bit and 64-bit DLLs, or just for the one you need;
- for 64 bit Windows drop the 32-bit llvmpipe/softpipe (and OpenSWR if wanted) in %SystemRoot%\SysWOW64 and 64-bit llvmpipe/softpipe (and OpenSWR if wanted) in %SystemRoot%\System32 ;
- for 32 bit Windows drop the 32-bit llvmpipe/softpipe (and OpenSWR if wanted) in %SystemRoot%\System32 .

The following code assumes you renamed opengl32.dll to opengl32sw.dll. If you named it in other way just make appropriate replacements.
- Create a new text file with following code:
- for 32-bit applications on 64-bit Windows
```
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\OpenGLDrivers\MSOGL]
"DLL"="opengl32sw.dll"
"DriverVersion"=dword:00000001
"Flags"=dword:00000001
"Version"=dword:00000002
```
- for 64 bit applications or 32-bit Windows
```
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\OpenGLDrivers\MSOGL]
"DLL"="opengl32sw.dll"
"DriverVersion"=dword:00000001
"Flags"=dword:00000001
"Version"=dword:00000002
```
- for 64-bit Windows all applications:
```
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\OpenGLDrivers\MSOGL]
"DLL"="opengl32sw.dll"
"DriverVersion"=dword:00000001
"Flags"=dword:00000001
"Version"=dword:00000002
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\OpenGLDrivers\MSOGL]
"DLL"="opengl32sw.dll"
"DriverVersion"=dword:00000001
"Flags"=dword:00000001
"Version"=dword:00000002
```
- When saving, the file name must end with .reg extension and you need to change Save As Type to All Files before saving;
- Open Registry Editor as administrator (On Windows 7 and 10 simply search for regedit, right click on the result and select Run as administrator);
- Click/tap on File - Import and browse where you saved the reg file. Click/Tap on Import. Close Registry Editor. You only need to restart applications that use OpenGL for changes to take effect. No system reboot or user re-login is required. 

## Upgrading mesa
Upgrading mesa is trivial. All you have to do is to replace the old DLLs with new ones. If you installed it system wide make sure you rename opengl32.dll file(s) to whatever name you used during initial installation. If you don't remember, this information is available in registry as data for a value called DLL under the following keys:
- for 32-bit Windows or 64-bit version of mesa: ``HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\OpenGLDrivers\MSOGL ``;
- for 32-bit mesa on 64-bit Windows: ``HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\OpenGLDrivers\MSOGL``.

# Using with PCSX2
For PCSX2 use case, at this moment only llvmpipe supplies the required extensions. It is recommended to install llvmpipe system wide to minimize impact of [pcsx2/pcsx2#1817](https://github.com/PCSX2/pcsx2/issues/1817). Note that PCSX2 won't be able to boot anything on first try because of this bug. Try again and it will work. OpenGL software mode works best.
# Getting 3D acceleration to work in Virtualbox VMs when GPU supplied OpenGL doesn't work, without paying for expensive code signing certificate
Unimplemented
