@IF /I "%1"=="opengl32sw" mklink "%dir%\%1.dll" "%mesaloc%\%mesadll%\opengl32.dll"
@IF /I "%1"=="libGLESv3" mklink "%dir%\%1.dll" "%mesaloc%\%mesadll%\libGLESv2.dll"
@IF /I NOT "%1"=="opengl32sw" IF /I NOT "%1"=="libGLESv3" mklink "%dir%\%1.dll" "%mesaloc%\%mesadll%\%1.dll"