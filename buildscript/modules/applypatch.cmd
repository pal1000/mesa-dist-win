@setlocal
@echo Applying patch %*...
@IF %toolchain%==msvc git apply --check --apply %mesa%\mesa-dist-win\patches\%*.patch
@IF %toolchain%==msvc echo.
@IF %toolchain%==gcc %msysloc%\usr\bin\bash --login -c "cd $mesa/mesa;patch -Np1 --no-backup-if-mismatch -r - -i $mesa/mesa-dist-win/patches/%*.patch"
@IF %toolchain%==gcc echo.
@endlocal