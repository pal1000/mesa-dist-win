@set mesabldsys=meson
@IF EXIST %devroot%\mesa IF NOT EXIST %devroot%\mesa\subprojects\.gitignore (
@echo Mesa3D source code you are using is too old. Update to 19.3 or newer.
@echo.
@pause
@exit
)