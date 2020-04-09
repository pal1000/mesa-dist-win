@IF %toolchain%==msvc echo %devroot:\=/%/llvm/%abi%%1
@IF %toolchain%==gcc cygpath -m /mingw%MSYSTEM:~-2%%1