@setlocal
@rem Get Mesa3D version
@set /p mesaver=<%devroot%\mesa\VERSION
@if "%mesaver:~5,2%"=="0-" set mesaver=%mesaver:~0,6%

@rem Check if resource hacker can be reached.
@IF %rhstate%==0 GOTO noresourcehacker
@IF %rhstate%==1 SET PATH=%devroot%\resource-hacker\;%PATH%

@pause
@echo.
@echo Adding version information to binaries. Please wait...
@echo.

@rem Add version info to desktop OpenGL drivers stack
@IF NOT EXIST %devroot%\%projectname%\bin\%abi%\libgallium_wgl.dll call %devroot%\%projectname%\buildscript\modules\rcgen.cmd "Mesa3D desktop OpenGL drivers stack" %devroot%\%projectname%\bin\%abi%\opengl32.dll %abi% %mesaver% "Mesa/X.org"
@IF EXIST %devroot%\%projectname%\bin\%abi%\libgallium_wgl.dll call %devroot%\%projectname%\buildscript\modules\rcgen.cmd "Mesa3D WGL loader" %devroot%\%projectname%\bin\%abi%\opengl32.dll %abi% %mesaver% "Mesa/X.org"
@IF EXIST %devroot%\%projectname%\bin\%abi%\libgallium_wgl.dll call %devroot%\%projectname%\buildscript\modules\rcgen.cmd "Mesa3D desktop OpenGL drivers stack" %devroot%\%projectname%\bin\%abi%\libgallium_wgl.dll %abi% %mesaver% "Mesa/X.org"

@rem Add version info to Microsoft desktop OpenGL over D3D12 driver
@call %devroot%\%projectname%\buildscript\modules\rcgen.cmd "Mesa3D desktop OpenGL over D3D12 driver" %devroot%\%projectname%\bin\%abi%\openglon12.dll %abi% %mesaver% "Microsoft Corporation"

@rem Add version info to Intel swr desktop OpenGL driver
@call %devroot%\%projectname%\buildscript\modules\rcgen.cmd "Mesa3D swr desktop OpenGL software rendering driver running on AVX instruction set" %devroot%\%projectname%\bin\%abi%\swrAVX.dll null %mesaver% "Intel"
@call %devroot%\%projectname%\buildscript\modules\rcgen.cmd "Mesa3D swr desktop OpenGL software rendering driver running on AVX2 instruction set" %devroot%\%projectname%\bin\%abi%\swrAVX2.dll null %mesaver% "Intel"
@call %devroot%\%projectname%\buildscript\modules\rcgen.cmd "Mesa3D swr desktop OpenGL software rendering driver running on Skylake-X variant of AVX512 instruction set" %devroot%\%projectname%\bin\%abi%\swrSKX.dll null %mesaver% "Intel"
@call %devroot%\%projectname%\buildscript\modules\rcgen.cmd "Mesa3D swr desktop OpenGL software rendering driver running on Knights Landing variant of AVX512 instruction set" %devroot%\%projectname%\bin\%abi%\swrKNL.dll null %mesaver% "Intel"

@rem Add version info to shared glapi library
@call %devroot%\%projectname%\buildscript\modules\rcgen.cmd "Mesa3D shared glapi library" %devroot%\%projectname%\bin\%abi%\libglapi.dll %abi% %mesaver% "Mesa/X.org"

@rem Add version info to Mesa3D EGL library
@call %devroot%\%projectname%\buildscript\modules\rcgen.cmd "Mesa3D EGL library" %devroot%\%projectname%\bin\%abi%\libEGL.dll %abi% %mesaver% "Mesa/X.org"

@rem Add version info to standalone OpenGL ES 1.x driver
@call %devroot%\%projectname%\buildscript\modules\rcgen.cmd "Mesa3D standalone OpenGL ES 1.x driver" %devroot%\%projectname%\bin\%abi%\libGLESv1_CM.dll %abi% %mesaver% "Mesa/X.org"

@rem Add version info to standalone OpenGL ES 2.x and 3.x driver
@call %devroot%\%projectname%\buildscript\modules\rcgen.cmd "Mesa3D standalone OpenGL ES 2.x and 3.x driver" %devroot%\%projectname%\bin\%abi%\libGLESv2.dll %abi% %mesaver% "Mesa/X.org"

@rem Add version info to Mesa3D Vulkan software rendering driver
@call %devroot%\%projectname%\buildscript\modules\rcgen.cmd "Mesa3D Vulkan software rendering driver" %devroot%\%projectname%\bin\%abi%\vulkan_lvp.dll %abi% %mesaver% "Mesa/X.org"

@rem Add version info to Mesa3D Vulkan driver for AMD cards
@call %devroot%\%projectname%\buildscript\modules\rcgen.cmd "Mesa3D Vulkan driver for AMD cards" %devroot%\%projectname%\bin\%abi%\vulkan_radeon.dll null %mesaver% "Mesa/X.org"

@rem Add version info to Microsoft OpenCL compiler
@call %devroot%\%projectname%\buildscript\modules\rcgen.cmd "Microsoft OpenCL compiler" %devroot%\%projectname%\bin\%abi%\clglon12compiler.dll %abi% %mesaver% "Microsoft Corporation"
@call %devroot%\%projectname%\buildscript\modules\rcgen.cmd "Microsoft OpenCL compiler" %devroot%\%projectname%\bin\%abi%\clon12compiler.dll %abi% %mesaver% "Microsoft Corporation"

@rem Add version info to Mesa3D D3D10 software rendering driver
@call %devroot%\%projectname%\buildscript\modules\rcgen.cmd "Mesa3D D3D10 software rendering driver" %devroot%\%projectname%\bin\%abi%\d3d10sw.dll %abi% %mesaver% "VMware Inc."

@rem Add version info to Mesa3D test framework
@call %devroot%\%projectname%\buildscript\modules\rcgen.cmd "Mesa3D test framework with GDI window support" %devroot%\%projectname%\bin\%abi%\graw.dll %abi% %mesaver% "Mesa/X.org"
@call %devroot%\%projectname%\buildscript\modules\rcgen.cmd "Mesa3D test framework without window support" %devroot%\%projectname%\bin\%abi%\graw_null.dll %abi% %mesaver% "Mesa/X.org"

@rem Add version info to Mesa3D off-screen rendering drivers
@call %devroot%\%projectname%\buildscript\modules\rcgen.cmd "Mesa3D off-screen rendering classic driver" %devroot%\%projectname%\bin\%abi%\osmesa-swrast\osmesa.dll %abi% %mesaver% "Mesa/X.org"
@call %devroot%\%projectname%\buildscript\modules\rcgen.cmd "Mesa3D off-screen rendering gallium driver" %devroot%\%projectname%\bin\%abi%\osmesa-gallium\osmesa.dll %abi% %mesaver% "Mesa/X.org"
@call %devroot%\%projectname%\buildscript\modules\rcgen.cmd "Mesa3D off-screen rendering gallium driver" %devroot%\%projectname%\bin\%abi%\osmesa.dll %abi% %mesaver% "Mesa/X.org"

@rem Add version info to Microsoft SPIR-V to DXIL library
@call %devroot%\%projectname%\buildscript\modules\rcgen.cmd "Microsoft SPIR-V to DXIL library" %devroot%\%projectname%\bin\%abi%\spirv_to_dxil.dll %abi% %mesaver% "Microsoft Corporation"

@echo Done
@echo.

:noresourcehacker
@endlocal