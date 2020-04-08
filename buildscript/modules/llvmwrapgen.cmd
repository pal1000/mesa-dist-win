@setlocal
@set RTTI=false
@IF %toolchain%==msvc FOR /F "tokens=* USEBACKQ" %%a IN (`%LLVM%\bin\llvm-config --link-static --libnames engine coroutines`) DO @SET llvmlibs=%%~a
@IF %toolchain%==msvc FOR /F "tokens=* USEBACKQ" %%a IN (`%LLVM%\bin\llvm-config --version`) DO @SET llvmver=%%~a
@IF %toolchain%==msvc FOR /F "tokens=* USEBACKQ" %%a IN (`%LLVM%\bin\llvm-config --has-rtti`) DO @IF /I "%%a"=="YES" SET RTTI=true
@IF %toolchain%==gcc FOR /F "tokens=* USEBACKQ" %%a IN (`%msysloc%\usr\bin\bash --login -c "${MINGW_PREFIX}/bin/llvm-config --link-static --libnames engine coroutines"`) DO @SET llvmlibs=%%~a
@IF %toolchain%==gcc FOR /F "tokens=* USEBACKQ" %%a IN (`%msysloc%\usr\bin\bash --login -c "${MINGW_PREFIX}/bin/llvm-config --version"`) DO @SET llvmver=%%~a
@IF %toolchain%==gcc FOR /F "tokens=* USEBACKQ" %%a IN (`%msysloc%\usr\bin\bash --login -c "${MINGW_PREFIX}/bin/llvm-config --has-rtti"`) DO @IF /I "%%a"=="YES" SET RTTI=true
@IF %toolchain%==msvc set llvmlibs=%llvmlibs:.lib=%
@IF %toolchain%==gcc set llvmlibs=%llvmlibs:.a=%
@set llvmlibs='%llvmlibs: =', '%'
@IF NOT EXIST %devroot%\mesa\subprojects\llvm md %devroot%\mesa\subprojects\llvm
@(echo project^('llvm', ['cpp']^)
echo.
echo cpp = meson.get_compiler^('cpp'^)
echo.
echo _deps = []
echo _search = run_command^('%devroot:\=/%/%projectname%/buildscript/modules/llvmloc.cmd', '/lib'^).stdout^(^).strip^(^)
echo foreach d ^: [%llvmlibs%]
echo   _deps += cpp.find_library^(d, dirs ^: _search^)
echo endforeach
echo.
echo dep_llvm = declare_dependency^(
echo   include_directories ^: include_directories^(run_command^('%devroot:\=/%/%projectname%/buildscript/modules/llvmloc.cmd', '/include'^).stdout^(^).strip^(^)^),
echo   dependencies ^: _deps,
echo   version ^: '%llvmver%',
echo ^)
echo.
echo has_rtti = %RTTI%
echo irbuilder_h = files^(run_command^('%devroot:\=/%/%projectname%/buildscript/modules/llvmloc.cmd', '/include/llvm/IR/IRBuilder.h'^).stdout^(^).strip^(^)^)
)>%devroot%\mesa\subprojects\llvm\meson.build
@endlocal