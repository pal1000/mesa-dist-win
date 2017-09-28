# Build script
- Fixed python modules update check. Always check if mako not found, ask otherwise.
- Made build script aware of Mesa branches, helps with patches applicability narrowing.
- Add Scons 3.0.0 compatibility patch to Mesa3D Git-powered auto-patches.
Only apply it to Mesa stable, patch is upstream now.
- Determine Mesa branch even if it is not built. Preparation for S3TC merger.
- Drop LLVM 5.0 compatibility patch when building Mesa master and version 17.1.10.
Patch is upstream.
- Ensure auto-patching is done once and only once.
- Look for Git before trying to patch. It is pointless if it is not found.
- This script won't find Scons if it isn't in a certain relative location to it.
Addressed this by fixing scons locating when Python it's in PATH right from the beginning.
- Updated documentation: compatibility fix for Scons 3.0.0.

# Build environmemt updates
- Scons updated to 3.0.0.
- Visual Studio updated to 2017 v15.3.5.

# Known issues
- Mesa build: Scons 3.0.0 always uses target architecture compiler when using cross-compiling environment
