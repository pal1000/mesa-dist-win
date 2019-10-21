@setlocal
@rem Git version control. Can either be always present (2) or missing (0).
@SET ERRORLEVEL=0
@set gitstate=2
@where /q git.exe
@IF ERRORLEVEL 1 set gitstate=0
@endlocal&set gitstate=%gitstate%