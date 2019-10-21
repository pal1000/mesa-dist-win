@setlocal
@rem Get Mesa3D version
@set /p mesaver=<%mesa%\mesa\VERSION
@if "%mesaver:~5,2%"=="0-" set mesaver=%mesaver:~0,6%

@rem Check if resource hacker can be reached.
@IF %rhstate%==0 GOTO noresourcehacker
@IF %rhstate%==1 SET PATH=%mesa%\resource-hacker\;%PATH%

@rem Create folder to store generated resource files
@IF NOT EXIST %mesa%\mesa-dist-win\buildscript\assets md %mesa%\mesa-dist-win\buildscript\assets

@pause
@echo.
@echo Adding version information to binaries. Please wait...
@echo.

@rem Add version info to default desktop OpenGL driver
@call %mesa%\mesa-dist-win\buildscript\modules\rcgen.cmd "Mesa3D default desktop OpenGL software rendering driver" %mesa%\mesa-dist-win\bin\%abi%\opengl32.dll %abi% %mesaver% "VMware Inc."
@rem Add version info to shared glapi library
@call %mesa%\mesa-dist-win\buildscript\modules\rcgen.cmd "Mesa3D shared glapi library" %mesa%\mesa-dist-win\bin\%abi%\libglapi.dll %abi% %mesaver% "VMware Inc."
@rem Add version info to standalone OpenGL ES 1.x driver
@call %mesa%\mesa-dist-win\buildscript\modules\rcgen.cmd "Mesa3D standalone OpenGL ES 1.x driver" %mesa%\mesa-dist-win\bin\%abi%\libGLESv1_CM.dll %abi% %mesaver% "VMware Inc."
@rem Add version info to standalone OpenGL ES 2.x and 3.x driver
@call %mesa%\mesa-dist-win\buildscript\modules\rcgen.cmd "Mesa3D standalone OpenGL ES 2.x and 3.x driver" %mesa%\mesa-dist-win\bin\%abi%\libGLESv2.dll %abi% %mesaver% "VMware Inc."
@rem Add version info to Mesa3D test framework
@call %mesa%\mesa-dist-win\buildscript\modules\rcgen.cmd "Mesa3D test framework with GDI window support" %mesa%\mesa-dist-win\bin\%abi%\graw.dll %abi% %mesaver% "VMware Inc."
@call %mesa%\mesa-dist-win\buildscript\modules\rcgen.cmd "Mesa3D test framework without window support" %mesa%\mesa-dist-win\bin\%abi%\graw_null.dll %abi% %mesaver% "VMware Inc."
@rem Add version info to Intel swr desktop OpenGL driver
@call %mesa%\mesa-dist-win\buildscript\modules\rcgen.cmd "Mesa3D swr desktop OpenGL software rendering driver running on AVX instruction set" %mesa%\mesa-dist-win\bin\%abi%\swrAVX.dll null %mesaver% "Intel"
@call %mesa%\mesa-dist-win\buildscript\modules\rcgen.cmd "Mesa3D swr desktop OpenGL software rendering driver running on AVX2 instruction set" %mesa%\mesa-dist-win\bin\%abi%\swrAVX2.dll null %mesaver% "Intel"
@rem Add version info to Mesa3D off-screen rendering drivers
@call %mesa%\mesa-dist-win\buildscript\modules\rcgen.cmd "Mesa3D off-screen rendering classic driver" %mesa%\mesa-dist-win\bin\%abi%\osmesa-swrast\osmesa.dll %abi% %mesaver% "VMware Inc."
@call %mesa%\mesa-dist-win\buildscript\modules\rcgen.cmd "Mesa3D off-screen rendering gallium driver" %mesa%\mesa-dist-win\bin\%abi%\osmesa-gallium\osmesa.dll %abi% %mesaver% "VMware Inc."
@call %mesa%\mesa-dist-win\buildscript\modules\rcgen.cmd "Mesa3D off-screen rendering gallium driver" %mesa%\mesa-dist-win\bin\%abi%\osmesa.dll %abi% %mesaver% "VMware Inc."

@echo Done
@echo.

:noresourcehacker
@endlocal