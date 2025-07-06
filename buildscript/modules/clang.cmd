@rem Detect clang
@setlocal
@set clangstate=0
@IF %toolchain%==msvc IF EXIST "%llvminstloc%\%abi%\bin\clang-cl.exe" set clangstate=1
@IF %toolchain%==msvc IF NOT %abi%==x86 IF EXIST "%ProgramFiles%\LLVM\bin\clang-cl.exe" set clangstate=1
@IF %toolchain%==msvc IF %abi%==x86 IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%ProgramFiles% (x86)\LLVM\bin\clang-cl.exe" set clangstate=1
@IF %toolchain%==msvc IF %abi%==x86 IF /I %PROCESSOR_ARCHITECTURE%==x86 IF EXIST "%ProgramFiles%\LLVM\bin\clang-cl.exe" set clangstate=1
@IF NOT %toolchain%==msvc set clangstate=1

@if %cimode% EQU 0 set useclang=n
@IF NOT %toolchain%==msvc IF %abi%==arm64 set useclang=y
@IF %clangstate% GTR 0 IF %toolchain%==msvc call "%devroot%\%projectname%\bin\modules\prompt.cmd" useclang "Use clang compiler with selected toolchain (y/n):"
@IF %clangstate% GTR 0 IF NOT %toolchain%==msvc IF %abi%==x64 call "%devroot%\%projectname%\bin\modules\prompt.cmd" useclang "Use clang compiler with selected toolchain (y/n):"
@endlocal&set useclang=%useclang%

@set llvmalreadyloaded=0
@if /I "%useclang%"=="y" IF %toolchain%==msvc IF EXIST "%llvminstloc%\%abi%\bin\clang-cl.exe" set PATH=%llvminstloc%\%abi%\bin\;%PATH%
@if /I "%useclang%"=="y" IF %toolchain%==msvc IF EXIST "%llvminstloc%\%abi%\bin\clang-cl.exe" set llvmalreadyloaded=1
@if /I "%useclang%"=="y" IF %toolchain%==msvc IF NOT %abi%==x86 IF NOT EXIST "%llvminstloc%\%abi%\bin\clang-cl.exe" set PATH=%ProgramFiles%\LLVM\bin\;%PATH%
@if /I "%useclang%"=="y" IF %toolchain%==msvc IF %abi%==x86 IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF NOT EXIST "%llvminstloc%\%abi%\bin\clang-cl.exe" set PATH=%ProgramFiles% (x86)\LLVM\bin\;%PATH%
@if /I "%useclang%"=="y" IF %toolchain%==msvc IF %abi%==x86 IF /I %PROCESSOR_ARCHITECTURE%==x86 IF NOT EXIST "%llvminstloc%\%abi%\bin\clang-cl.exe" set PATH=%ProgramFiles%\LLVM\bin\;%PATH%
@if /I "%useclang%"=="y" IF %toolchain%==msvc set CC=clang-cl.exe
@if /I "%useclang%"=="y" IF %toolchain%==msvc set CXX=clang-cl.exe
@if /I "%useclang%"=="y" IF NOT %toolchain%==msvc IF %abi%==x64 set MSYSTEM=CLANG%MSYSTEM:~-2%
@if /I "%useclang%"=="y" IF NOT %toolchain%==msvc IF %abi%==x64 set LMSYSTEM=clang%MSYSTEM:~-2%
@if /I "%useclang%"=="y" IF NOT %toolchain%==msvc IF %abi%==arm64 set MSYSTEM=CLANGARM64
@if /I "%useclang%"=="y" IF NOT %toolchain%==msvc IF %abi%==arm64 set LMSYSTEM=clangarm64
@if /I "%useclang%"=="y" IF NOT %toolchain%==msvc set toolchain=clang
@if /I "%useclang%"=="y" set TITLE=%TITLE% with clang compiler
@if /I "%useclang%"=="y" TITLE %TITLE%
