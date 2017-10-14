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
- Refactored LLVM build section. Fixed a logic loophole on which the build script would offer to build LLVM with backward compatibility toolset even if this toolset is not installed.
This logic loophole became relevant with Scons 3.0.0 which turned the compatibility toolset from a must-have to pure optional.
- Scons: Keep loading Visual Studio environment just to be safe for now.
- Documentation: MSYS2 Mingw-w64 is now the preferred method to build S3TC.