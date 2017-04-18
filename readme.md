**Table of Contents**

- [Downloads](#downloads)
- [Installation and usage](#installation-and-usage)
- [Getting 3D acceleration to work in Virtualbox VMs on Windows 10 2nd generation Intel Core and older without paying for expensive code signing certificate](#getting-3d-acceleration-to-work-in-virtualbox-vms-on-windows-10-2nd-generation-intel-core-and-older-without-paying-for-expensive-code-signing-certificate)
	- [Introduction](#introduction)
	- [Getting a free 30 days Ascertia certificate](#getting-a-free-30-days-ascertia-certificate)
  	- [Certificate installation and driver signing](#certificate-installation-and-driver-signing)
  
# Downloads
Mesa 17.0.4 builds are now available in [releases section](https://github.com/pal1000/mesa-dist-win/releases)

By default mesa uses llvmpipe. You can switch to OpenSWR by setting GALLIUM_DRIVER environment variable value to swr . Mesa environment variables documentation is available [here](https://mesa3d.org/envvars.html). Build instructions, if you want to replicate my builds, are available [here](https://github.com/pal1000/mesa-dist-win/tree/master/buildscript).
# Installation and usage
The quick deployment utility will help you save storage when deploying Mesa as it creates symlinks to whatever Mesa drivers you opt-in to use. It only asks for path to folder containing application executable, if the app is 64-bit or 32-bit and the drivers you need. Most applications will use mesa regardless of GPU capabilities, but some applications may be smart enough to load OpenGL from system directory only. Use Federico Dossena's Mesainjector to workaround this issue: [Build guide](http://fdossena.com/?p=mesa/injector_build.frag), [VMWare ThinApp capture](http://fdossena.com/mesa/MesaInjector_Capture.7z). Since v17.0.1.391 in-place upgrade is fully supported. Since v17.0.1.391-2 S3 texture compression is supported. v17.0.4.391-1 requires uninstall of previous versions.
# Getting 3D acceleration to work in Virtualbox VMs on Windows 10 2nd generation Intel Core and older without paying for expensive code signing certificate
## Introduction
Before beginning shutdown all VMs. This is standard practice when updating host OS graphics driver. Replace or patch ig4icd64.dll from %windir%\system32 with [this](https://github.com/LWJGL/lwjgl/issues/119#issuecomment-263710095). For 3D acceleration to work we must comply with hardened security requirements: (all requirements are simultaneously mandatory)
- binary driver must be digitally signed;
- embedded signature must be OK per Windows authenticode standard;
- embedded signature must have all subject fields present;
- No empty string subject fields are allowed.

SHA1 is still accepted, but likely not for long considering [Google created a pair of hash collision PDFs](http://shattered.io/).  If this happens, using an Ascertia certificate is no longer an option.

Because both Certum and StartSSL have stopped providing free code signing for open-source developers we are left with few options. One option involves [Ascertia](http://www.ascertia.com/) certificate authority and the other [makecert powershell script](https://gallery.technet.microsoft.com/scriptcenter/Self-signed-certificate-5920a7c6). While it may be future-proof as it supports SHA-2, powershell method may be difficult, actually I have no proof that it can be done.

## Getting a free 30 days Ascertia certificate
- Visit ascertia.com, sign up then login;
-  go to Downloads - Try or Buy Ascertia certificates - Try code signing certificate;
- make sure you complete all fields, put something in State field even if you live in a country capital to comply with Virtualbox hardened security otherwise you may be surprised wondering why 3D acceleration doesn't work;
- download your certificate in PFX format.

 If you screwed up and you left at least one subject field an empty string then even if signature is OK, 3D acceleration won't work and this is what appears in VBoxHardening.log, accessible by right-click and selecting Show Log on a running VM in Oracle VM Virtualbox Manager:

```

c68.15c4: \Device\HarddiskVolume5\Windows\System32\ig4icd64.dll: Owner is administrators group.
c68.15c4: supR3HardenedMonitor_LdrLoadDll: returns rcNt=0x0     
 c68.15c4: supHardenedWinVerifyImageByHandle: -> -23014 (\Device\HarddiskVolume5\Windows\System32\ig4icd64.dll) WinVerifyTrust
c68.15c4: Error (rc=0):
c68.15c4: supR3HardenedScreenImage/LdrLoadDll: rc=Unknown Status -23014 (0xffffa61a) fImage=1 fProtect=0x0 fAccess=0x0 \Device\HarddiskVolume5\Windows\System32\ig4icd64.dll: RTCRX509TBSCERTIFICATE::Subject: Items[2].paItems[0] is an empty string: \Device\HarddiskVolume5\Windows\System32\ig4icd64.dll
c68.15c4: supR3HardenedWinVerifyCacheInsert: \Device\HarddiskVolume5\Windows\System32\ig4icd64.dll
c68.15c4: Error (rc=0):
c68.15c4: supR3HardenedMonitor_LdrLoadDll: rejecting 'C:\WINDOWS\System32\ig4icd64.dll': rcNt=0xc0000190
c68.15c4: supR3HardenedMonitor_LdrLoadDll: returns rcNt=0xc0000190 'C:\WINDOWS\System32\ig4icd64.dll'

```

After such blunder your only option is to rinse and repeat.
 
## Certificate installation and driver signing
- Download and install Windows SDK, we need the signtool utility, it is located by default in %ProgramFiles(x86)%Windows Kits\10\bin\x64 for Windows 10 SDK;
- Create a shortcut with the following target command `rundll32.exe shell32.dll,Control_RunDLL inetcpl.cpl`, name it Internet Options as that is what is going to open, change Shortcut properties, in Advanced section check Run as Administrator;
- Install the PFX you got from Ascertia (double click), choose target as Local Machine, and let the wizard place all certificates in their appropriate stores (autodetect mode);
- Open certlm.msc as administrator and remove your personal certificate from there, the wizard screws up this step so we need an extra PFX install step, also that's why we created that shortcut to an elevated Internet Options;
- Open Internet Options using the shortcut, browse to Content - Certificates - Import and install the PFX again in default store. This time only the personal certificate would be installed as the others are already in place;
- Finally to sign the driver, open an elevated command Prompt and execute:

`%ProgramFiles(x86)%Windows Kits\10\bin\x64\signtool.exe remove /s ig4icd64.dll`

`%ProgramFiles(x86)%Windows Kits\10\bin\x64\signtool.exe sign /a /t http://timestamp.digicert.com ig4icd64.dll`.
 
This concludes the process. Enjoy OpenGL and Direct3D in Virtualbox VMs without GPU support.
When you upgrade the driver, make sure you shutdown all VMs beforehand, sign again using signtool command ensuring the certificate is still valid or order a new one if it's not. You want to keep that elevated Internet Options shortcut as you'll use it every time you replace your personal certificate after expiration.
