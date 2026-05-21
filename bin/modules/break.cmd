@IF NOT defined botmode set botmode=-1
@if %botmode% LEQ 0 IF "%*"=="" pause
@if %botmode% LEQ 0 IF "%*"=="" echo.
@if %botmode% LEQ 0 IF NOT "%*"=="" echo.
@if %botmode% LEQ 0 IF NOT "%*"=="" pause

