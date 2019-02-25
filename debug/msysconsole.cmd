@cd ../..
@set msys=64
@IF NOT EXIST msys64 set msys=32
@IF %msys%==32 IF NOT EXIST msys32 exit
@SET PATH=%CD%\msys%msys%\usr\bin\;%PATH%
@cmd

