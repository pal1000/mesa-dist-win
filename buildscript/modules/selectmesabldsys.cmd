:mesabldsys
@set selectmesabld=1
@IF %pythonver% GEQ 3 set selectmesabld=2
@rem IF %pythonver% GEQ 3 echo Select Mesa3D build system
@rem IF %pythonver% GEQ 3 echo --------------------------
@rem IF %pythonver% GEQ 3 echo 1. Scons (recommended)
@rem IF %pythonver% GEQ 3 echo 2. Meson (experimental, incomplete, work in progress)
@rem IF %pythonver% GEQ 3 echo.
@rem IF %pythonver% GEQ 3 set /p selectmesabld=Select Mesa3D build system:
@rem IF %pythonver% GEQ 3 echo.
@IF "%selectmesabld%"=="1" set mesabldsys=scons
@IF "%selectmesabld%"=="2" set mesabldsys=meson
@IF NOT "%selectmesabld%"=="1" IF NOT "%selectmesabld%"=="2" (
@echo Invalid entry.
@echo.
@puse
@cls
@GOTO mesabldsys
)