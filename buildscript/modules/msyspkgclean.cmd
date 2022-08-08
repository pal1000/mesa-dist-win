@%runmsys% pacman -Sc --noconfirm
@for /R "%msysloc%\var\cache\pacman\pkg" %%a in (*.*) do @for /f tokens^=1^ delims^=-^ eol^= %%b in ("%%~na") DO @IF NOT "%%b"=="bison" IF NOT "%%b"=="flex" IF NOT "%%b"=="m4" IF NOT "%%b"=="mingw" IF NOT "%%b"=="patch" IF NOT "%%b"=="tar" del "%%a"
