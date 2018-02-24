# Build environment updates
- Git 2.16.1.4 -> 2.16.2.1
- Visual Studio 15.5.6 -> 15.5.7
# Distribution creation and deployment utility
- Move each osmesa DLL in its own folder. Reduces usage complexity.
# Build script and build documentation
- Allow build without LLVM. Only osmesa-swrast and softpipe are built in this case.
# End-user documentation
- Small enhancements.
# Known issue
- This upcoming release breaks osmesa deployments performed with quick deployment utility. A re-deployment is required. Manual copy-pastes of osmesa libraries are unaffected.