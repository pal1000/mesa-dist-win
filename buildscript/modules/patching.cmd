@REM Verify if out of tree patches can be applied.
@IF NOT defined disableootpatch set disableootpatch=0
@set cannotootpatch=0
@if %gitstate%==0 IF NOT EXIST "%msysloc%\usr\bin\patch.exe" IF %toolchain%==msvc set cannotootpatch=1
@IF %cannotootpatch%==1 set disableootpatch=1
@IF %cannotootpatch%==1 echo Error: Git and MSYS2 GNU patch are both missing. Auto-patching disabled. This could have many consequences going all the way up to build failure.
@IF %cannotootpatch%==1 echo.
@IF %disableootpatch%==1 IF %cannotootpatch%==0 echo WARNING: Patching is forcefully disabled for debugging purposes.
@IF %disableootpatch%==1 IF %cannotootpatch%==0 echo.