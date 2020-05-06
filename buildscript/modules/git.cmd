@setlocal
@rem Git version control. Can either be always present (2) or missing (0).
@CMD /C EXIT 0
@set gitstate=2
@where /q git.exe
@if NOT "%ERRORLEVEL%"=="0" set gitstate=0
@endlocal&set gitstate=%gitstate%