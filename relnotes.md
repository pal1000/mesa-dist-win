# Build script
- Drop S3TC build if Mesa master source code is detected. S3TC is now built-in. Texture cache enabling patch is still needed though.
- Python modules updating: use pip install -U <module-name> explicitly for all modules. It is more comprehensive than pip freeze.
- Improved PATH cleanning.
- Revived some cygwin/Msys2 experiments.