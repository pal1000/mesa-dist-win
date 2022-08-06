@IF %gitstate% GTR 0 echo PATH^=${PATH}^:${gitloc};cp -f ${USERPROFILE}/.gitconfig ~;%*  >"%devroot%\%projectname%\buildscript\assets\temp.sh"
@IF %gitstate% EQU 0 echo %*  >"%devroot%\%projectname%\buildscript\assets\temp.sh"
@"%msysloc%\usr\bin\bash.exe" -l "%devroot%\%projectname%\buildscript\assets\temp.sh"