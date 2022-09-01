@IF /I "%1"=="opengl32sw" mklink "%dir%\%1.dll" "%mesaloc%\%mesadll%\opengl32.dll"
@IF /I "%1"=="opengl32sw" GOTO donemklink

@IF /I NOT "%1"=="opengl32" IF /I NOT "%1"=="dxil" IF /I NOT "%1"=="libEGL" IF /I NOT "%1"=="libGLESv1_CM" IF /I NOT "%1"=="libGLESv2" IF /I NOT "%1"=="OpenCL" (
@mklink /H "%dir%\%1.dll" "%mesaloc%\%mesadll%\%1.dll"
@IF NOT EXIST "%dir%\%1.dll" echo WARNING: Couldn't create hard link. GNU Debugger won't be able to map %1.dll when reading symbols from %1.dll.sym - https://github.com/msys2/MINGW-packages/issues/12889
@IF NOT EXIST "%dir%\%1.dll" mklink "%dir%\%1.dll" "%mesaloc%\%mesadll%\%1.dll"
)
@IF /I NOT "%1"=="opengl32" IF /I NOT "%1"=="dxil" IF /I NOT "%1"=="libEGL" IF /I NOT "%1"=="libGLESv1_CM" IF /I NOT "%1"=="libGLESv2" IF /I NOT "%1"=="OpenCL" GOTO donemklink

@mklink "%dir%\%1.dll" "%mesaloc%\%mesadll%\%1.dll"

:donemklink