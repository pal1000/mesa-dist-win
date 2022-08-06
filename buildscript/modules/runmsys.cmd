@set CD=
@IF %gitstate% GTR 0 echo PATH^=${PATH}^:${gitloc};cp -f ${USERPROFILE}/.gitconfig ~;cd "%CD%";%*  >"%devroot%\%projectname%\buildscript\assets\temp.sh"
@IF %gitstate% EQU 0 echo cd "%CD%";%*  >"%devroot%\%projectname%\buildscript\assets\temp.sh"
@"%msysloc%\usr\bin\bash.exe" -l "%devroot%\%projectname%\buildscript\assets\temp.sh"