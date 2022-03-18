@setlocal
@rem Git version control. Can either be always present (2) or missing (0).
@CMD /C EXIT 0
@set gitstate=2
@where /q git.exe
@if NOT "%ERRORLEVEL%"=="0" set gitstate=0

@set gitloc=null
@IF %gitstate% GTR 0 set exitloop=1
@IF %gitstate% GTR 0 FOR /F delims^=^ eol^= %%a IN ('where /f git.exe') DO @IF defined exitloop (
set "exitloop="
SET gitloc=%%~a
)
@IF %gitstate% GTR 0 set gitloc=/%gitloc:~0,1%%gitloc:~2,-8%
@endlocal&set gitstate=%gitstate%&set gitloc=%gitloc:\=/%