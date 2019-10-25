@setlocal
@IF %mesabldsys%==scons set mesonloc=null
@IF %mesabldsys%==scons GOTO foundmeson
@IF %mesabldsys%==meson IF %toolchain%==gcc IF %abi%==x86 set mesonloc=%msysloc%\usr\bin\bash --login -c "cd $mesa/mesa;/mingw32/bin/meson
@IF %mesabldsys%==meson IF %toolchain%==gcc IF %abi%==x64 set mesonloc=%msysloc%\usr\bin\bash --login -c "cd $mesa/mesa;/mingw64/bin/meson
@IF %mesabldsys%==meson IF %toolchain%==gcc GOTO foundmeson
@IF %mesonstate%==2 set mesonloc=meson.exe
@IF %mesonstate%==2 GOTO foundmeson

@set mesonloc=%pythonloc:~0,-10%Scripts\meson.exe
@IF NOT EXIST %mesonloc% set mesonloc=%pythonloc% %mesonloc:~0,-3%py

:foundmeson
@endlocal&set mesonloc=%mesonloc%
