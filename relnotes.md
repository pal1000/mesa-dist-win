- Updated Mesa3D to 17.2.2.
- Built with Scons 3.0.0. Made use of a compatibility patch.
- Built LLVM 5.0 and Mesa3D with Visual Studio 2017 v15.3.5.

# Build script
- Fixed python modules update check. Always check if mako not found, ask otherwise.
- Made build script aware of Mesa branches, helps with patches applicability narrowing.
- Add Scons 3.0.0 compatibility patch to Mesa3D Git-powered auto-patches.
Only apply it to Mesa stable, patch is upstream now.
- Determine Mesa branch even if it is not built. Preparation for S3TC merger.
- Ensure auto-patching is done once and only once.
- Look for Git before trying to patch. It is pointless if it is not found.
- This script won't find Scons if it isn't in a certain relative location to it.
Addressed this by fixing scons locating when Python it's in PATH right from the beginning.
- Added Scons to python update checking and auto-install. Depends on wheel.
1 less dependency requiring manual installation.
- Halt execution if Mesa is missing and it can't be acquired or its acquiring is refused by user.
- Drop LLVM 5.0 compatibility patch. Patch is upstream in all active branches.

# Build script documentation
- There is a compatibility fix for Scons 3.0.0.
- Scons can now be acquired by the build script automatically. Depends on wheel.
- Git version control is now mandatory due to compatibility with latest Scons needing a patch.
- Updated questions list asked by this script.

# Known issues
- Mesa build: Scons 3.0.0 always uses target architecture compiler when using cross-compiling environment. This may impact compilation performance when making 32-bit builds.
