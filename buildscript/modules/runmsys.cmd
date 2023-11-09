@IF %gitstate% GTR 0 for /f tokens^=2^ delims^=^\^ eol^= %%a IN ('whoami') DO @IF NOT EXIST "%msysloc%\home\%%a\.gitconfig" (
@echo [include]
@echo path ^= %USERPROFILE:\=\\%\\.gitconfig
)>"%msysloc%\home\%%a\.gitconfig"
@set CD=
@IF %gitstate% GTR 0 echo PATH^=${PATH}^:${gitloc};cd "%CD:\=\\%";%*  >"%devroot%\%projectname%\buildscript\assets\temp.sh"
@IF %gitstate% EQU 0 echo cd "%CD:\=\\%";%*  >"%devroot%\%projectname%\buildscript\assets\temp.sh"
@"%msysloc%\usr\bin\bash.exe" -l "%devroot%\%projectname%\buildscript\assets\temp.sh"