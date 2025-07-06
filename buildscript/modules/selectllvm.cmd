@IF %gitstate% GTR 0 call "%devroot%\%projectname%\bin\modules\prompt.cmd" legacyllvm "Use previous LLVM major version (y/n):"
@IF /I "%legacyllvm%"=="y" set llvminstloc=%devroot%\llvmold\build
@IF /I NOT "%legacyllvm%"=="y" set llvminstloc=%devroot%\llvm\build

