@setlocal ENABLEDELAYEDEXPANSION

@set lib_dir=%~dp1
@IF %lib_dir:~0,1%%lib_dir:~-1%=="" set lib_dir=%lib_dir:~1,-1%
@IF "%lib_dir:~-1%"=="\" set lib_dir=%lib_dir:~0,-1%
@set lib_dir=%lib_dir:~0,-10%
@set lib_dir=!lib_dir:%prefix%=${prefix}!
@set lib_dir=%lib_dir:\=/%

@set pclines=0
@set prfxline=0
@set libline=0
@for /f tokens^=1^ delims^=^=^ eol^= %%b IN ('type %1') do @(
@set /a pclines+=1
@if /I "%%b"=="prefix" set prfxline=!pclines!
@if /I "%%b"=="libdir" set libline=!pclines!
)

@set pclines=0
@for /f delims^=^ eol^= %%b IN ('type %1') do @(
@set /a pclines+=1
@if NOT !pclines! EQU %prfxline% if NOT !pclines! EQU %libline% set pcline[!pclines!]=%%b
@if !pclines! EQU %prfxline% set pcline[!pclines!]=prefix^=%prefix:\=/%
@if !pclines! EQU %libline% set pcline[!pclines!]=libdir^=%lib_dir%
)

@del %1
@for /L %%b IN (1,1,%pclines%) do @echo !pcline[%%b]!>>%1