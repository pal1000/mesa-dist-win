@IF NOT defined botmode set botmode=0
@if %botmode% EQU 0 IF "%*"=="" pause
@if %botmode% EQU 0 IF "%*"=="" echo.
@if %botmode% EQU 0 IF NOT "%*"=="" echo.
@if %botmode% EQU 0 IF NOT "%*"=="" pause

