@set abi=32
@cd ../..
@set msys=64
@IF NOT EXIST msys64 set msys=32
@IF %msys%==32 IF NOT EXIST msys32 exit
@SET PATH=%CD%\msys%msys%\usr\bin\;%CD%\msys%msys%\mingw%abi%\bin\;%PATH%
@cd mesa-dist-win\mingw-w64-mesa
@cmd

