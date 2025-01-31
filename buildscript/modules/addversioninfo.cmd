@setlocal
@rem Get Mesa3D version
@IF NOT EXIST "%devroot%\mesa\VERSION" GOTO nomesaverinfo
@set /p mesaver=<"%devroot%\mesa\VERSION"
@if "%mesaver:~5,2%"=="0-" set mesaver=%mesaver:~0,6%

@rem Check if resource hacker can be reached.
@IF %rhstate%==0 GOTO nomesaverinfo
@IF %rhstate%==1 SET PATH=%devroot%\resource-hacker\;%PATH%

@set mesabldrev=
@set /p mesabldrev=Mesa3D build revision (default:blank, positive integer or blank expected, leaving blank disables adding version information to binaries, MinGW debug binaries should have this left blank as GDB is intolerant to any binary tampering):
@echo.
@IF NOT defined mesabldrev GOTO nomesaverinfo
@echo Adding version information to binaries. Please wait...
@echo.

@rem Add version info to desktop OpenGL drivers stack
@IF NOT EXIST "%devroot%\%projectname%\bin\%abi%\libgallium_wgl.dll" call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Mesa3D desktop OpenGL drivers stack" "%devroot%\%projectname%\bin\%abi%\opengl32.dll" %abi% %mesaver% "Mesa/X.org"
@IF EXIST "%devroot%\%projectname%\bin\%abi%\libgallium_wgl.dll" call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Mesa3D WGL loader" "%devroot%\%projectname%\bin\%abi%\opengl32.dll" %abi% %mesaver% "Mesa/X.org"
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Mesa3D desktop OpenGL drivers stack" "%devroot%\%projectname%\bin\%abi%\libgallium_wgl.dll" %abi% %mesaver% "Mesa/X.org"

@rem Add version info to Microsoft desktop OpenGL over D3D12 driver
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Mesa3D desktop OpenGL over D3D12 driver" "%devroot%\%projectname%\bin\%abi%\openglon12.dll" %abi% %mesaver% "Microsoft Corporation"

@rem Add version info to Intel swr desktop OpenGL driver
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Mesa3D swr desktop OpenGL software rendering driver running on AVX instruction set" "%devroot%\%projectname%\bin\%abi%\swrAVX.dll" null %mesaver% "Intel"
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Mesa3D swr desktop OpenGL software rendering driver running on AVX2 instruction set" "%devroot%\%projectname%\bin\%abi%\swrAVX2.dll" null %mesaver% "Intel"
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Mesa3D swr desktop OpenGL software rendering driver running on Skylake-X variant of AVX512 instruction set" "%devroot%\%projectname%\bin\%abi%\swrSKX.dll" null %mesaver% "Intel"
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Mesa3D swr desktop OpenGL software rendering driver running on Knights Landing variant of AVX512 instruction set" "%devroot%\%projectname%\bin\%abi%\swrKNL.dll" null %mesaver% "Intel"

@rem Add version info to shared glapi library
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Mesa3D shared glapi library" "%devroot%\%projectname%\bin\%abi%\libglapi.dll" %abi% %mesaver% "Mesa/X.org"

@rem Add version info to Mesa3D EGL library
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Mesa3D EGL library" "%devroot%\%projectname%\bin\%abi%\libEGL.dll" %abi% %mesaver% "Mesa/X.org"

@rem Add version info to standalone OpenGL ES 1.x driver
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Mesa3D standalone OpenGL ES 1.x driver" "%devroot%\%projectname%\bin\%abi%\libGLESv1_CM.dll" %abi% %mesaver% "Mesa/X.org"

@rem Add version info to standalone OpenGL ES 2.x and 3.x driver
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Mesa3D standalone OpenGL ES 2.x and 3.x driver" "%devroot%\%projectname%\bin\%abi%\libGLESv2.dll" %abi% %mesaver% "Mesa/X.org"

@rem Add version info to Mesa3D Vulkan software rendering driver
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Mesa3D Vulkan software rendering driver" "%devroot%\%projectname%\bin\%abi%\vulkan_lvp.dll" %abi% %mesaver% "Mesa/X.org"

@rem Add version info to Mesa3D Vulkan driver for AMD cards
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Mesa3D Vulkan driver for AMD cards" "%devroot%\%projectname%\bin\%abi%\vulkan_radeon.dll" %abi% %mesaver% "Mesa/X.org"
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Mesa3D Vulkan driver for AMD cards" "%devroot%\%projectname%\bin\%abi%\libvulkan_radeon.dll" %abi% %mesaver% "Mesa/X.org"

@rem Add version info to Microsoft Vulkan over Direct3D 12 driver
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Microsoft Vulkan over Direct3D 12 driver" "%devroot%\%projectname%\bin\%abi%\vulkan_dzn.dll" %abi% %mesaver% "Microsoft Corporation"

@rem Add version info to Mesa3D Vulkan driver for gfxstream virtual GPU
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Mesa3D Vulkan driver for gfxstream virtual GPU" "%devroot%\%projectname%\bin\%abi%\vulkan_gfxstream.dll" %abi% %mesaver% "Mesa/X.org"
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Mesa3D Vulkan driver for gfxstream virtual GPU" "%devroot%\%projectname%\bin\%abi%\libvulkan_gfxstream.dll" %abi% %mesaver% "Mesa/X.org"

@rem Add version info to Microsoft OpenCL compiler and driver
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Microsoft OpenCL compiler" "%devroot%\%projectname%\bin\%abi%\clglon12compiler.dll" %abi% %mesaver% "Microsoft Corporation"
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Microsoft OpenCL compiler" "%devroot%\%projectname%\bin\%abi%\clon12compiler.dll" %abi% %mesaver% "Microsoft Corporation"
@if %gitstate% GTR 0 IF EXIST "%devroot%\clon12\" cd "%devroot%\clon12"
@if %gitstate% GTR 0 IF EXIST "%devroot%\clon12\" for /f tokens^=1^-3^ delims^=^-^,^  %%a IN ('git show -s --format^=%%ci') DO @call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Microsoft OpenCL over D3D12 driver" "%devroot%\%projectname%\bin\%abi%\openclon12.dll" %abi% %%a.%%b.%%c "Microsoft Corporation"

@rem Add version info to clover OpenCL driver and runtime
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Mesa3D clover OpenCL driver" "%devroot%\%projectname%\bin\%abi%\MesaOpenCL.dll" %abi% %mesaver% "Mesa/X.org"
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Mesa3D clover OpenCL runtime" "%devroot%\%projectname%\bin\%abi%\OpenCL.dll" %abi% %mesaver% "Mesa/X.org"
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Mesa3D swrast pipe-loader" "%devroot%\%projectname%\bin\%abi%\pipe_swrast.dll" %abi% %mesaver% "Mesa/X.org"

@rem Add version info to Mesa3D D3D10 software rendering driver
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Mesa3D D3D10 software rendering driver" "%devroot%\%projectname%\bin\%abi%\d3d10sw.dll" %abi% %mesaver% "VMware Inc."
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Mesa3D D3D10 software rendering driver" "%devroot%\%projectname%\bin\%abi%\d3d10warp.dll" %abi% %mesaver% "VMware Inc."

@rem Add version info to Gallium raw interface without API frontend
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Gallium raw interface with GDI window support" "%devroot%\%projectname%\bin\%abi%\graw.dll" %abi% %mesaver% "Mesa/X.org"
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Gallium raw interface without window support" "%devroot%\%projectname%\bin\%abi%\graw_null.dll" %abi% %mesaver% "Mesa/X.org"

@rem Add version info to Mesa3D off-screen rendering drivers
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Mesa3D off-screen rendering classic driver" "%devroot%\%projectname%\bin\%abi%\osmesa-swrast\osmesa.dll" %abi% %mesaver% "Mesa/X.org"
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Mesa3D off-screen rendering gallium driver" "%devroot%\%projectname%\bin\%abi%\osmesa-gallium\osmesa.dll" %abi% %mesaver% "Mesa/X.org"
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Mesa3D off-screen rendering gallium driver" "%devroot%\%projectname%\bin\%abi%\osmesa.dll" %abi% %mesaver% "Mesa/X.org"

@rem Add version info to Microsoft SPIR-V to DXIL library
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Microsoft SPIR-V to DXIL library" "%devroot%\%projectname%\bin\%abi%\spirv_to_dxil.dll" %abi% %mesaver% "Microsoft Corporation"
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Microsoft SPIR-V to DXIL library" "%devroot%\%projectname%\bin\%abi%\libspirv_to_dxil.dll" %abi% %mesaver% "Microsoft Corporation"

@rem Add version info to Microsoft D3D12 VA-API driver and library
@IF EXIST "%devroot%\libva\build\%abi%\lib\pkgconfig\libva.pc" for /f tokens^=1^,2^ delims^=^=^ eol^= %%a IN ('type "%devroot%\libva\build\%abi%\lib\pkgconfig\libva.pc"') DO @IF "%%a"=="libva_version" (
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Userspace Video acceleration core interface" "%devroot%\%projectname%\bin\%abi%\va.dll" %abi% %%b "Intel Corporation"
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Userspace Video acceleration Win32 interface" "%devroot%\%projectname%\bin\%abi%\va_win32.dll" %abi% %%b "Microsoft Corporation"
)
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Microsoft VA-API over D3D12 driver" "%devroot%\%projectname%\bin\%abi%\vaon12_drv_video.dll" %abi% %mesaver% "Microsoft Corporation"
@call "%devroot%\%projectname%\buildscript\modules\rcgen.cmd" "Microsoft VA-API over D3D12 driver" "%devroot%\%projectname%\bin\%abi%\libvaon12_drv_video.dll" %abi% %mesaver% "Microsoft Corporation"

@echo Done
@echo.

:nomesaverinfo
@endlocal