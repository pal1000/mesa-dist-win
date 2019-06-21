@rem Get Mesa3D version
@set /p mesaver=<%mesa%\mesa\VERSION
@if "%mesaver:~5,2%"=="0-" set mesaver=%mesaver:~0,6%

@rem Check if resource hacker can be reached.
@set rhstate=2
@set ERRORLEVEL=0
@where /q ResourceHacker.exe
@IF ERRORLEVEL 1 set rhstate=1
@IF %rhstate%==1 IF NOT EXIST %mesa%\resource-hacker\ResourceHacker.exe set rhstate=0&GOTO noresourcehacker
@IF %rhstate%==1 SET PATH=%mesa%\resource-hacker\;%PATH%

@rem Create folder to store generated resource files
@IF NOT EXIST %mesa%\mesa-dist-win\buildscript\assets md %mesa%\mesa-dist-win\buildscript\assets

@pause
@echo.
@echo Adding version information to binaries. Please wait...
@echo.

@rem Add version info to default desktop OpenGL driver
@IF EXIST %mesa%\mesa-dist-win\bin\%abi%\opengl32.dll call %mesa%\mesa-dist-win\buildscript\modules\rcgen.cmd "Mesa3D default desktop OpenGL software rendering driver" opengl32 %abi% %mesaver% "VMware Inc."
@IF EXIST %mesa%\mesa-dist-win\bin\%abi%\opengl32.dll ResourceHacker.exe -open %mesa%\mesa-dist-win\buildscript\assets\temp.rc -save %mesa%\mesa-dist-win\buildscript\assets\temp.res -action compile -log NUL
@IF EXIST %mesa%\mesa-dist-win\bin\%abi%\opengl32.dll ResourceHacker.exe -open %mesa%\mesa-dist-win\bin\%abi%\opengl32.dll -save %mesa%\mesa-dist-win\bin\%abi%\opengl32.dll -action addoverwrite -resource %mesa%\mesa-dist-win\buildscript\assets\temp.res -log NUL

@rem Add version info to shared glapi library
@IF EXIST %mesa%\mesa-dist-win\bin\%abi%\libglapi.dll call %mesa%\mesa-dist-win\buildscript\modules\rcgen.cmd "Mesa3D shared glapi library" libglapi %abi% %mesaver% "VMware Inc."
@IF EXIST %mesa%\mesa-dist-win\bin\%abi%\libglapi.dll ResourceHacker.exe -open %mesa%\mesa-dist-win\buildscript\assets\temp.rc -save %mesa%\mesa-dist-win\buildscript\assets\temp.res -action compile -log NUL
@IF EXIST %mesa%\mesa-dist-win\bin\%abi%\libglapi.dll ResourceHacker.exe -open %mesa%\mesa-dist-win\bin\%abi%\libglapi.dll -save %mesa%\mesa-dist-win\bin\%abi%\libglapi.dll -action addoverwrite -resource %mesa%\mesa-dist-win\buildscript\assets\temp.res -log NUL

@rem Add version info to standalone OpenGL ES 1.x driver
@IF EXIST %mesa%\mesa-dist-win\bin\%abi%\libGLESv1_CM.dll call %mesa%\mesa-dist-win\buildscript\modules\rcgen.cmd "Mesa3D standalone OpenGL ES 1.x driver" libGLESv1_CM %abi% %mesaver% "VMware Inc."
@IF EXIST %mesa%\mesa-dist-win\bin\%abi%\libGLESv1_CM.dll ResourceHacker.exe -open %mesa%\mesa-dist-win\buildscript\assets\temp.rc -save %mesa%\mesa-dist-win\buildscript\assets\temp.res -action compile -log NUL
@IF EXIST %mesa%\mesa-dist-win\bin\%abi%\libGLESv1_CM.dll ResourceHacker.exe -open %mesa%\mesa-dist-win\bin\%abi%\libGLESv1_CM.dll -save %mesa%\mesa-dist-win\bin\%abi%\libGLESv1_CM.dll -action addoverwrite -resource %mesa%\mesa-dist-win\buildscript\assets\temp.res -log NUL

@rem Add version info to standalone OpenGL ES 2.x and 3.x driver
@IF EXIST %mesa%\mesa-dist-win\bin\%abi%\libGLESv2.dll call %mesa%\mesa-dist-win\buildscript\modules\rcgen.cmd "Mesa3D standalone OpenGL ES 2.x and 3.x driver" libGLESv2 %abi% %mesaver% "VMware Inc."
@IF EXIST %mesa%\mesa-dist-win\bin\%abi%\libGLESv2.dll ResourceHacker.exe -open %mesa%\mesa-dist-win\buildscript\assets\temp.rc -save %mesa%\mesa-dist-win\buildscript\assets\temp.res -action compile -log NUL
@IF EXIST %mesa%\mesa-dist-win\bin\%abi%\libGLESv2.dll ResourceHacker.exe -open %mesa%\mesa-dist-win\bin\%abi%\libGLESv2.dll -save %mesa%\mesa-dist-win\bin\%abi%\libGLESv2.dll -action addoverwrite -resource %mesa%\mesa-dist-win\buildscript\assets\temp.res -log NUL

@rem Add version info to Mesa3D test framework
@IF EXIST %mesa%\mesa-dist-win\bin\%abi%\graw.dll call %mesa%\mesa-dist-win\buildscript\modules\rcgen.cmd "Mesa3D test framework with GDI window support" graw %abi% %mesaver% "VMware Inc."
@IF EXIST %mesa%\mesa-dist-win\bin\%abi%\graw.dll ResourceHacker.exe -open %mesa%\mesa-dist-win\buildscript\assets\temp.rc -save %mesa%\mesa-dist-win\buildscript\assets\temp.res -action compile -log NUL
@IF EXIST %mesa%\mesa-dist-win\bin\%abi%\graw.dll ResourceHacker.exe -open %mesa%\mesa-dist-win\bin\%abi%\graw.dll -save %mesa%\mesa-dist-win\bin\%abi%\graw.dll -action addoverwrite -resource %mesa%\mesa-dist-win\buildscript\assets\temp.res -log NUL

@rem Add version info to Intel swr desktop OpenGL driver
@IF EXIST %mesa%\mesa-dist-win\bin\%abi%\swrAVX.dll call %mesa%\mesa-dist-win\buildscript\modules\rcgen.cmd "Mesa3D swr desktop OpenGL software rendering driver running on AVX instruction set" swrAVX null %mesaver% "Intel"
@IF EXIST %mesa%\mesa-dist-win\bin\%abi%\swrAVX.dll ResourceHacker.exe -open %mesa%\mesa-dist-win\buildscript\assets\temp.rc -save %mesa%\mesa-dist-win\buildscript\assets\temp.res -action compile -log NUL
@IF EXIST %mesa%\mesa-dist-win\bin\%abi%\swrAVX.dll ResourceHacker.exe -open %mesa%\mesa-dist-win\bin\%abi%\swrAVX.dll -save %mesa%\mesa-dist-win\bin\%abi%\swrAVX.dll -action addoverwrite -resource %mesa%\mesa-dist-win\buildscript\assets\temp.res -log NUL
@IF EXIST %mesa%\mesa-dist-win\bin\%abi%\swrAVX2.dll call %mesa%\mesa-dist-win\buildscript\modules\rcgen.cmd "Mesa3D swr desktop OpenGL software rendering driver running on AVX2 instruction set" swrAVX2 null %mesaver% "Intel"
@IF EXIST %mesa%\mesa-dist-win\bin\%abi%\swrAVX2.dll ResourceHacker.exe -open %mesa%\mesa-dist-win\buildscript\assets\temp.rc -save %mesa%\mesa-dist-win\buildscript\assets\temp.res -action compile -log NUL
@IF EXIST %mesa%\mesa-dist-win\bin\%abi%\swrAVX2.dll ResourceHacker.exe -open %mesa%\mesa-dist-win\bin\%abi%\swrAVX2.dll -save %mesa%\mesa-dist-win\bin\%abi%\swrAVX2.dll -action addoverwrite -resource %mesa%\mesa-dist-win\buildscript\assets\temp.res -log NUL

@rem Add version info to Mesa3D off-screen rendering drivers
@IF EXIST %mesa%\mesa-dist-win\bin\%abi%\osmesa-swrast\osmesa.dll call %mesa%\mesa-dist-win\buildscript\modules\rcgen.cmd "Mesa3D off-screen rendering classic driver" osmesa %abi% %mesaver% "VMware Inc."
@IF EXIST %mesa%\mesa-dist-win\bin\%abi%\osmesa-swrast\osmesa.dll ResourceHacker.exe -open %mesa%\mesa-dist-win\buildscript\assets\temp.rc -save %mesa%\mesa-dist-win\buildscript\assets\temp.res -action compile -log NUL
@IF EXIST %mesa%\mesa-dist-win\bin\%abi%\osmesa-swrast\osmesa.dll ResourceHacker.exe -open %mesa%\mesa-dist-win\bin\%abi%\osmesa-swrast\osmesa.dll -save %mesa%\mesa-dist-win\bin\%abi%\osmesa-swrast\osmesa.dll -action addoverwrite -resource %mesa%\mesa-dist-win\buildscript\assets\temp.res -log NUL
@IF EXIST %mesa%\mesa-dist-win\bin\%abi%\osmesa-gallium\osmesa.dll call %mesa%\mesa-dist-win\buildscript\modules\rcgen.cmd "Mesa3D off-screen rendering gallium driver" osmesa %abi% %mesaver% "VMware Inc."
@IF EXIST %mesa%\mesa-dist-win\bin\%abi%\osmesa-gallium\osmesa.dll ResourceHacker.exe -open %mesa%\mesa-dist-win\buildscript\assets\temp.rc -save %mesa%\mesa-dist-win\buildscript\assets\temp.res -action compile -log NUL
@IF EXIST %mesa%\mesa-dist-win\bin\%abi%\osmesa-gallium\osmesa.dll ResourceHacker.exe -open %mesa%\mesa-dist-win\bin\%abi%\osmesa-gallium\osmesa.dll -save %mesa%\mesa-dist-win\bin\%abi%\osmesa-gallium\osmesa.dll -action addoverwrite -resource %mesa%\mesa-dist-win\buildscript\assets\temp.res -log NUL

@echo Done
@echo.

:noresourcehacker