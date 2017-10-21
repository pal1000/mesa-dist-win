# Build script
- Dead variables clean-up.
- Load Visual Studio environment only when building LLVM with Ninja.
- S3TC build: If both MSYS2 and standalone Mingw-W64 are installed let the user pick which to use.
- S3TC MSYS2 build: prefer 64-bit MSYS2 over 32-bit if both installed.
# Build script documentation
- S3TC build with standalone Mingw-w64 is no longer deprecated. GCC 7.2 update finally took place.
- You are now asked which flavor of Mingw-W64 to use when building S3TC if both MSYS2 and standalone are installed.