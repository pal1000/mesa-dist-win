@setlocal
@echo Applying patch %*...
@IF NOT EXIST %msysloc%\usr\bin\patch.exe git apply --check --apply %devroot%\%projectname%\patches\%*.patch
@IF EXIST %msysloc%\usr\bin\patch.exe %runmsys% cd $(/usr/bin/cygpath -m ${msyspatchdir});patch -Np1 --no-backup-if-mismatch -r - -i $(/usr/bin/cygpath -m ${devroot})/${projectname}/patches/%*.patch
@echo.
@endlocal