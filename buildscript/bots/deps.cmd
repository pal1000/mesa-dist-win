@set cfgllvmbuild=y
@set amdgpu=y
@set buildclang=y
@set buildllvm=y
@set buildpkgconf=n
@if /I %PROCESSOR_ARCHITECTURE%==X86 IF "%cpuchoice%"=="1" set buildpkgconf=y
@if /I %PROCESSOR_ARCHITECTURE%==AMD64 IF "%cpuchoice%"=="2" set buildpkgconf=y
@if /I %PROCESSOR_ARCHITECTURE%==ARM64 IF "%cpuchoice%"=="3" set buildpkgconf=y
@set buildclon12=y
@set buildspvtools=y
@set buildlibva=y
@set buildzstd=y
@set buildllvmspirv=y
@set buildclc=n
@if /I %PROCESSOR_ARCHITECTURE%==X86 IF "%cpuchoice%"=="1" set buildclc=y
@if /I %PROCESSOR_ARCHITECTURE%==AMD64 IF "%cpuchoice%"=="2" set buildclc=y
@if /I %PROCESSOR_ARCHITECTURE%==ARM64 IF "%cpuchoice%"=="3" set buildclc=y
