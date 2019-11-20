@setlocal
@set RTTI=false
@IF %toolchain%==msvc FOR /F "tokens=* USEBACKQ" %%a IN (`%LLVM%\bin\llvm-config --libnames engine coroutines`) DO @SET llvmlibs=%%~a
@IF %toolchain%==msvc FOR /F "tokens=* USEBACKQ" %%a IN (`%LLVM%\bin\llvm-config --version`) DO @SET llvmver=%%~a
@IF %toolchain%==msvc FOR /F "tokens=* USEBACKQ" %%a IN (`%LLVM%\bin\llvm-config --has-rtti`) DO @IF /I "%%a"=="YES" SET RTTI=true
@IF %toolchain%==gcc FOR /F "tokens=* USEBACKQ" %%a IN (`%msysloc%\usr\bin\bash --login -c "%LLVM%/bin/llvm-config --libnames engine coroutines"`) DO @SET llvmlibs=%%~a
@IF %toolchain%==gcc FOR /F "tokens=* USEBACKQ" %%a IN (`%msysloc%\usr\bin\bash --login -c "%LLVM%/bin/llvm-config --version"`) DO @SET llvmver=%%~a
@IF %toolchain%==gcc FOR /F "tokens=* USEBACKQ" %%a IN (`%msysloc%\usr\bin\bash --login -c "%LLVM%/bin/llvm-config --has-rtti"`) DO @IF /I "%%a"=="YES" SET RTTI=true
@IF %toolchain%==msvc set llvmlibs=%llvmlibs:.lib=%
@IF %toolchain%==gcc set llvmlibs=%llvmlibs:.a=%
@set llvmlibs='%llvmlibs: =', '%'
@IF NOT EXIST %mesa%\mesa\subprojects\llvm md %mesa%\mesa\subprojects\llvm
@(echo project^('llvm', ['cpp']^)
echo.
echo cpp = meson.get_compiler^('cpp'^)
echo.
echo _deps = []
IF %toolchain%==msvc echo _search = '%LLVM:\=/%/lib'
IF %toolchain%==gcc echo _search = '%msysloc:\=/%%LLVM:\=/%/lib'
echo foreach d ^: [%llvmlibs%]
echo   _deps += cpp.find_library^(d, dirs ^: _search^)
echo endforeach
echo.
echo dep_llvm = declare_dependency^(
IF %toolchain%==msvc echo   include_directories ^: include_directories^('%LLVM:\=/%/include'^),
IF %toolchain%==gcc echo   include_directories ^: include_directories^('%msysloc:\=/%%LLVM:\=/%/include'^),
echo   dependencies ^: _deps,
echo   version ^: '%llvmver%',
echo ^)
echo.
echo has_rtti = %RTTI%
IF %toolchain%==msvc echo irbuilder_h = files^('%LLVM:\=/%/include/llvm/IR/IRBuilder.h'^)
IF %toolchain%==gcc echo irbuilder_h = files^('%msysloc:\=/%%LLVM:\=/%/include/llvm/IR/IRBuilder.h'^)
)>%mesa%\mesa\subprojects\llvm\meson.build
@endlocal