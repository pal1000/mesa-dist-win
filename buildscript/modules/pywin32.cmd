@setlocal
@set pythonloc=%1
@%pythonloc% %pythonloc:~0,-10%Scripts\pywin32_postinstall.py -install
@pause
@endlocal