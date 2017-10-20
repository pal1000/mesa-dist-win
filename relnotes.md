- Built S3TC with MSYS2 Mingw-w64 GCC 7.2.0.
- Built LLVM 5.0 and Mesa with Visual Studio 2017 v15.4.0.
# Deployment utility
- Made easy to swap osmesa variants.
- Check before attempting to create symbolic links. Avoid harmless errors which may be confusing.
# Build script
- Drop S3TC build if Mesa master source code is detected. S3TC is now built-in. Texture cache enabling patch is still needed though.
- Python modules updating: use both pip install -U <module-name> explicitly and pip freeze in a hybrid approach for most optimal behavior.
- Improved PATH cleanning.
- Support building S3TC with MSYS2 Mingw-W64 GCC by default. They fixed their problem with 32-bit binaries when they upgraded to GCC 7.2.0.
- Drop suport for Visual Studio 2015 completely. It survived so long due to Scons 3.0.0 issues.
# Build script documentation
- MSYS2 Mingw-w64 is now the preferred method to build S3TC.
- Visual Studio 2017 is now required to build LLVM and Mesa3D.