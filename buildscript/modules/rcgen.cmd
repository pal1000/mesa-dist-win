@setlocal
@rem Required parameters
@rem %1 - description
@rem %2 - filename
@rem %3 - arch
@rem %4 - version
@rem %5 - vendor

@set descriptionfield=%1
@IF NOT %3==null set descriptionfield=%descriptionfield:~0,-1% (%3)"
@set mesaver=%4

@(echo.
echo 1 VERSIONINFO
echo FILEVERSION %mesaver:.=,%,0
echo PRODUCTVERSION %mesaver:.=,%,0
echo FILEOS 0x40004
echo FILETYPE 0x0
echo {
echo BLOCK "StringFileInfo"
echo {
echo BLOCK "040904b0"
echo {
echo VALUE "CompanyName", %5
echo VALUE "FileDescription", %descriptionfield%
echo VALUE "FileVersion", "%mesaver%.0"
echo VALUE "InternalName", "%~n2.dll"
echo VALUE "LegalCopyright", "Copyright (C) 2019"
echo VALUE "OriginalFilename", "%~n2.dll"
echo VALUE "ProductName", "Mesa3D"
echo VALUE "ProductVersion", "%mesaver%.0"
echo }
echo }
echo BLOCK "VarFileInfo"
echo {
echo VALUE "Translation", 0x0409 0x04B0
echo }
echo })>%devroot%\mesa-dist-win\buildscript\assets\temp.rc
@IF EXIST %2 ResourceHacker.exe -open %devroot%\mesa-dist-win\buildscript\assets\temp.rc -save %devroot%\mesa-dist-win\buildscript\assets\temp.res -action compile -log NUL
@IF EXIST %2 ResourceHacker.exe -open %2 -save %2 -action addoverwrite -resource %devroot%\mesa-dist-win\buildscript\assets\temp.res -log NUL
@endlocal