@TITLE Building Mesa3D

@rem Determine Mesa3D build environment root folder and convert the path to it into DOS 8.3 format to avoid quotes mess.
@cd "%~dp0"
@cd ..\..\
@for %%a in ("%cd%") do @set mesa=%%~sa

@rem Check if experimental features are requested.
@set enablemeson=0
@if "%1"=="/enablemeson" set enablemeson=1

@rem Analyze environment. Get each dependency status: 0=missing, 1=standby/load manually in PATH, 2=cannot be unloaded.
@rem Not all dependencies can have all these states.

@rem Search for Visual Studio environment. Hard fail if missing.
@call %mesa%\mesa-dist-win\buildscript\modules\visualstudio.cmd

@rem Search for Python. State tracking is pointless as it is loaded once and we are done. Hard fail if missing.
@call %mesa%\mesa-dist-win\buildscript\modules\discoverpython.cmd

@rem Search for Python packages. Install missing packages automatically. Ask to do an update to all packages except pywin32
@rem and pypiwin32 which doesn't support pypi updates cleanly.
@call %mesa%\mesa-dist-win\buildscript\modules\pythonpackages.cmd

@rem Check for remaining dependencies: cmake, ninja, winflexbison and git.
@call %mesa%\mesa-dist-win\buildscript\modules\otherdependencies.cmd

@rem LLVM build.
@call %mesa%\mesa-dist-win\buildscript\modules\llvm.cmd

@rem Mesa3D build.
@call %mesa%\mesa-dist-win\buildscript\modules\mesa3d.cmd

@rem Create distribution
@call %mesa%\mesa-dist-win\buildscript\modules\dist.cmd