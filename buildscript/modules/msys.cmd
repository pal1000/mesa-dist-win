@setlocal ENABLEDELAYEDEXPANSION
@rem Load MSYS2 environment
@for /f delims^=^ eol^= %%a IN ('REG QUERY HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall /s /d /f MSYS2 2^>^&1 ^| find "HKEY_"') DO @for /f delims^=^ eol^= %%b IN ('REG QUERY %%a /s /v InstallLocation 2^>^&1 ^| find "InstallLocation"') DO @for /f tokens^=1^,2^ delims^=^:^ eol^= %%c IN ("%%b") DO @(
@set msysloc=%%c
@set msysloc=!msysloc:~-1!^:%%d
)
@IF NOT EXIST "%msysloc%" set msysloc=%devroot%\msys64
@IF NOT EXIST "%msysloc%" set msysloc=%devroot%\msys32
@endlocal&set msysloc=%msysloc%
@set runmsys=call "%devroot%\%projectname%\buildscript\modules\runmsys.cmd"
@set mingwpkglst={clang,cmake,directx-headers,gdb,glslang,libclc,libelf,libva,lld,meson,pkgconf,polly,python-mako,python-packaging,python-yaml,spirv-headers,spirv-llvm-translator,spirv-tools,vulkan-headers,vulkan-loader,zstd}