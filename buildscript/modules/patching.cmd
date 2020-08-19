@REM Verify if out of tree patches can be applied.
@IF NOT defined disablemesapatch set disablemesapatch=0
@set cannotmesapatch=0
@if %gitstate%==0 IF NOT EXIST %msysloc%\usr\bin\patch.exe IF %toolchain%==msvc set cannotmesapatch=1
@IF %cannotmesapatch%==1 set disablemesapatch=1
@IF %cannotmesapatch%==1 echo Error: Git and MSYS2 GNU patch are both missing. Auto-patching disabled. This could have many consequences going all the way up to build failure.
@IF %cannotmesapatch%==1 echo.
@IF %disablemesapatch%==1 IF %cannotmesapatch%==0 echo WARNING: Patching is forcefully disabled for debugging purposes.
@IF %disablemesapatch%==1 IF %cannotmesapatch%==0 echo.