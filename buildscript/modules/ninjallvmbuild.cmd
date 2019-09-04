@echo Building llvm-config tool...
@echo.
@ninja -j %throttle% install-llvm-config
@echo.

@rem Build LLVM libraries
@set llvmlibstotal=0
@FOR /F "skip=2 tokens=4 USEBACKQ" %%a IN (`%mesa%\llvm\%abi%-%llvmlink%\bin\llvm-config.exe --libnames engine mcjit bitwriter mcdisassembler irreader 2^>^&1`) DO @set /a llvmlibstotal+=1
@setlocal ENABLEDELAYEDEXPANSION
@set llvmlibscount=0
@FOR /F "skip=2 tokens=4 USEBACKQ" %%a IN (`%mesa%\llvm\%abi%-%llvmlink%\bin\llvm-config.exe --libnames engine mcjit bitwriter mcdisassembler irreader 2^>^&1`) DO @set /a llvmlibscount+=1&echo Building library %%~na - !llvmlibscount! of %llvmlibstotal%...&ninja -j %throttle% install-%%~na&echo.
@endlocal
@echo Installing headers...
@ninja -j %throttle% install-llvm-headers