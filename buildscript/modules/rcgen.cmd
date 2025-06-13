@setlocal
@rem Required parameters
@rem %1 - description
@rem %2 - filename
@rem %3 - arch
@rem %4 - version
@rem %5 - vendor

@set descriptionfield=%1
@IF NOT %3==null set descriptionfield=%descriptionfield:~0,-1% (%3)"
@set prodver=%4.%mesabldrev%
@FOR /F "skip=1 tokens=2" %%a IN ('WMIC Path Win32_LocalTime Get Second^,Year /Format^:table') DO @if "%%a" NEQ "" set year=%%a

@(echo.
echo 1 VERSIONINFO
echo FILEVERSION %prodver:.=,%
echo PRODUCTVERSION %prodver:.=,%
echo FILEOS 0x40004
echo FILETYPE 0x0
echo {
echo BLOCK "StringFileInfo"
echo {
echo BLOCK "040904b0"
echo {
echo VALUE "CompanyName", %5
echo VALUE "FileDescription", %descriptionfield%
echo VALUE "FileVersion", "%prodver%"
echo VALUE "InternalName", "%~n2.dll"
echo VALUE "LegalCopyright", "Copyright (C) %year%"
echo VALUE "OriginalFilename", "%~n2.dll"
echo VALUE "ProductName", "Mesa3D"
echo VALUE "ProductVersion", "%prodver%"
echo }
echo }
echo BLOCK "VarFileInfo"
echo {
echo VALUE "Translation", 0x0409 0x04B0
echo }
echo })>"%devroot%\%projectname%\buildscript\assets\temp.rc"
@IF EXIST %2 ResourceHacker.exe -open "%devroot%\%projectname%\buildscript\assets\temp.rc" -save "%devroot%\%projectname%\buildscript\assets\temp.res" -action compile -log NUL
@IF EXIST %2 ResourceHacker.exe -open %2 -save %2 -action addoverwrite -resource "%devroot%\%projectname%\buildscript\assets\temp.res" -log NUL
@endlocal