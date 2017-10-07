Built S3TC with MSYS2 Mingw-w64 GCC 7.2.0.
# Build script
- Drop S3TC build if Mesa master source code is detected. S3TC is now built-in. Texture cache enabling patch is still needed though.
- Python modules updating: use both pip install -U <module-name> explicitly and pip freeze in a hybrid approach for most optimal behavior.
- Improved PATH cleanning.
- Support building S3TC with SYS2 Mingw-W64 GCC. They fixed their problem with 32-bit binaries when they upgraded to GCC 7.2.0.