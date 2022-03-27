@setlocal
@set pythonloc=%1
@%pythonloc% %pythonloc:~0,-11%Scripts\pywin32_postinstall.py" -install
@pause
@endlocal