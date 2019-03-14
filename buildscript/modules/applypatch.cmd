@IF %toolchain%==msvc git apply --check --apply %mesa%\mesa-dist-win\patches\%*.patch
@IF %toolchain%==msvc echo.
@IF %toolchain%==gcc %runmsys% cd $mesa/mesa;patch -Np1 -r - -i "%mesa%\mesa-dist-win\patches\%*.patch"