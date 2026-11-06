@set mesonoption=0
@IF EXIST "%devroot%\%1\meson_options.txt" for /f %%a IN ('type "%devroot%\%1\meson_options.txt"') DO @IF "%%a"=="'%2'," set mesonoption=1
@IF EXIST "%devroot%\%1\meson.options" for /f %%a IN ('type "%devroot%\%1\meson.options"') DO @IF "%%a"=="'%2'," set mesonoption=1


