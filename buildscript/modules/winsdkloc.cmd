@set winsdkloc=null
@for /f tokens^=2* %%a IN ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Kits\Installed Roots" /v KitsRoot10 2^>nul ^| find "REG_"') DO @set winsdkloc=%%b
@if "%winsdkloc:~-1%"=="\" set winsdkloc=%winsdkloc:~0,-1%
