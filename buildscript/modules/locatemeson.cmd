@setlocal
@IF NOT %toolchain%==msvc set mesonloc=%runmsys% /%LMSYSTEM%/bin/meson
@IF NOT %toolchain%==msvc GOTO foundmeson
@set mesonloc="%devroot%\%projectname%\buildscript\assets\venv\Scripts\meson.exe"
@IF NOT EXIST %mesonloc% set mesonloc="%devroot%\%projectname%\buildscript\assets\venv\Scripts\python.exe" %mesonloc:~0,-4%py"

:foundmeson
@endlocal&set mesonloc=%mesonloc%
