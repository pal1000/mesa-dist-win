# Next release
### Build script
- Fixed a critical bug causing build script to abort execution when MSYS2 is missing;
- Compatibility update for Windows 10 Version 1903: Remove Python UWP installer from PATH [#23](https://github.com/pal1000/mesa-dist-win/issues/23).
# 19.0.2
- Updated Mesa3D to [19.0.2](https://www.mesa3d.org/relnotes/19.0.2.html).
### Debug
- Add a MSYS2 console for debug purposes;
- llvm-config debug tool: Support returning libraries list in both python list and ninja targets format.
### Build script
- Build LLVM efficiently when using Ninja by only building llvm-config tool, required libraries and headers;
- Detect Visual Studio installations using vswhere;
- Support handling missing Desktop development with C++ workload through Visual Studio installer.
### Build environment updates
- cmake 3.14.0 -> 3.14.1;
- Visual Studio 15.9.10 -> 16.0.1;
- setuptools 40.8.0 -> 41.0.0.
### Documentation
- Update LLVM build command;
- Per-app deployment: Document .local file generation support;
- End-user guide: Document MESA_EXTENSION_MAX_YEAR;
- End-user guide: Document .local file generation support;
- End-user guide: Document pros and cons of Mingw vs MSVC binaries and how to migrate from one to the other.
# 19.0.1
- Updated Mesa3D to [19.0.1](https://www.mesa3d.org/relnotes/19.0.1.html).
### Build script
- Remove MSYS2 draft;
- Improve MSYS2 loader script so that it does not need a temporary shell script;
- Toolchain selection: Support release candidates and stable release of Visual Studio 2019;
- It turns out LLVM has no Meson build so remove all related code;
- LLVM/MsBuild: Compatibility with Visual Studio 2019 retaining backward compatibility with Visual Studio 2017.
### Build environment updates
- scons 3.0.5a2 -> 3.0.5;
- LLVM 7.0.1 -> 8.0.0;
- Mako 1.0.7 -> 1.0.8;
- cmake 3.13.4 -> 3.14.0;
- Visual Studio 15.9.9 -> 15.9.10.
### Patches and workarounds
-  MSYS2: Don't patch autotools stuff.
# 19.0.0-2
- MSYS2 Mingw-w64 build debut.
- Mingw-w64 build does not include swr driver due to [build failure](https://gitlab.freedesktop.org/mesa/mesa/merge_requests/362#note_130059).
- Mingw-w64 binaries require a CPU capable of running [SSSE3 instruction set](https://en.wikipedia.org/wiki/SSSE3#CPUs_with_SSSE3) with benefit of having slightly better performance than MSVC binaries.
### Build script
- Fixed script segmentation fault for Scons build in MSYS2 Mingw-w64 due to use of undefined llvmlink variable;
- Fixed MSYS2 update script so that it does not perform the initial upgrade every time.
# 19.0.0
- Updated Mesa3D to [19.0.0](https://www.mesa3d.org/relnotes/19.0.0.html).
### Build environment updates
- wheel 0.33.0 -> 0.33.1;
- winflexbison 2.5.16 -> 2.5.18-devel;
- GNU bison 3.1.0 -> 3.3.2;
- pip 19.0.2 -> 19.0.3;
- MarkupSafe 1.1.0 -> 1.1.1;
- 7-zip 18.06 -> 19.00;
- Git 2.20.1.1 -> 2.21.0.1;
- Python 2.7.15 -> 2.7.16;
- Visual Studio 15.9.7 -> 15.9.9;
- scons 3.0.1 -> 3.0.5a2.
### Debug
- Add MSYS2 cmd console.
### Build script
- Add a patch for Mesa3D to build with MSYS2;
- Implement toolchain selection to support mutiple editions and versions of Visual Studio along with MSYS2 Mingw-w64 GCC;
- Avoid loading MSYS2 components in PATH by implementing a MSYS2 running script as only Meson build needs Mingw-w64 in PATH for pkg-config;
- Implement MSYS2 package management and acquisition;
- Disable Meson build in MSYS2 code path as it is not implemented;
- Add Scons develpment compatibility patches;
- Use `git apply --check --apply` to apply patches and drop the inflexible mesapatched.ini;
- Remove the obsolete Scons 3.0.1 un-freeze patch;
- Implement Mesa3D build recipe with Scons in MSYS2 Mingw-w64 environment, fixes [#17](https://github.com/pal1000/mesa-dist-win/issues/17);
- Implement a patch applying script that uses git when building with MSVC and GNU patch when building with MSYS2 Mingw-w64.
# 18.3.4
- Updated Mesa3D to [18.3.4](https://www.mesa3d.org/relnotes/18.3.4.html).
### Build environment updates
- setuptools 40.7.2 -> 40.8.0;
- cmake 3.13.3 -> 3.13.4;
- pip 19.0.1 -> 19.0.2;
- wheel 0.32.3 -> 0.33.0;
- Visual Studio 15.9.6 -> 15.9.7.
### Manual build information
- Remove mention of an obsolete patch.
### Build script
- Remove old gles related workarounds that are only relevant for Mesa 18.2 and older;
- Use same ABI pkg-config and load Mingw environment along with MSYS2 when using Meson build to ease logic of things;
- Add a patch to ease replication of build failure with Scons 3.0.2 and newer;
- Make Meson build behave as close as possible to upstream Appveyor script;
- Support development version of Scons;
- More robust way of checking if Scons is installed as it leaves remnants behind when uninstalled which can confuse the build script;
- Make sure Python launcher query runs only once regardless of user input;
- Miscellaneous code simplifications and cleanup.
# 18.3.3
- Updated Mesa3D to [18.3.3](https://www.mesa3d.org/relnotes/18.3.3.html).
### Build script
- Ignore deprecation warnings affecting pip 19 and newer with Python 2.7.
### Build environment updates
- pip 18.1 -> 19.0.1;
- Visual Studio 15.9.5 -> 15.9.6;
- setuptools 40.6.3 -> 40.7.2;
- ninja 1.8.2 -> 1.9.0;
- 7-zip 18.05 -> 18.06.
# 18.3.2
- Updated Mesa3D to [18.3.2](https://www.mesa3d.org/relnotes/18.3.2.html);
- Added binaries descriptions, versions and company names - [#19](https://github.com/pal1000/mesa-dist-win/issues/19).
### Build script
- Better pkg-config support: aquire via MSYS2 pacman when possible.
- Added MSYS2 update support;
- Do not lookup MSYS2 when using Python 2 / Scons build, at least for the time being;
- Python 2 modules check compatibility update for Scons 3.0.3;
- Mesa3D build script compatibility update for Scons 3.0.3. Actual upgrade to Scons 3.0.3 is on hold due to Mesa3D build failure with it. Upstream work is needed.
### Deployment
- Make sure per app deployment only asks for GLES libraries deployment when glapi is a shared library.
### Build environment updates
- cmake 3.13.1 -> 3.13.3;
- Visual Studio 15.9.3 -> 15.9.5;
- setuptools 40.6.2 -> 40.6.3;
- Git 2.20.0.1 -> 2.20.1.1;
- LLVM 7.0.0 -> 7.0.1.
# 18.3.0
- Updated Mesa3D to [18.3.0](https://www.mesa3d.org/relnotes/18.3.0.html).
### Removed features
- shared glapi and standalone GLES drivers support in Scons build has been removed upstream in [this commit](https://gitlab.freedesktop.org/mesa/mesa/commit/45bacc4b63d83447c144d14cb075eaf7a458c429). @jrfonseca chose to cut down this build configuration altogether instead of fixing osmesa build.
### Build environment updates
- Visual Studio 15.9.2 -> 15.9.3;
- cmake 3.13.0 -> 3.13.1;
- Windows SDK 10.0.17763.1 -> 10.0.17763.132;
- Git 2.19.2.1 -> 2.20.0.1.
### Build script
- Do not expect MSYS2 environment preload in PATH as it is unlikely;
- Make sure we do not pass the invalid gles option for Mesa 18.3.
### Deployment tools
- Consider that shared glapi and standalone GLES drivers may not always be available.
# 18.2.6
- Updated Mesa3D to [18.2.6](https://www.mesa3d.org/relnotes/18.2.6.html).
### Build environment updates
- wheel 0.32.2 -> 0.32.3;
- Visual Studio 15.9.0 -> 15.9.2;
- Git 2.19.1.1 -> 2.19.2.1;
- cmake 3.12.4 -> 3.13.0.
### gitignore
- Ignore .tmp files.
# 18.2.5
- Updated Mesa3D to [18.2.5](https://www.mesa3d.org/relnotes/18.2.5.html).
### Documentation
- shared glapi and standalone GLES drivers will not be available in Mesa 18.3 series due to support for this build configuration being dropped upstream.
### Build environment updates
- Visual Studio 15.8.8 -> 15.9.0;
- cmake 3.12.3 -> 3.12.4;
- MarkupSafe 1.0 -> 1.1.0;
- setuptools 40.5.0 -> 40.6.2.
### Build script
- Move target ABI selection in its own module. Groundwork for potential MSYS2 Mingw-w64 GCC build with Scons.
### Debug
- Remove LLVM 7 special case from llvm-config output tool.
# 18.2.4
- Updated Mesa3D to [18.2.4](https://www.mesa3d.org/relnotes/18.2.4.html).
### Build environment updates
- wheel 0.32.1 -> 0.32.2;
- Visual Studio 15.8.7 -> 15.8.8;
- setuptools 40.4.3 -> 40.5.0.
### Build script
- Got a patch accepted upstream that puts to rest the zombie texture float build option in Mesa3D Scons build;
- Use recommended way of selecting CRT and optimization level for Meson build based on Meson version;
- Adjust Mesa3D build script taking into account the fact that shared glapi and standalone GLES support is going down in upcoming Mesa 18.3 series for Scons build system;
- Take advantage of MSVC_USE_SCRIPT support patch to use the 64-bit compiler when doing 32-bit builds;
- Mesa3D Meson build: ensure standalone GLES libraries are built when GLAPI is a shared library;
- Mesa3D Meson build: use all known ways of forcing static linking;
- Mesa3D Meson build: always link zlib and expat statically;
- Mesa3D Meson build: Do not disable GLES when GLAPI is a static library.
### Documentation
- Clarifications related to GLES and GLAPI.
# 18.2.3
- Updated Mesa3D to [18.2.3](https://www.mesa3d.org/relnotes/18.2.3.html);
- Restore osmesa and swr integration now that we have a far better LLVM 7 compatibility patch.
### Documentation
- Document swr patch for LLVM >= 7;
- Document LLVM new binaries location;
- Document build throttling support.
### Patches and workarounds
- Add a LLVM 7 compatibility patch for swr driver, now at version 3: https://lists.freedesktop.org/archives/mesa-dev/2018-October/207017.html
### Build script
- Fix a typo that was causing the defunct texture_float build option to linger;
- Mesa3D Meson build: Far more robust detection of pkg-config;
- Buld throttling suport. Doesn't make much difference with Scons when building swr as it uses the incremental linker a lot;
- LLVM wrap generator: Make use of LLVM variable and perform paths joins in the generator instead of Python;
- Mesa3D Meson build: Use build folder. Avoids git spammming untracked files in Mesa source code repository;
- Mesa3D Meson build: Restore verbosity level to normal. Now we have build throttling to control system strain which does a better job;
- Remove old and abandoned pywin32 install asset.
### Build environment updates
- git 2.19.0.1 -> 2.19.1.1;
- Visual Studio 15.8.6 -> 15.8.7.
# 18.2.2
- Updated Mesa3D to [18.2.2](https://www.mesa3d.org/relnotes/18.2.2.html);
- swr driver is back.
### Known issue
- osmesa support is limited. OpenGL ES and swr driver integration have to be stripped due to build failure.
### Build environment updates
- Windows 10.0.7134 -> 10.0.17763;
- Windows SDK 10.0.17134.12 -> 10.0.17763.1;
- setuptools 40.4.1 -> 40.4.3;
- Visual Studio 15.8.4 -> 15.8.6;
- winflexbison 2.5.15 -> 2.5.16;
- bison 3.0.5 -> 3.1.0;
- pywin32 223 -> 224;
- wheel 0.31.1 -> 0.32.1;
- cmake 3.12.2 -> 3.12.3;
- pip 18.0 -> 18.1;
- Update LLVM build commands to reflect side-by-side CRTs support;
- Fix a serious bug in LLVM build command that fortunately does not apply to the build script itself, only the build environment information document is affected.
### Build script
- Python 3 packages: Fix an infinite loop with Meson 0.48.0 and newer;
- Mesa3D Meson MsBuild backend: Lower log verbosity level to minimal;
- Python 2.7 packages: Bring back pywin32 upgrade;
- Python 2.7 packages: install pywin32 after wheel, just to be safe;
- Mesa3D Meson build LLVM wrap generator: Tweak to replicate Mesa3D built-in wrap configuration and code clean-up;
- Mesa3D Meson clean build: Cover subprojects too;
- Make it possible to have multiple LLVM builds with different linking modes at the same time;
- Enforce LLVM CRT based on Python and Meson version bypasing Meson 0.48.0 c_args and cpp_args loss;
- Update distribution maker to collect headers and libraries - fixes [#14](https://github.com/pal1000/mesa-dist-win/issues/14);
- Add a patch to get swr to build with LLVM 7.0. It incorporates [this patch](https://patchwork.freedesktop.org/patch/252354/) and Scons part I did myself.
- Adjust osmesa dual pass build hack to occur with swr as well.
### Debug
- Remove early, obsoleted and forgotten Meson build draft;
- llvm-config-output tool: Make it behave like llvm-wrap generator.
# 18.2.1
- Updated Mesa3D to [18.2.1](https://www.mesa3d.org/relnotes/18.2.1.html).
### Known issue
- No swr driver in this release due to build failure with LLVM 7.0.0. Weighting my options I decided to release quickly instead of doing a LLVM 6.0.1 x64 buid just get swr to build with it.
### Build environment updates
- CMake 3.12.1 -> 3.12.2;
- Visual Studio 15.8.3 -> 15.8.4;
- setuptools 40.2.0 -> 40.4.1;
- Git 2.18.0.1 -> 2.19.0.1;
- LLVM 6.0.1 -> 7.0.0.
### Build script
- Mesa3D Meson build: Disable SWR AVX512. It fails to configure for now;
- Mesa3D Meson build: Build config command cleanup;
- Mesa3D Meson build: graw framework support.
### Release maker
- Fix a complete silent failure with distribution creation when using Meson;
- Validate file existence before copying. Regression from when Meson build support was introduced in 18.1.8.
### Deployment
- Add support for Mesa3D Meson subprojects to per app deployment tool;
- Per app deployment tool learned how to [bypass LoadLibrary and LoadLibraryEx API calls with absolute paths](https://docs.microsoft.com/en-us/windows/desktop/dlls/dynamic-link-library-redirection), reducing the number of scenarios where Mesainjector is required.
# 18.2.0
- Updated Mesa3D to [18.2.0](https://www.mesa3d.org/relnotes/18.2.0.html).
# 18.1.8
- Updated Mesa3D to [18.1.8](https://www.mesa3d.org/relnotes/18.1.8.html).
### Build script
- Finally get LLVM link working when building Mesa3D with Meson;
- More robust way of using MsBuild backend when building Mesa3D with Meson;
- Make clean build and git_sha1.h fallback work with Meson;
- Standardize Meson build generating directory to `%mesa%\mesa\%abi%`;
- Make distribution creation work with Meson build.
### Docunentation
- Add a notice for enterprise environments documenting a scenario where running 3rd-party unsgned executables is prohibited, See [#11](https://github.com/pal1000/mesa-dist-win/issues/11).
### Build environment updates
- Visual Studio 15.8.1 -> 15.8.3;
- Add 7-zip to build environment configuration info as it is used to package releases.
# 18.1.7
- Updated Mesa3D to [18.1.7](https://www.mesa3d.org/relnotes/18.1.7.html).
### Build script
- Mesa3D build finally works with parallel dual Python. Python 2.7.x exclusive for Scons and Python 3.5.x+ exclusive for Meson.
### Build environment updates
- Visual Studio 15.7.6 -> 15.8.1;
- setuptools 40.0.0 -> 40.2.0.
# 18.1.6
- Updated Mesa3D to [18.1.6](https://www.mesa3d.org/relnotes/18.1.6.html).
### Build script
- Do not pass texture float build option to Mesa 18.2 and up;
- Mesa3D Meson build: Implement Msbuild support.
### Build environment updates
- winflexbison package 2.5.14 -> 2.5.15;
- Visual Studio 15.7.5 -> 15.7.6;
- cmake 3.12.0 -> 3.12.1.
# 18.1.5
- Updated Mesa3D to [18.1.5](https://www.mesa3d.org/relnotes/18.1.5.html);
- Remove LLVM version from version string. There is a prettier way to bump version when LLVM is updated.
### Build script
- Mesa3D Meson build dependency check: add pkg-config and libwinpthread;
- Initial Mesa3D Meson build configuration control;
- LLVM wrap generator for Mesa3D Meson build;
- Minor UI fix.
### Build environment updates
- cmake 3.11.4 -> 3.12.0;
- Bison 3.0.4 -> 3.0.5;
- pip 10.0.1 -> 18.0.
# 18.1.4.601-1
- Updated Mesa3D to [18.1.4](https://www.mesa3d.org/relnotes/18.1.4.html).
### End user guide
- Minor fix related to OpenGL context override.
### Build script
- Always flush pip cache before updating or installing python modules. I stil get cache parsing errors with Python 3.x;
- winflexbison is required to build Mesa3D regardless of build system used.
### llvm-config output grabber
- Make sure old output snapshot is not destroyed when LLVM binaries are missing.
### Build environment updates
- setuptools 39.2.0 -> 40.0.0;
- Visual Studio 15.7.4 -> 15.7.5.
# 18.1.3.601-1
- Updated Mesa3D to [18.1.3](https://www.mesa3d.org/relnotes/18.1.3.html).
### New features
- Enabled texture float and renderbuffers as patent expired on 6/17/2018.
### Build script
- Improve osmesa dual pass build workaround hack to minimize regression. osmesa classic should have integration with other drivers fully restored. Also there is no need to backup and restore softpipe and llvmpipe anymore.
### Build environment updates
- Update build configuration info to match latest changes;
- cmake 3.11.3 -> 3.11.4;
- Visual Studio 15.7.3 -> 15.7.4;
- git 2.17.1.2 -> 2.18.0.1;
- LLVM 6.0.0 -> 6.0.1.
# 18.1.2.600-2
### Deployment
- Per application deployment: validate program location.
# 18.1.2.600-1
- Updated Mesa3D to [18.1.2](https://www.mesa3d.org/relnotes/18.1.2.html).
### New features
- GLES, GLAPI and OpenGL ES support;
- Enable OpenMP.
### Known issues
- If you used per-app deployment to deploy Mesa3D desktop OpenGL driver you may encounter an error mentioning `libglapi.dll`. To fix it just do a re-deploy of the desktop OpenGL driver. If you don't remember if an affected program is 32-bit or 64-bit, right click on opengl32.dll shortcut in the folder where the program executable is located and select open file location. If the location ends in x64 then it's 64-bit otherwise it's 32-bit;
- osmesa does not have GLES support, also its integration with softpipe, llvmpipe and swr may be broken. This is due to workaround for [Mesa bug 106843](https://bugs.freedesktop.org/show_bug.cgi?id=106843) which affects Mesa3D builds with GLES support since at least [2012](https://lists.freedesktop.org/archives/mesa-users/2012-May/000431.html).
### End-user guide
- Document an issue with Virtualbox VMs that may happen if Mesa3D desktop OpenGL driver is installed inside the VM using system-wide deployment tool;
- Document known issues and OpenGL ES support.
### Build script
- Workaround a pip v10.0.1 bug by nuking pip cache. The cache processing bug throws a warning that permanently changes the text color to yellow;
- Always print Mesa3D build command on screen;
- Support express configuration of Mesa3D build;
- Workaround Mesa3D bug [106843](https://bugs.freedesktop.org/show_bug.cgi?id=106843) affecting Mesa3D build when GLES is enabled using an ugly hack I'd like to drop ASAP;
- Allow building graw without LLVM;
- Update build script documentation;
- Switch Mesa3D source code acquisition to Freedesktop Gitlab;
- Floating-pont textures, renderbuffers and OpenMP support.
### Build environment update
- Update build configuration.
# 18.1.1.600-1
- Updated Mesa3D to [18.1.1](https://www.mesa3d.org/relnotes/18.1.1.html).
### End user guide
- More documentation updates related to GL_ARB_compatibility and OpenGL context types.
### Build environment updates
- setuptools 39.1.0 -> 39.2.0
- Visual Studio 15.7.1 -> 15.7.3
- git 2.17.0.1 -> 2.17.1.2
- cmake 3.11.2 -> 3.11.3
# 18.1.0.600-1
- Updated Mesa3D to [18.1.0](https://www.mesa3d.org/relnotes/18.1.0.html).
### General documentation updates
- Make appropriate changes as Mesa3D now supports OpenGL 3.1 in compatibility context;
- Fix a bunch of typos and wording bugs in the process.
# 18.0.4.600-1
- Updated Mesa3D to [18.0.4](https://www.mesa3d.org/relnotes/18.0.4.html).
### Build environment updates
- Visual Studio 15.6.7 -> 15.7.1
- wheel 0.31.0 -> 0.31.1
- cmake 3.11.1 -> 3.11.2
### Build script
- Update documentation;
- Display warnings when LLVM is missing.
# 18.0.3.600-1
- Updated Mesa3D to [18.0.3](https://www.mesa3d.org/relnotes/18.0.3.html).
### Inno Setup
- Update Inno Setup script. It was broken two-fold, once when osmesa DLLs were moved to dedicated folders and again when deployment tool was split in two.
### Build script
- Fix Python 3.x version retrieval;
- Implement Python version validation without depending on Python launcher;
- Add /enablemeson command line switch to try Mesa3D Meson build;
- Python launcher interface is always used if possible;
- Python launcher interface: Support 32-bit Python on 64-bit Windows;
- Fix pypi based pywin32 installation again, the part that needs to run as admin was previously unreachable;
- wheel package is required to install Scons on Python 2.7.15, it also makes possible to uninstall pywin32 cleanly which may provide the means for error-free upgrade;
- Python launcher interface: Lookup for Python 3.x even if /enablemeson command line argument is unset as LLVM build can use it. Display appropriate warnings.
### Build environment updates
- Updated build machine OS to Windows 10 April 2018;
- Windows 10 SDK 10.0.16299.91 -> 10.0.17134.12;
- Python 2.7.14 -> 2.7.15;
- Installed wheel 0.31.0.
# 18.0.2.600-1
- Updated Mesa3D to [18.0.2](https://www.mesa3d.org/relnotes/18.0.2.html).
### Build script
- Python packages update: Use grid format pip list and skip pypiwin32 as well. This fixes the known issue from 18.0.1.600-1;
- Python launcher interface - handle too old Python versions gracefully;
- Python launcher interface - support picking Python 2.7 using only major version (2);
- Python launcher interface - hard fail if Python is too old;
- Python launcher interface - restart interface on invalid user input;
- Make sure Python launcher overrides PATH for LLVM build sake;
- Always get, store and use Python location in DOS format to simplify many things and make Python launcher PATH override apply only when needed.
### Environment updates
- pip 10.0.0 -> 10.0.1
- Visual Studio 15.6.6 -> 15.6.7
- setuptools 39.0.1 -> 39.1.0
# 18.0.1.600-1
- Updated Mesa3D to [18.0.1](https://www.mesa3d.org/relnotes/18.0.1.html).
### Deployment
- Per app deployment: Make text fit into Windows 7 default Command Prompt size.
### Build script
- Made the script aware of Python 2 and 3 variants, now with Py launcher and multiple Python 3 versions support;
- Before doing anything check all the dependencies availability including Meson (both Pypi and standalone versions being recognized) and record their state if it can change. This is an implementation of a dependencies state tracker;
- Always load Python in PATH as it is used everywhere and it convinces CMake to use same version of Python as Meson or Scons;
- Hard fail if Python or Visual Studio are missing;
- Add code comments to make code easy to read;
- Ported LLVM build to dependencies state tracker and stubbed Meson build support;
- Ported Mesa3D build to dependencies state tracker;
- Split the build script into modules as it grew too big;
- Check python packages availability and install them one by one if missing. setuptools and pip are updated before installing any missing package;
- Added support for full initial installation of pywin32 by properly requesting admin privileges, upgrading however is unsupported because it's dirty;
- First shot at getting  Mesa to build with Meson. Not functional, disabled.
### Environment updates
- cmake 3.10.3 -> 3.11.1
- git 2.16.3.1 -> 2.17.0.1
- Visual Studio 15.6.4 -> 15.6.6
- pip 8.0.3 -> 10.0.0
- Performed some reorganization to build environment report. Ninja is again used when building LLVM.
### Known issue
- The text may turn red in the Command Prompt in which the build script is running after updating Python packages. This is a glitch caused by pip 10.0.0.
# 18.0.0.600-1
- Updated Mesa3D to [18.0.0](https://www.mesa3d.org/relnotes/18.0.0.html).
### Build environment updates
- pip 9.0.2 -> 9.0.3
- Visual Studio 15.6.3 -> 15.6.4
- git 2.16.2.1 -> 2.16.3.1
### Build guide
- Remove a relic about Windows XP/PosReady 2009, it is no longer supported since Mesa3D 17.2.0;
- Describe the official way of loading git in PATH when using Git portable.
### Deployment
- Add uninstall and update support to system-wide deployment tool.
# 17.3.7.600-1
- Updated Mesa3D to [17.3.7](https://www.mesa3d.org/relnotes/17.3.7.html).
### Build environment updates
- Visual Studio 15.5.7 -> 15.6.3
- setuptools 38.5.1 -> 39.0.1
- LLVM 5.0.1 -> 6.0.0
- cmake 3.10.2 -> 3.10.3
- pip 9.0.1 -> 9.0.2
- Removed mention of Windows 8.1 SDK and Windows XP support for C++ from build environment as Mesa3D dropped XP support back in 17.2.0 release.
### Deployment
- Created 2 deployment methods, a per-application and a system-wide one respectively;
- Removed S3TC stand-alone library support;
- Bugfix: PROCESSOR_ARCHITECTURE can have lowercase string values in some cases;
- Cosmetic enhancements, support Windows 7 default size Command Prompt.
### User guide
- Minimize readme.txt. Just link to readme.md from GitHub;
- Update user guide to include the new system-wide deployment.
### Misc
- Made release notes incremental.
# 17.3.6.501-1
- Mesa3D 17.3.6 [release notes](https://www.mesa3d.org/relnotes/17.3.6.html).
### Build environment updates
- Git 2.16.1.4 -> 2.16.2.1
- Visual Studio 15.5.6 -> 15.5.7
- pywin32 222 -> 223
### Distribution creation and deployment utility
- Move each osmesa DLL in its own folder. Reduces usage complexity.
### Build script and build documentation
- Allow build without LLVM. Only osmesa-swrast, osmesa-gallium and softpipe are built in this case.
### Build script
- Drop pywin32 installation via pypi.
- Allow cancel build if LLVM is missing.
### End-user documentation
- Small enhancements.
### Won't fix
- This release breaks osmesa deployments performed with quick deployment utility. A re-deployment is required. Manual copy-pastes of osmesa libraries are unaffected.
# 17.3.5.501-1
- Updated Mesa3D to [17.3.5](https://www.mesa3d.org/relnotes/17.3.5.html).
### Build script
- Allow distribution creation without building Mesa if we have binaries from a past build.
# 17.3.4.501-1
- Updated Mesa3D to [17.3.4](https://www.mesa3d.org/relnotes/17.3.4.html).
### Build environment updates
- pywin32 221 -> 222.
- Visual Studio 15.5.4 -> 15.5.6.
- setuptools 38.4.0 -> 38.5.1.
- Git 2.16.0.2 -> 2.16.1.4.
### Build script
- Experimental: Get pywin32 via pypi.
- Drop support for libxtc_dxtn standalone library. Mesa3D 17.2 reached end-of-life on 23rd December 2017.
### Build script documentaiton
- pywin32 moved to Github.
- Drop support for libxtc_dxtn standalone library and other few miscellaneous changes.
### Inno Setup
- Drop S3TC standalone library support.
- Drop swr 32-bit support. Unsupported upstream.
### Debugging
- Add a script to generate LLVM config output. Allows for finding new LLVM libraries a lot easier using an online diff service like text-compare.com. Makes sending patches upstream easier.
# 17.3.3.501-1
- Updated Mesa to [17.3.3](https://www.mesa3d.org/relnotes/17.3.3.html).
### Build environment changes
- CMake: 3.10.1 -> 3.10.2.
- Visual Studio: 15.5.3 -> 15.5.4.
- winflexbison: 2.5.13 -> 2.5.14.
- Git: 2.15.1.2 -> 2.16.0.2.
# 17.3.2.501-1
 Update Mesa3D to [17.3.2](https://www.mesa3d.org/relnotes/17.3.2.html).
- Information about build environment and configuration is available [here](https://github.com/pal1000/mesa-dist-win/blob/17.3.2.501-1/buildenvconf.md).
- Add Git version to build environment report.
- Use Visual Studio MsBuild instead of Ninja when building LLVM. Ninja had no update since September 2017.
# 17.3.1.501-1
- Update Mesa3D to [17.3.1](https://www.mesa3d.org/relnotes/17.3.1.html).
- Information about build environment and configuration is available [here](https://github.com/pal1000/mesa-dist-win/blob/17.3.1.501-1/buildenvconf.md)
### User guide
- Expanded installation and usage section.
- Created a package contents section.
- Split tutorial about environment variables in its own section as it is relevant for both swr driver and manual GL context configuration.
- Add a swr driver use example.
### Build script documentation
- Visual Studio components related enhancement.
### Misc
- Add a detailed report about build environment and configuration.
# 17.3.0.500-1
-  Updated Mesa3D to [17.3.0](https://www.mesa3d.org/relnotes/17.3.0.html).

This is the first release of Mesa3D with built-in S3TC support so there is no dxtn.dll anymore. I enabled S3TC texture cache as always as integration made no change on that front. See [Mesa3D release notes](https://www.mesa3d.org/relnotes/17.3.0.html) for details.
 
- LLVM and Mesa3D were built with Visual Studio 2017 v15.5.1.
### Build script
- Use a simple python script to update all python packages. Don't load python scripts in PATH. Things might work fine regardless.
### Build script documentation
- Update Visual Studio 2017 list of components needed to build Mesa and LLVM.
### Usage documentation
- OpenGL 4.6 context handling landed in Mesa 17.3.
# 17.2.6.500-1
- Updated Mesa to [17.2.6](https://www.mesa3d.org/relnotes/17.2.6.html).
- Built with Visual Studio 2017 v15.4.4 and Scons 3.0.1.
### Build script
- Python packages update: pip freeze is seriously broken. Always use pip install -U. setuptools wasn't updated at all due to pip freeze shortcomings. Also Scons 3.0.1 wasn't picked up despite being live on Pypi.
- Python packages: wheel is no longer needed.
### Build script documentation
- Workaround a pywin32 installer bug.
- Updating setuptools pre-loaded with Python allows for successful installation of Scons via Pypi without having to install wheel.
# 17.2.5.500-1
- Updated Mesa3D to [17.2.5](https://www.mesa3d.org/relnotes/17.2.5.html).
- Built LLVM and Mesa3D with Visual Studio 2017 v15.4.3.
### Build script
- Mesa3D version and branch detection code cleanup.
### Build script documentation
- S3TC integration landed in Mesa 17.3.
# 17.2.4.500-1
- Updated Mesa3D to [17.2.4](https://www.mesa3d.org/relnotes/17.2.4.html).
- Built LLVM and Mesa3D with Visual Studio 2017 v15.4.1.
- Built S3TC with Mingw-w64 standalone GCC 7.2.0.
### Build script
- Fix Mesa version detection logic epic fail with release candidates.
- Dead variables clean-up.
- Load Visual Studio environment only when building LLVM with Ninja.
- S3TC build: If both MSYS2 and standalone Mingw-W64 are installed let the user pick which to use.
- S3TC MSYS2 build: prefer 64-bit MSYS2 over 32-bit if both installed.
### Build script documentation
- S3TC build with standalone Mingw-w64 is no longer deprecated. GCC 7.2 update finally took place.
- You are now asked which flavor of Mingw-W64 to use when building S3TC if both MSYS2 and standalone are installed.
# 17.2.3.500-1
- Updated Mesa3D to 17.2.3.
- Built S3TC with MSYS2 Mingw-w64 GCC 7.2.0.
- Built LLVM 5.0 and Mesa with Visual Studio 2017 v15.4.0.
### Deployment utility
- Made easy to swap osmesa variants.
- Check before attempting to create symbolic links. Avoid harmless errors which may be confusing.
### Build script
- Drop S3TC build if Mesa master source code is detected. S3TC is now built-in. Texture cache enabling patch is still needed though.
- Python packages updating: use both pip install -U <package-name> explicitly and pip freeze in a hybrid approach for most optimal behavior.
- Improved PATH cleanning.
- Support building S3TC with MSYS2 Mingw-W64 GCC by default. They fixed their problem with 32-bit binaries when they upgraded to GCC 7.2.0 (Alexpux/MINGW-packages#2271).
- Drop suport for Visual Studio 2015 completely. It survived so long due to Scons 3.0.0 issues.
- Mesa build without git workaround: git_sha1.h was generated in an incorrect location during 64-bit builds.
- Drop Scons 3.0.0 compatibility patch. It landed in Mesa 17.2.3.
- Allow building Mesa without git since Scons 3.0.0 compatibility patch landed in Mesa stable.
### Build script documentation
- MSYS2 Mingw-w64 is now the preferred method to build S3TC.
- Visual Studio 2017 is now required to build LLVM and Mesa3D.
# 17.2.2.500-1
- Updated Mesa3D to 17.2.2.
- Built with Scons 3.0.0. Made use of a compatibility patch.
- Built LLVM 5.0 and Mesa3D with Visual Studio 2017 v15.3.5.
### Build script
- Fixed python packages update check. Always check if mako not found, ask otherwise.
- Made build script aware of Mesa branches, helps with patches applicability narrowing.
- Add Scons 3.0.0 compatibility patch to Mesa3D Git-powered auto-patches. Only apply it to Mesa stable, patch is upstream now.
- Determine Mesa branch even if it is not built. Preparation for S3TC merger.
- Ensure auto-patching is done once and only once.
- Look for Git before trying to patch. It is pointless if it is not found.
- This script won't find Scons if it isn't in a certain relative location to it. Addressed this by fixing scons locating when Python it's in PATH right from the beginning.
- Added Scons to python update checking and auto-install. Depends on wheel. 1 less dependency requiring manual installation.
- Halt execution if Mesa is missing and it can't be acquired or its acquiring is refused by user.
- Drop LLVM 5.0 compatibility patch. Patch is upstream in all active branches.
### Build script documentation
- There is a compatibility fix for Scons 3.0.0.
- Scons can now be acquired by build script automatically. Depends on wheel.
- Git version control is now mandatory due to compatibility with latest Scons needing a patch.
- Updated questions list asked by this script.
### Known issues
- Mesa build: Scons 3.0.0 always uses target architecture compiler when using cross-compiling environment. This may impact compilation performance when making 32-bit builds.
# 17.2.1.500-1
- Updated Mesa3D to 17.2.1;
- Added OpenSWR support to deployment utility;
- Built Mesa3D with LLVM 5.0 using a patch which adds support for it;
- Built LLVM with Visual Studio 2017 v15.3.4;
- Mesa3D build: updated Python to 2.7.14;
- Build script: Always use a compiler that matches host architecture; previously CMake with MsBuild was always using 32-bit compiler throwing a warning in the process; ninja and Scons were using the compiler matching the build target architecture;
- Build script: Support downloading Mesa code using Git, apply LLVM 5.0 support and S3TC texture cache enabling patches automatically using Git when possible;
- Deployment utility and build script: [32-bit OpenSWR is unsupported](https://bugs.freedesktop.org/show_bug.cgi?id=102564#c5);
- Build script: Attempted restore of Visual Studio 2015 support; Visual Studio 2015 compatibility toolset for VS2017 should work fine; Visual Studio 2015 default toolset is untested;
- Build script documentation: switch Mesa download link to HTTPS, info about LLVM 5.0 support auto-patch, S3TC texture cache auto-patching, [unsupported 32-bit OpenSWR](https://bugs.freedesktop.org/show_bug.cgi?id=102564#c5) and build script wizard updates.
# 17.2.0.401-1
- Updated Mesa3D to 17.2.0;
- Rebuilt LLVM 4.0.1 with Visual Studio 2017 v15.3.3;
- Build script - show in title bar if building for x86 or x64;
- Build script dependency cleanup - Visual Studio C/C++ standard library modules are not needed.
# 17.1.8.401-1
- Updated Mesa3D to 17.1.8;
- Improve build script startup performance when no Internet connection is available. Regression from [7626fdb](https://github.com/pal1000/mesa-dist-win/commit/7626fdb).
# 17.1.7.401-1
- Buildscript - Visual Studio 2017 v15.3.2 compatibility fix and other improvements;
- Rebuilt LLVM 4.0.1 with Visual Studio 2017 v15.3.2.
- Updated Mesa3D to 17.1.7.
# 17.1.6.401-1
- Updated Mesa3D to 17.1.6
- Re-built LLVM 4.0.1 with Visual Studio 2017 v15.2.26430.16.
# 17.1.5.401-1
- Updated Mesa3D to 17.1.5.
# 17.1.4.401-1
- Rebuilt Mesa 17.1.4 with LLVM 4.0.1
- Built Mesa and LLVM with Visual Studio 2017 v15.2.26430.15.
# 17.1.4.400-1
- Update to Mesa 17.1.4;
- Rebuilt LLVM and Mesa with Visual Studio 2017 - v15.2.26430.14.
# 17.1.3.400-1
- Updated Mesa3D to 17.1.3;
- Improved manual OpenGL context configuration guide by adding detailed description of each context type.
# 17.1.2.400-1
- Updated Mesa to 17.1.2;
- Finished manual OpenGL context configuration tutorial;
- Built LLVM and Mesa with Visual Studio 2017 v15.2.26430.12.
# 17.1.1.400-1
- Updated Mesa to 17.1.1;
- Built LLVM and Mesa3D with Visual Studio 2017 v15.2.26430.4;
- Added manual OpenGL context configuration tutorial;
- Clean build script guide - remove LLVM 3.9.1 info.
# 17.1.0.400-1
### Changes
- Mesa is now built with LLVM 4.0;
- S3TC library  is now built with Mingw-w64 GCC 7.1.0 r0.
- LLVM and Mesa are both built with Visual Studio 2017 v15.0.26403.7.
### Enhancement
- Added OpenGL and GLSL version override samples (work in progress towards a complete guide).
### Notable upstream fix:
- LLVM 4.0 support in 2 steps closing [bug 100201](https://bugs.freedesktop.org/show_bug.cgi?id=100201):
a.  [c11/threads: Include thr/xtimec.h for xtime definition when building with MSVC](https://patchwork.freedesktop.org/patch/146826/);
b. [scons: update for LLVM 4.0](https://patchwork.freedesktop.org/patch/153385/).
### Notable upstream enhancement:
- GL_ARB_gpu_shader_int64 on i965/gen8+, nvc0, radeonsi, softpipe, llvmpipe.
# 17.0.5.391-1
- Updated Mesa to 17.0.5;
- Rebuilt LLVM 3.9.1 using Ninja build system. Saves a bit of storage space at my end;
- Built everything with Visual Studio 2017 v15.0.26403.7. 
# 17.0.4.391-2
### Buildscript improvements:
- Be aware of the fact that CMake and Python can add themselves to PATH;
- Fixed a serious issue causing the script to produce Debug LLVM builds instead of Release. cmake --build with Visual Studio generators does not honor CMAKE_BUILD_TYPE.
- Binaries produced for 17.0.4.391-1 were not affected as LLVM build was manually configured in Visual Studio IDE.
# 17.0.4.391-1
- Various buildscript enhancements and fixes;
- Quick deployment enhancements;
- Dropped system-wide registration.
### Known issue:
- In place upgrade from 17.0.3.391-2 and older has been broken due to changes made to installer when system-wide registration was dropped. This won't be fixed. Uninstall old version before installing this one.
# 17.0.3.391-2
### Bugfix
- Remove Program group screen from installer didn't actually work.
- The portable version is unchanged from previous release.
# 17.0.3.391-1
- Updated Mesa to 17.0.3;
- Added Osmesa off-screen rendering driver and graw library;
- Applied a patch for S3TC performance boost, credit goes to Federico Dossena;
- major build script enhancements (ninja support allowing LLVM build with backward compatibility toolset, LLVM and Mesa toolset matching validation, easy packaging post-build support, multiple bug fixes);
- Added support for Osmesa to local deployment utility, ported bug fixes from build script.
# 17.0.2.391-2
- Clarify that path to program launcher is quoted automatically in local deployment utility;
- Remove Program group screen from installer, it served no purpose and just caused confusion;
- Delete 32-bit cygwin runtime from system32/syswow64 leftover from 17.0.1.391-2 if present. 
- There are no changes with portable version since 17.0.2.391-1.
# 17.0.2.391-1
### Changes
- Updated Mesa to 17.0.2;
- Used Visual Studio 2017 to build LLVM, patched LLVM 3.9.1 to build with MSVC 2017 successfully as LLVM 4.0 is not yet supported;
- Used Visual Studio 2017 toolset for Mesa build working around [Mesa bug 100201](https://bugs.freedesktop.org/show_bug.cgi?id=100201);
- multiple buildscript and guides enhancements;
- unified 32 and 64-bit installers and local deployment utilities respectively.
### Known issue
 In place upgrade leaves a 32-bit Cygwin runtime in Windows\system32 for 32-bit Windows or Windows\syswow64 for 64-bit Windows if you are upgrading from 17.0.1.391-2. Clean it by downloading and running Cygwin installer for 32-bit Windows.
# 17.0.1.391-2
- Support GL_EXT_texture_compression_st3c;
- Use Mingw build of libtxc_dxtn for 64-bit apps and Cywin build of libtxc_dxtn-s2tc for 32-bit apps.
# 17.0.1.391-1
- Updated to Mesa 17.0.1;
- Support in-place upgrade.
# 17.0.0.391-4
- Improved installer: clean up registry during uninstallation;
- Added a local deployment utility, quickly deploy mesa for applications incompatible with system-wide installation while saving storage space; 
- Updated startup guide.
# 17.0.0.391-3
- Initial release.
- Includes softpipe/llvmpipe and OpenSWR built with LLVM 3.9.1.
