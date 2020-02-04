@setlocal ENABLEDELAYEDEXPANSION
@echo Building llvm-config tool...
@ninja -j %throttle% install-llvm-config
@echo.

@rem Build LLVM libraries
@set llvmlibstotal=0
@FOR /F "skip=2 tokens=4 USEBACKQ" %%a IN (`%devroot%\llvm\%abi%\bin\llvm-config.exe --link-static --libnames engine coroutines 2^>^&1`) DO @set /a llvmlibstotal+=1
@set llvmlibscount=0
@FOR /F "skip=2 tokens=4 USEBACKQ" %%a IN (`%devroot%\llvm\%abi%\bin\llvm-config.exe --link-static --libnames engine coroutines 2^>^&1`) DO @set /a llvmlibscount+=1&echo Building library %%~na - !llvmlibscount! of %llvmlibstotal%...&ninja -j %throttle% install-%%~na&echo.

@echo Installing headers...
@ninja -j %throttle% install-llvm-headers
@endlocal