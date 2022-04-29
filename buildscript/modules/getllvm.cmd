@cd /d "%~dp0"
@cd ..\..\..\
@set "ERRORLEVEL="
@CMD /C EXIT 0
@"%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system" >nul 2>&1
@if NOT "%ERRORLEVEL%"=="0" (
@powershell -Command Start-Process """%0""" -Verb runAs 2>nul
@echo.
@pause
@exit /b
)
@set "ERRORLEVEL="
@CMD /C EXIT 0
@where /q git.exe
@if "%ERRORLEVEL%"=="0" (
@git clone -c core.symlinks=true https://github.com/llvm/llvm-project.git --branch=llvmorg-14.0.3 --depth=1 llvm-project
@echo.
)
@pause