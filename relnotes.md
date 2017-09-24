# Build script
- Fixed python modules update check. Always check if mako not found, ask otherwise
- Add Scons 3.0.0 compatibility patch to Mesa3D Git-powered auto-patches
- Drop LLVM 5.0 compatibility patch when building Mesa master. Patch is upstream
- Ensure auto-patching is done once and only once
- Updated documentation: compatibility fix for Scons 3.0.0

# Build environmemt updates
- Scons updated to 3.0.0
- Visual Studio updated to 2017 v15.3.5