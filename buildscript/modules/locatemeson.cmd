@setlocal
@IF %toolchain%==gcc IF %abi%==x86 set mesonloc=%msysloc%\usr\bin\bash --login -c "cd ${devroot}/mesa;/mingw32/bin/meson
@IF %toolchain%==gcc IF %abi%==x64 set mesonloc=%msysloc%\usr\bin\bash --login -c "cd ${devroot}/mesa;/mingw64/bin/meson
@IF %toolchain%==gcc GOTO foundmeson
@IF %mesonstate%==2 set mesonloc=meson.exe
@IF %mesonstate%==2 GOTO foundmeson

@set mesonloc=%pythonloc:~0,-10%Scripts\meson.exe
@IF NOT EXIST %mesonloc% set mesonloc=%pythonloc% %mesonloc:~0,-3%py

:foundmeson
@endlocal&set mesonloc=%mesonloc%
