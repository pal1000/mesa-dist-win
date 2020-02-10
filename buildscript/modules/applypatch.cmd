@setlocal
@echo Applying patch %*...
@IF %toolchain%==msvc git apply --check --apply %devroot%\%projectname%\patches\%*.patch
@IF %toolchain%==gcc %msysloc%\usr\bin\bash --login -c "cd ${devroot}/mesa;patch -Np1 --no-backup-if-mismatch -r - -i ${devroot}/%projectname%/patches/%*.patch"
@echo.
@endlocal