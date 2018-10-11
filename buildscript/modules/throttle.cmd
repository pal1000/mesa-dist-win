@set throttle=%NUMBER_OF_PROCESSORS%
@set /p throttle=Do you want to throttle build. Enter number of parallel jobs. Defaults to %NUMBER_OF_PROCESSORS% which represents the number of your CPU available hyperthreads. You should not enter a value greater than that:
@echo.