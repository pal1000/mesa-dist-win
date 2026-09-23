@if %botmode% LEQ 0 set mesadbgbld=n
@IF %toolchain%==msvc call "%devroot%\%projectname%\bin\modules\prompt.cmd" mesadbgbld "Enable debug friendly binaries build and distribution (require a lot of RAM) (y/n):"
@IF NOT %toolchain%==msvc call "%devroot%\%projectname%\bin\modules\prompt.cmd" mesadbgbld "Enable debug friendly binaries build and distribution (y/n):"
@set builddirsufix=
@IF NOT %toolchain%==msvc IF /I "%mesadbgbld%"=="y" set builddirsufix=-debug
@IF NOT %toolchain%==msvc IF /I NOT "%mesadbgbld%"=="y" set builddirsufix=-release
