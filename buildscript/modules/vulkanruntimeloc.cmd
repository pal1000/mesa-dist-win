@if /I %PROCESSOR_ARCHITECTURE%==AMD64 IF %abi%==x86 echo %windir:\=/%/SysWOW64
@if /I %PROCESSOR_ARCHITECTURE%==AMD64 IF %abi%==x64 echo %windir:\=/%/system32
@if /I %PROCESSOR_ARCHITECTURE%==%abi% echo %windir:\=/%/system32