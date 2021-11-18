@pause
@echo Collecting debug symbools. Please wait...

@IF NOT EXIST "%devroot%\%projectname%\debugsymbols\" MD %devroot%\%projectname%\debugsymbols
@IF NOT EXIST "%devroot%\%projectname%\debugsymbols\%abi%\" RD /S /Q %devroot%\%projectname%\debugsymbols\%abi%
@IF NOT EXIST "%devroot%\%projectname%\debugsymbols\%abi%\" MD %devroot%\%projectname%\debugsymbols\%abi%
@IF %dualosmesa% EQU 1 MD %devroot%\%projectname%\debugsymbols\osmesa-gallium
@IF %dualosmesa% EQU 1 MD %devroot%\%projectname%\debugsymbols\osmesa-swrast
@IF EXIST %devroot%\%projectname%\bin\%abi%\osmesa-gallium\osmesa.dll (
@copy %devroot%\%projectname%\bin\%abi%\osmesa-gallium\osmesa.dll %devroot%\%projectname%\debugsymbols\%abi%\osmesa-gallium\osmesa.dll.symbols
@%msysloc%\%LMSYSTEM%\bin\strip --only-keep-debug %devroot:\=/%/%projectname%/debugsymbols/%abi%/osmesa-gallium/osmesa.dll.symbols
@%msysloc%\%LMSYSTEM%\bin\strip --strip-debug --strip-unneeded %devroot:\=/%/%projectname%/bin/%abi%/osmesa-gallium/osmesa.dll
)
@IF EXIST %devroot%\%projectname%\bin\%abi%\osmesa-swrast\osmesa.dll (
@copy %devroot%\%projectname%\bin\%abi%\osmesa-swrast\osmesa.dll %devroot%\%projectname%\debugsymbols\%abi%\osmesa-swrast\osmesa.dll.symbols
@%msysloc%\%LMSYSTEM%\bin\strip --only-keep-debug %devroot:\=/%/%projectname%/debugsymbols/%abi%/osmesa-swrast/osmesa.dll.symbols
@%msysloc%\%LMSYSTEM%\bin\strip --strip-debug --strip-unneeded %devroot:\=/%/%projectname%/bin/%abi%/osmesa-swrast/osmesa.dll
)
@forfiles /p %devroot%\%projectname%\bin\%abi% /m *.dll /c "cmd /c copy @path %devroot%\%projectname%\debugsymbols\%abi%\@file.symbols"
@forfiles /p %devroot%\%projectname%\bin\%abi% /m *.dll /c "cmd /c %msysloc%\%LMSYSTEM%\bin\strip --only-keep-debug %devroot:\=/%/%projectname%/debugsymbols/%abi%/@file.symbols"
@forfiles /p %devroot%\%projectname%\bin\%abi% /m *.dll /c "cmd /c %msysloc%\%LMSYSTEM%\bin\strip --strip-debug --strip-unneeded %devroot:\=/%/%projectname%/bin/%abi%/@file"
@forfiles /p %devroot%\%projectname%\bin\%abi% /m *.exe /c "cmd /c %msysloc%\%LMSYSTEM%\bin\strip --strip-debug --strip-unneeded %devroot:\=/%/%projectname%/bin/%abi%/@file"
@echo.
@echo Done.
@echo.