@IF %toolchain%==msvc echo %LLVM:\=/%%1
@IF %toolchain%==gcc cygpath -m %LLVM%%1