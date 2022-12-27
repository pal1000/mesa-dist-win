@rem Detect clang
@setlocal
@set clangstate=0
@IF %toolchain%==msvc IF EXIST "%llvminstloc%\%abi%\bin\clang-cl.exe" set clangstate=1
@IF %toolchain%==msvc IF %abi%==x64 IF EXIST "%ProgramFiles%\LLVM\bin\clang-cl.exe" set clangstate=1
@IF %toolchain%==msvc IF %abi%==aarch64 IF EXIST "%ProgramFiles%\LLVM\bin\clang-cl.exe" set clangstate=1
@IF %toolchain%==msvc IF %abi%==x86 IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%ProgramFiles% (x86)\LLVM\bin\clang-cl.exe" set clangstate=1
@IF %toolchain%==msvc IF %abi%==x86 IF /I %PROCESSOR_ARCHITECTURE%==x86 IF EXIST "%ProgramFiles%\LLVM\bin\clang-cl.exe" set clangstate=1
@IF NOT %toolchain%==msvc set clangstate=1

@set useclang=n
@IF %clangstate% GTR 0 set /p useclang=Use clang compiler with selected toolchain ^(y/n^):
@IF %clangstate% GTR 0 echo.
@endlocal&set useclang=%useclang%

@set llvmalreadyloaded=0
@if /I "%useclang%"=="y" IF %toolchain%==msvc IF EXIST "%llvminstloc%\%abi%\bin\clang-cl.exe" set PATH=%llvminstloc%\%abi%\bin\;%PATH%
@if /I "%useclang%"=="y" IF %toolchain%==msvc IF EXIST "%llvminstloc%\%abi%\bin\clang-cl.exe" set llvmalreadyloaded=1
@if /I "%useclang%"=="y" IF %toolchain%==msvc IF %abi%==x64 IF NOT EXIST "%llvminstloc%\%abi%\bin\clang-cl.exe" set PATH=%ProgramFiles%\LLVM\bin\;%PATH%
@if /I "%useclang%"=="y" IF %toolchain%==msvc IF %abi%==aarch64 IF NOT EXIST "%llvminstloc%\%abi%\bin\clang-cl.exe" set PATH=%ProgramFiles%\LLVM\bin\;%PATH%
@if /I "%useclang%"=="y" IF %toolchain%==msvc IF %abi%==x86 IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF NOT EXIST "%llvminstloc%\%abi%\bin\clang-cl.exe" set PATH=%ProgramFiles% (x86)\LLVM\bin\;%PATH%
@if /I "%useclang%"=="y" IF %toolchain%==msvc IF %abi%==x86 IF /I %PROCESSOR_ARCHITECTURE%==x86 IF NOT EXIST "%llvminstloc%\%abi%\bin\clang-cl.exe" set PATH=%ProgramFiles%\LLVM\bin\;%PATH%
@if /I "%useclang%"=="y" IF %toolchain%==msvc set CC=clang-cl.exe
@if /I "%useclang%"=="y" IF %toolchain%==msvc set CXX=clang-cl.exe
@rem These two lines don't work on arm64 becuase they are 5 chars and it only takes the last 2 chars 
@rem @if /I "%useclang%"=="y" IF NOT %toolchain%==msvc set MSYSTEM=CLANG%MSYSTEM:~-2%
@rem @if /I "%useclang%"=="y" IF NOT %toolchain%==msvc set LMSYSTEM=clang%MSYSTEM:~-2%
@if /I "%useclang%"=="y" IF NOT %toolchain%==msvc set toolchain=clang
@if /I "%useclang%"=="y" set TITLE=%TITLE% with clang compiler
@if /I "%useclang%"=="y" TITLE %TITLE%
@set useclang=

@echo %LMSYSTEM%