@setlocal
@IF %toolchain%==gcc set mesonloc=%msysloc%\usr\bin\bash --login -c "cd $(/usr/bin/cygpath -m ${devroot})/mesa;
@IF %toolchain%==gcc IF /I NOT %gitloc%==null set mesonloc=%mesonloc%PATH=${PATH}:${gitloc};
@IF %toolchain%==gcc set mesonloc=%mesonloc%${MINGW_PREFIX}/bin/meson
@IF %toolchain%==gcc GOTO foundmeson
@IF %mesonstate%==2 set mesonloc=meson.exe
@IF %mesonstate%==2 GOTO foundmeson

@set mesonloc=%pythonloc:~0,-10%Scripts\meson.exe
@IF NOT EXIST %mesonloc% set mesonloc=%pythonloc% %mesonloc:~0,-3%py

:foundmeson
@endlocal&set mesonloc=%mesonloc%
