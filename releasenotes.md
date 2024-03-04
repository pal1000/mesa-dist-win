### Distribution
- There is no need to patch Vulkan drivers JSON files to fix them since 24.1.0-devel, [Vulkan JSON generation has been fixed](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/27468).
# 24.0.2
- Updated Mesa3D to [24.0.2](https://gitlab.freedesktop.org/mesa/mesa/-/blob/24.0/docs/relnotes/24.0.2.rst?ref_type=heads&plain=0).
# 24.0.1
- Updated Mesa3D to [24.0.1](https://gitlab.freedesktop.org/mesa/mesa/-/blob/24.0/docs/relnotes/24.0.1.rst?ref_type=heads&plain=0).
### Out of tree patching
- Remove llvmpipe headers compatibility patch with LLVM 17 as it appears it stopped being necessary as of LLVM 17.0.5 or 17.0.6, maybe a fix in LLVM made [original patch](https://gitlab.freedesktop.org/mesa/mesa/-/commits/main?search=only+include+old+Transform+includes+when+needed) sufficient.
### Build script
- Support configuring video acceleration codecs without VA-API dependency as this configuration is also used by Vulkan video extensions;
- Make d3d10umd deployment easier by matching Microsoft WARP filename when using 24.1.0-devel source or newer. 
# 23.3.5 and 24.0.0
- Updated Mesa3D to [23.3.5](https://gitlab.freedesktop.org/mesa/mesa/-/blob/23.3/docs/relnotes/23.3.5.rst?ref_type=heads&plain=0) and [24.0.0](https://gitlab.freedesktop.org/mesa/mesa/-/blob/24.0/docs/relnotes/24.0.0.rst?ref_type=heads&plain=0).
### Build configuration
- OpenCL external clang headers option [has been removed in 24.1.0-devel](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/25568).
### Out of tree patching
- Disable llvmpipe headers compatibility patch with LLVM 17 pending figuring out when it stopped being necessary.
# 23.3.4
- Updated Mesa3D to [23.3.4](https://gitlab.freedesktop.org/mesa/mesa/-/blob/23.3/docs/relnotes/23.3.4.rst?ref_type=heads&plain=0).
# 23.3.3
- Updated Mesa3D to [23.3.3](https://gitlab.freedesktop.org/mesa/mesa/-/blob/23.3/docs/relnotes/23.3.3.rst?ref_type=heads&plain=0).
### Out of tree patches
- Adjust patch fixing d3d10umd build aplicability, it is expected to land in 23.3.4.
### Binary versioning
- Update for year 2024.
### Build script
- LLVM MSVC build: Log start and finish timers;
- Use build script assets folder for Powershell temporary downloads.
# 23.3.2
- Updated Mesa3D to [23.3.2](https://gitlab.freedesktop.org/mesa/mesa/-/blob/23.3/docs/relnotes/23.3.2.rst?ref_type=heads&plain=0).
### Sponsorship
- [VPS host CPU updated](https://www.amd.com/en/products/cpu/amd-epyc-7542).
### Out of tree patches
- Add [patch fixing d3d10umd build](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/26370).
# 23.3.1
- Updated Mesa3D to [23.3.1](https://gitlab.freedesktop.org/mesa/mesa/-/blob/23.3/docs/relnotes/23.3.1.rst?ref_type=heads&plain=0).
### Build script
- MSVC build: Use a Python virtual environment, fixes [#163](https://github.com/pal1000/mesa-dist-win/issues/163);
- MSVC build: Drop attempt at supporting Meson Windows installer that was broken anyway since e3c32000da2d77840c0f02cefb609f00881b3183;
- VA-API: Add support for [new](https://gitlab.freedesktop.org/mesa/mesa/-/commit/d0c355601129fb0fcfb6039eee69217bc9597c77) [codecs build configuration options](https://gitlab.freedesktop.org/mesa/mesa/-/commit/7b22dd8bfdc380be2e4037c1207fcb30a46ad296) [24.0+].
# 23.3.0
- Updated Mesa3D to [23.3.0](https://docs.mesa3d.org/relnotes/23.3.0.html).
# 23.3.0-rc5
# 23.3.0-rc4
### Build script
- MSVC build: Move flex and bison detection after MSYS2 packages setup to ensure they are detected on fresh build environment setup;
- MSVC: Be more exact about Visual Studio workload requirements.
# 23.3.0-rc3
### Build script
- MSVC: Support building Mesa3D with MSYS2 flex and bison.
- MSVC build: Update DirectX headers to what is expected to be 1.611.1 stable;
- Misc/CMD syntax: Improve handling scenario where development root folder is a disk drive root;
- Misc/CMD syntax: Fix 2 spots where quoted path support is missing;
- MSYS2: Fix environment init when development root folder is a disk drive root.
# 23.3.0-rc2
### Build script
- CLI: Make prompt for Ninja build fit in one line at 800x600 resolution.
# 23.3.0-rc1
### Build script
- MSVC build: Finish LLVM 17 support;
- Mesa3D: Fix GLES build disabling logic;
- Misc: Fetch Resource Hacker over HTTPS;
- MSVC build: Update zlib and LLVM dependencies;
- MSVC build: Update DirectX headers to what is expected to be 1.611.0 stable.
### Release notes
- Fix dead links to Mesa3D release notes.
### Sponsorship
- Extended till November 2024.
### Out of tree patches
- Swrast patch supporting LLVM 17 only applies to 23.2 and up.
# 23.2.1
- Updated Mesa3D to [23.2.1](https://gitlab.freedesktop.org/mesa/mesa/-/blob/23.2/docs/relnotes/23.2.1.rst?ref_type=heads&plain=0).
### Build script
- LLVM MSVC build: LLVM_INCLUDE_TESTS=OFF implies LLVM_INCLUDE_GO_TESTS=OFF since at least LLVM 16;
- LLVM>=17 MSVC build: Replace LLVM_USE_CRT_RELEASE=MT with CMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded to avoid deprecation warning and prepare for the former removal in LLVM 18.
### Out of tree patches
- Initial LLVM and clang 17 linking compatibility patches.
# 23.1.8
- Updated Mesa3D to [23.1.8](https://docs.mesa3d.org/relnotes/23.1.8.html).
### Build script
- MinGW build: Replace vulkan-validation-layers with glslang as the former is only useful for runtime debugging now that glslangValidator migrated to later package.
# 23.1.7
- Updated Mesa3D to [23.1.7](https://docs.mesa3d.org/relnotes/23.1.7.html).
### Build script
- Link clang headers statically only when static linking OpenCL SPIRV [23.2+].
# 23.1.6
- Updated Mesa3D to [23.1.6](https://docs.mesa3d.org/relnotes/23.1.6.html).
### Build script
- llvmpipe s3tc texture cache build fix is pending to land in 23.2.0-rc3.
# 23.1.5
- Updated Mesa3D to [23.1.5](https://docs.mesa3d.org/relnotes/23.1.5.html).
# 23.1.4
- Updated Mesa3D to [23.1.4](https://docs.mesa3d.org/relnotes/23.1.4.html).
### Build script
- llvmpipe S3TC texture cache doesn't build anymore [23.2+].
# 23.1.3
- Updated Mesa3D to [23.1.3](https://docs.mesa3d.org/relnotes/23.1.3.html).
# 23.1.2
- Updated Mesa3D to [23.1.2](https://docs.mesa3d.org/relnotes/23.1.2.html).
### Build script
- MinGW: Enable LLVM Polyhedral optimizations;
- MinGW: Strip lib prefix from vaon12 driver filename.
### Build environment
- MinGW: Use DirectX headers distro package;
# 23.1.1
- Updated Mesa3D to [23.1.1](https://docs.mesa3d.org/relnotes/23.1.1.html).
# 23.1.0
- Updated Mesa3D to [23.1.0](https://docs.mesa3d.org/relnotes/23.1.0.html).
### Custom patching
- Patch fixing Microsoft CLC link with clang 16 landed in 23.1.
# 23.0.3
- Updated Mesa3D to [23.0.3](https://docs.mesa3d.org/relnotes/23.0.3.html).
### Custom patching
- Finish patch fixing Microsoft CLC link with clang 16.
### Build environment
- Update Directx headers to fix MinGW build.
# 23.0.2
- Updated Mesa3D to [23.0.2](https://docs.mesa3d.org/relnotes/23.0.2.html).
### Custom patching
- [Add incomplete patch trying to fix Microsoft CLC build with clang 16](https://gitlab.freedesktop.org/mesa/mesa/-/issues/7742#note_1647953).
### Build environment
- MinGW: Use older DirectX headers version.
# 23.0.1
- Updated Mesa3D to [23.0.1](https://docs.mesa3d.org/relnotes/23.0.1.html).
### End-user guide
- Typo fixes;
- Update sponsorship link;
- improve uninstall documentation as requested in #145.
# 23.0.0
- Updated Mesa3D to [23.0.0](https://docs.mesa3d.org/relnotes/23.0.0.html).
### End-user guide
- Document CLonD3D12 behavior change and D3D12 VA-API deployment.
### Sponsorship
- Upate affiliate link.
### Build script
- Move question about futex usage before unit tests build one to reflect [user feedback](https://github.com/pal1000/mesa-dist-win/discussions) trend;
- Keep disabling warning 4189 as d3d10sw still fails to build otherwise, revert 78ba58430edbd06b6233b37756af3fde608530ce.
### Out of tree patches
- ARM64: Update MCJIT patch to final form and stop applying it to 23.1;
- OpenCL SPIRV: Add patch fixing CLC JIT compilation with LLVM and clang 15 [22.3/23.0 up to 23.0.0].
### Distribution
- Add VA-API library to release package.
### Deployment
- Per application tool: VA-API interface support.
# 22.3.5
- Updated Mesa3D to [22.3.5](https://docs.mesa3d.org/relnotes/22.3.5.html).
### Build script
- MSVC: Disable [compiler warning 4189](https://learn.microsoft.com/en-us/cpp/error-messages/compiler-warnings/compiler-warning-level-4-c4189) when asserts are disabled otherwise build may fail [23.0];
- Move question about unit tests build right before futex usage as they are both enabled or disabled based on [user feedback](https://github.com/pal1000/mesa-dist-win/discussions);
- Fix VA-API support being disabled in MinGW build if libva MSVC build is missing, regression from 59e6f6a4b5286c0e357052ec929512a4a204759c.
# 22.3.4
- Updated Mesa3D to [22.3.4](https://docs.mesa3d.org/relnotes/22.3.4.html).
### Distribution
- ARM64: Use DXIL from DirectX shader compiler release package if present.
### Build script
- MinGW ARM64 implies using clang toolchain;
- Building llvmpipe for ARM64 requires an out of tree patch;
- Building dozen with clang requires an out of tree patch prior to 23.0.
### MSVC build environment
- Update SPIRV Tools to 2023.1;
- Update pkgconf to 1.9.4.
### MSYS2 build environment
- libva: Use distro package.
# 22.3.3-2
### Build environment
- MSVC: Update LLVM to 15.0.7.
# 22.3.3
- Updated Mesa3D to [22.3.3](https://docs.mesa3d.org/relnotes/22.3.3.html).
### New
- Early ARM64 build support contributed by [@yourWaifu](https://github.com/pal1000/mesa-dist-win/pull/130). For binaries ask @yourWaifu [here](https://github.com/pal1000/mesa-dist-win/issues/35) or on [his fork](https://github.com/yourWaifu/mesa-dist-win).
### Misc
- Implement an ABI selection module with ARM64 support to use by both build and deployment scripts.
### End user guide
- Readme: Document VA-API D3D12 driver.
### Build environment
- Update DirectX headers to v1.608.2b.
# 22.3.2
- Updated Mesa3D to [22.3.2](https://docs.mesa3d.org/relnotes/22.3.2.html).
### Build script
- Avoid harmless error due to git package removal attempt when missing;
- Don't install MSYS2 git package as it's not supported yet.
### Misc
- Sponsorship: Activate paid affiliation, add initial ending date and add sponsor button;
- Refactor Windows SDK and DXIL location detection;
- Refactor WDK install validaation.
### Distribution
- VA-API driver: Make sure DXIL is distributed with it;
- Use DXIL from [DirectX shader compiler release package](https://github.com/microsoft/DirectXShaderCompiler/tags) if present.
### Out of tree patches
- Stop applying build fix patch for static linking LLVM+Clang 15 as it was queued upstream for backport [22.3.2+].
### Build environment
- libva: Switch to stable release 2.17.0;
- Support downloading and extracting Resource Hacker automatically.
# 22.3.1
- Updated Mesa3D to [22.3.1](https://docs.mesa3d.org/relnotes/22.3.1.html).
### Build script
- Handle OpenCL drivers and draw module out of tree patch requirements with LLVM/Clang 15.
### Out of tree patches
- Update patch fixing static link with LLVM and clang 15 to cover draw module as well, see [#125](https://github.com/pal1000/mesa-dist-win/issues/125).
### End user guide
- Readme: Document VPS hosting sponsorship;
- Readme: Docment CLonD3D12 driver debut in MinGW package;
- Readme: Bring info about gallium raw interface removal in front, updates 5f3273a41beae48c258e946484059a8f3643a44f;
- Readme: Document GLonD3D12 standalone ICD removal in 22.3.0.
# 22.3.0
- Updated Mesa3D to [22.3.0](https://docs.mesa3d.org/relnotes/22.3.0.html).
### Build script
- Fix binary version info module crash when Mesa3D source is missing;
- MSVC: Increase build with debug symbols optimization.
### Debug
- MSYS2 debug tool: Make sure shell script can be generated.
### Build environment
- DirectX headers: fix code switch to release tag on initial clone;
- MSVC: Update LLVM to 15.0.6;
- Update DirectX headers to v1.608.0;
- MSVC: Update zlib to 1.2.13-2.
### Misc
- Nuget CLI: Improve setup module.
# 22.2.4
- Updated Mesa3D to [22.2.4](https://docs.mesa3d.org/relnotes/22.2.4.html).
### Build script
- clover: Stop forcing C++20 [22.3+];
- When disabling VA-API frontend do it explicitly or it remains enabled if libva dependency is found.
### Build environment
- MSVC: Roll LLVM 15.0.5.
### Distribution
- Add version info to MinGW built D3D12 VA-API driver [22.3+].
### Misc
- libva build: Generate pkg-config files in relocatable format.
### Out of tree patches
- Finish patch for static linking OpenCL stack with LLVM and clang 15.
# 22.2.3
- Updated Mesa3D to [22.2.3](https://docs.mesa3d.org/relnotes/22.2.3.html).
### Build script
- Python discovery: Python launcher 3.11 support;
- VA-API: Implement libva build [22.3+];
- Support building D3D12 VA-API driver with and without patented codecs [22.3+].
### Misc
- Make it clear that graw stands for gallium raw interface;
- pkgconf: Update meson setup command out of deprecated format;
- Autodetect CLonD3D12 ICD, libva, VA-API and zlib versions;
- MSVC environment load: Explicitly restore current folder consistently;
- MSVC: Load Ninja into build environment from Ninja usage module.
### End user guide
- Gallium raw interface is a dummy driver without any graphics API support;
- Gallium raw interface has been removed [22.3+];
- [Misc fixes by Hans Loeblich](https://github.com/pal1000/mesa-dist-win/pull/123).
### Build environment information
- MSVC: Add zlib version;
- Add OpenCLonD3D12 ICD version;
- MSVC: Roll LLVM 15.0.4;
- Add libva and VA-API versions;
- Add DirectX headers version.
### Distribution
- Add version info to D3D12 VA-API driver.
# 22.2.2
- Updated Mesa3D to [22.2.2](https://docs.mesa3d.org/relnotes/22.2.2.html).
### Distribution
- [Improve MSVC debug info package layout](https://gitlab.freedesktop.org/mesa/mesa/-/issues/7494#note_1592313);
- Fix check detecting MSVC build and hiding MinGW debug package creation;
- MinGW debug package: Don't collect unit tests if they are built;
- MinGW: Don't offer to keep binaries from previous build as this is only useful for MSVC.
### Build script
- Switch x64 MinGW build from MSVCRT to UCRT.
### Out of tree patches
- LLVM<->Clang linking match has been upstreamed in 22.2.2.
### Build environment
- MSVC: Update zlib to 1.2.13.
# 22.2.1
- Updated Mesa3D to [22.2.1](https://docs.mesa3d.org/relnotes/22.2.1.html).
### End-user documentation
- Document GLonD3D12, SPIRV to DXIL and dozen availability in MinGW package [22.2+];
- Document that development package is now in standard format, see #91 and [22.0.1 release notes](https://github.com/pal1000/mesa-dist-win/releases/tag/22.0.1);
- Document debug packages availability - #54;
- Update and improve table of contents.
### Build script
- LLVM MSVC: Seamless switch between legacy and current LLVM version;
- SPIRV LLVM Translator: Support build with LLVM binaries only take 2, fixes 649e3f8f4a74594a45e32b037bc7543501bd88d5;
- OpenCL stack: Draft support link with clang 15 (incomplete);
- clover opencl-native build option was removed in mesa3d/mesa@c74595ead3.
### Build environment updates
- LLVM MSVC: Update current version to 15.0.2.
# 22.2.0
- Updated Mesa3D to [22.2.0](https://docs.mesa3d.org/relnotes/22.2.0.html).
### Distribution
- Debugging support with PDBs for MSVC and debug optimized binaries for MinGW (#54);
- Perform debug information collection decoupled from distribution creation when posssible;
- Support disabling version information addition to binaries as GDB is unforgiving when it comes to binary tampering;
- Support keeping binaries, libraries and PDBs from previous build to support building different Mesa3D components with different major LLVM and clang releases.
### Build script
- pkgconf source code: go back 2 commits to workaround [Windows build break](https://gitea.treehouse.systems/ariadne/pkgconf/pulls/244);
- pkgconf source code was relocated to Gitea Teehouse;
- Disable Futex usage by default to reflect [poll](https://github.com/pal1000/mesa-dist-win/discussions/112) results;
- Make debug binaries optimization optional as they take a lot of RAM to link when using MSVC;
- Allow doing debug build with MinGW;
- SPIRV LLVM translator: Build out of tree and allow build without clang;
- MinGW: Support linking dependencies dynamically;
- Support building Mesa3D with asserts;
- SPIRV LLVM translator: Support build with LLVM binaries only;
- SPIRV LLVM translator: Retrieve LLVM major version from pre-built LLVM and support switching source branch automatically if necessary;
- LLVM MSVC: Support 2 parallel major versions via automatic source update to workaround https://gitlab.freedesktop.org/mesa/mesa/-/issues/7243;
- Reflect change from 7c547eb0 in clover out of tree patches requirement.
### Misc. refactor
- MSYS2: Move package cache cleanning inside package update module;
- Move question about Ninja build usage to a module to reuse it in all builds;
- Mesa3D build: Ask for Ninja build usage as soon as possible;
- MSYS2 vulkan-loader: Re-install only when necessary.
### Build environment updates
- Update libelf-lfg-win32 to 1.1.1;
- MSVC: Update LLVM to 15.0.1;
- MSVC LLVM source update: Delete files and folders that become untracked;
- Build environment info: Add old LLVM version;
- Update LLVM MinGW binary wrap fallback for 15.x releases;
- Freeze DirectX headers on stable release 1.606.4.
### Debugging
- MinGW: Add start debugging tutorial and script;
### Deployment
- Per application deployment: Do overwrite checks after previous deployment removal loop completes, fixes 13e86ba8889274cb892e2025ac3348d836279798.
# 22.1.7
- Updated Mesa3D to [22.1.7](https://docs.mesa3d.org/relnotes/22.1.7.html).
### Distribution
- clover: Support MinGW built binaries;
- SPIRV to DXIL MSVC binary distribution: Fix DXIL runtime distribution, regression from 952d8771c0bbd5f575d2073d50339a3dcbd4233c, fortunately other Microsoft components ensure DXIL runtime distribution as
well so this regresssion had no real world impact.
### Build script
- Building GLonD3D12 with MinGW requires Mesa 22.2.0-rc2 and up;
- Support creating debug friendly binaries when building with MSVC (#54).
### Out of tree patches
- Don't apply LLVM all targets linking patch for Microsoft CLC [22.2.0-rc3+].
# 22.1.6
- Updated Mesa3D to [22.1.6](https://docs.mesa3d.org/relnotes/22.1.6.html).
### Build script
- MSYS2: Import credentials from Git for Windows;
- Misc: Avoid Windows where tool internal error messages;
- Misc: Check if Git is available as quickly as possible;
- MSYS2: Always load Git for Windows when available;
- MSYS2: Change currrent directory to Windows current folder;
- MSYS2/Meson: Don't hardcode source code directory;
- MSYS2: Restore option to clear package cache after installing packages;
- OpenCL stack: Make sure we never link against clang-cpp library;
- MSVC: Support using clang build used by clc to build whole Mesa.
### Distribution
- MSYS2: Strip lib prefix from Microsoft CLC filename [22.2+].
# 22.1.5
- Updated Mesa3D to [22.1.5](https://docs.mesa3d.org/relnotes/22.1.5.html).
### Build script
- Mesa3D incremental build: Support LLVM discovery method change;
- Allow building osmesa with swr and without swrast;
- Disable draw with LLVM if LLVM native module ends being unused but needed, workaround for [upstream issue 6817](https://gitlab.freedesktop.org/mesa/mesa/-/issues/6817);
- Add [control mechanism](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/17431) for [Futex](https://en.wikipedia.org/wiki/Futex) usage [22.2+];
- clover: Allow using [LLVM lacking RTTI](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/17055) [22.0+ MSVC/22.2+ MinGW];
- Require swrast to build swr otherwise swrast, tessts and radv disabling would pull out draw with LLVM which swr requires;
- LLD is not needed to build Mesa3D OpenCL stack;
- OpenCL stack: Fix linking against a LLVM build with multiple targets;
- OpenCL stack: Support build with MinGW [22.2+];
- clover: Allow build for release candidates and development branch;
- Misc: Auto-detect default branch for repositories still using master.
### Out of tree patches
- Disable clover patch as it doesn't help.
### Build environment
- MSYS2: Install Mesa3D OpenCL stack build dependencies.
# 22.1.4
- Updated Mesa3D to [22.1.4](https://docs.mesa3d.org/relnotes/22.1.4.html).
### Build script
- Misc: Support adding more compiler flags as needed;
- Misc: Escape `=` and `:` in CFLAGS and LDFLAGS just to be safe;
- Misc: Reduce git pull verbosity;
- MinGW: Use Meson --prefer-static to link zlib, zstd and regex statically;
- Disable shared glapi when no Mesa3D OpenGL driver is built;
- [Support building GLonD3D12 with MSYS2](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/16084) [22.2+];
- Misc: Replace `FOR /D` with the [more reliable](https://ss64.com/nt/for_d.html) `FOR /F` and `dir /B /A:D` combo.
### Development package
- Mesa3D pkg-config files are now relocatable.
### Debug
- Fix test mingw builds;
- Patch test tool: Add work tree clean command;
- Patch test tool: Auto apply test patches and never apply other patches.
### Distribution
- Fixes for Microsoft components built with MinGW [22.2+].
### Out of tree patches
- Add patch fixing regex dependency lookup with MSYS2.
### Build environment
- Use pure subproject without wrap for DirectX headers discovery.
# 22.1.3
- Updated Mesa3D to [22.1.3](https://docs.mesa3d.org/relnotes/22.1.3.html).
### Build script
- [Support building dozen and SPIRV to DXIL with MSYS2](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/16084) [22.2+].
### Miscellaneous
- LLVM MSVC: Minimize source code size;
- Make sure existing tags are updated when using git pull.
### Build environment
- Update CLonD3D12 ICD to [2022.6.28](https://github.com/microsoft/OpenCLOn12/commits/6abbfaafc47b3b9ffaf19b694d0e32e2b44e0755).
# 22.1.2
- Updated Mesa3D to [22.1.2](https://docs.mesa3d.org/relnotes/22.1.2.html).
### Build script
- zink build no longer depends on Vulkan SDK/vulkan-devel [22.2+], fixes a553ad90;
- Don't build EGL when GLES is disabled, fixes b85491cb;
- RADV requires Vulkan SDK [22.2+].
### Build environment
- Update LLVM source for MSVC build to 14.0.5;
- Update SPIRV tools to sdk-1.3.216.0.
# 22.1.1
- Updated Mesa3D to [22.1.1](https://docs.mesa3d.org/relnotes/22.1.1.html).
### Documentation
- Add a complete Mesa3D uninstall procedure as requested [here](https://github.com/pal1000/mesa-dist-win/issues/20#issuecomment-1133666788);
- Document dozen driver availability, closes #104;
- Document the work in progress state of Microsoft drivers build with MinGW;
- Document the new zink driver Vulkan device selection priority system;
- Add link to official Mesa3D documentation;
- clover driver has been disabled until Windows support is finalized (#88).
- Misc documentation improvements.
### Build environment
- Update LLVM source for MSVC build to 14.0.4.
### Build script
- Disable clover build as it doesn't work (#88).
# 22.1.0
- Updated Mesa3D to [22.1.0](https://docs.mesa3d.org/relnotes/22.1.0.html).
- RADV has been removed from distribution per @zmike [suggestion](https://github.com/pal1000/mesa-dist-win/issues/103).
### Build script
- MSYS2: CLANG32 prefix is now available by default;
- Mesa3D depends on Vulkan loader only when zink driver is used [22.2+];
- Disable RADV build, see https://github.com/pal1000/mesa-dist-win/issues/103;
- LLVM MSVC: Source code update support.
### Miscellaneous
- Another attempt at enforcing CRLF line endings to CMD files, fixes eb367a2427526faf5b9a3d065b3b14971eb11400.
### Documentation
- Document RADV removal from distribution.
# 22.0.3
- Updated Mesa3D to [22.0.3](https://docs.mesa3d.org/relnotes/22.0.3.html).
### Build script
- LLVM MSVC build: Pull v14.0.3 if source code is missing.
# 22.0.2
- Updated Mesa3D to [22.0.2](https://docs.mesa3d.org/relnotes/22.0.2.html).
### Build script
- SPIRV translator: Support accelerating build configuration by using LLVM build;
- Mesa3D build: No need to [manually set compiler standards version anymore](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/15706) except for clover [22.1+];
- RADV MSYS2 build: Check if AMDGPU target is available just in case;
- Mesa3D build: Improve checks for DirectX headers dependency;
- Mesa3D build: Add support for dozen driver [22.1+];
- SPIRV Tools: Stay on stable releases and manually update to new release;
- Fix build option logic for SPIRV to DXIL when building dozen [22.1+];
- Mesa3D MSYS2 build: Do not set prefix build option as it causes Meson warnings related to Python;
- MSVC: Always build llvm-config tool and use it for LLVM detection by default with cmake as alternative;
- LLVM/MSVC: Pull source as admin to always include symlinks;
- zink MSVC build: Fix compatibility with LunarG Vulkan SDK >= 1.3.211.0.
### Distribution
- Dozen driver support [22.1+];
- SPIRV to DXIL obviously depends on DXIL so make sure it's distributed.
### Out of tree patches
- Update definition files fixing patches to final merged version and stop appllying them to 22.2+;
- Revise clang build fix patch and stop appplying it to 22.1+.
### Deployment
- Simplify Mesa3D OpenGL drivers system-wide registration.
### Toolchains
- Support finding MSYS2 in registry.
### Build dependencies
- MSVC build: Update zlib to 1.2.12-1.
# 22.0.1
- Updated Mesa3D to [22.0.1](https://docs.mesa3d.org/relnotes/22.0.1.html).
### Distribution
- Improve JSON patcher to operate without renaming RADV ICD;
- Improve Meson install command used to check distribution creation;
- Distribution creation: Drop support for osmesa classic;
- Distribution creation: Refactor it to match Meson install as much as possible;
- Make distribution creation more verbose to keep track of its progress more easily;
- Distribution creation: Skip subprojects pkg-config files;
- Development package: Add fixup tool for pkg config files.
### Miscellaneous
- Improve for loops across the board;
- Support quotes in MSYS2 commands;
- MSYS2: Convert paths to Windows quoted format;
- Switch away from DOS 8.3 path handling format;
- Performance: Deduplicate a loop in build environment information dumper.
### Build script
- LLVM MSVC build: Simplify error checks;
- LLVM MSVC build: Support generating build configuration command without performing the build;
- LLVM MSVC build: Fetch LLVM 14.0.0 when source is not available;
- LLVM MSVC: Build SPIRV translator in tree but on a different build folder than the rest of LLVM;
- Offer to build SPIRV translator only when building clang because Mesa3D requires both when building the exact same components;
- Python: Bump minimum requirement to 3.7 per Meson build demands;
- Avoid race condition in LLVM sources checkout, regression from 7ff9b39788bca17655d8269489fde851a94accee;
- Mesa3D: GLES drivers require at least an OpenGL driver;
- LLVM MSVC: Build SPIRV translator without SPIRV Tools integration due to [build failure](https://github.com/KhronosGroup/SPIRV-LLVM-Translator/issues/1454) and also we don't actually need it as Mesa3D links SPIRV Tools when necessary anyway.
# 22.0.0-2
### Out of tree patches
- Add patch fixing 32-bit MSVC build of Mesa 22.0.0.
### Build script
- Mesa3D build: Plug opencl-spirv build option leak;
- Mesa3D: Restore support for build without GLES;
- clover: Support incremental build for both standalone and ICD binaries.
### Distribution
- Ask for build revision number.
# 22.0.0
- Updated Mesa3D to [22.0.0](https://docs.mesa3d.org/relnotes/22.0.0.html).
### Deployment
- System-wide deployment: Detect and warn about conflict with Microsoft OpenCL and OpenGL Compatibility Pack;
- Per application deployment: Wipe existing deployments in selected folder at startup;
- Per application deployment: Improve reliability with subsequent deployments;
- Per application deployment: Support replacing Mesa3D bundled with QT framework - #31;
- Per application deployment: Warn about potential overwrite of software own files for which Mesa3D is deployed - #31;
- System wide deployment: Improve menu options listing reliability;
- System wide deployment: Reuse code for deployment termination;
- System wide deployment: Track available and deployed components with state variables;
- System wide deployment: Validate menu selection early;
- Deployment tools: Drop support for osmesa classic as it was removed in Mesa 21.0;
- System wide deployment: Improve Mesa3D OpenGL de-registration;
- System wide deployment: Handle partial or incomplete Mesa3D packages more seamlessly.
### Documentation
- Update docs about OpenGL contexts and drivers availability changes.
# 21.3.7
- Updated Mesa3D to [21.3.7](https://docs.mesa3d.org/relnotes/21.3.7.html).
### Build script
- Always build Mesa3D 21.3+ with shared glapi as static glapi is no longer supported;
- Support Visual Studio Build Tools.
### Debug
- MSYS2: Improve package cache cleanup.
### Deployment
- Per application deployment: clover standalone support.
### Documentation
- Expand CLonD3D12 documentation.
# 21.3.6-2
### Build environment
- Add Nuget Commandline tool version information.
### Build script
- LLVM: Remove in-tree SPIRV translator build in favor of the out of tree one;
- LLVM: Remove incremental build support as it's no longer relevant and it was terribly buggy in edge case scenarios anyway.
### Distribution
- Add CLonD3D12 driver.
### Documentation
- End user guide: Document CLonD3D12 driver availability.
# 21.3.6
- Updated Mesa3D to [21.3.6](https://docs.mesa3d.org/relnotes/21.3.6.html).
### Build script
- Meson build: Add checks to run_command() calls;
- Enforce CRLF line endings to batch scripts using Git attributes;
- Update SPIRV headers only when necessary to avoid build folder becoming dirty;
- Implement CLonD3D12 ICD build, see [issues tagged with OpenCL](https://github.com/pal1000/mesa-dist-win/issues?q=is%3Aopen+is%3Aissue+label%3AOpenCL);
- CLonD3D12: Enforce dependency on WDK;
- CLonD3D12: Update source code whenever possible;
- CLonD3D12: Disable Ninja build as it doesn't appear to be supported;
- CLonD3D12: Enforce dependency on nuget CLI and use it as necessary;
- LLVM build: Pull v13.0.1 source by default;
- SPIRV Tools build: Improve source code availability validation;
- Obtain and update Nuget CLI with Powershell;
- Perform SPIRV LLVM translator build out of tree.
### Build environment
- Fix Windows SDK version detection;
- Add Windows Driver Kit version information.
# 21.3.5
- Updated Mesa3D to [21.3.5](https://docs.mesa3d.org/relnotes/21.3.5.html).
### Build script
- Support building SPIRV LLVM translator with SPIRV Tools integration;
- HACK: OpenCL stack on Mesa 21.3+ requires RADV to be part of build if LLVM AMDGPU target is available, see [[1](https://gitlab.freedesktop.org/mesa/mesa/-/issues/5666)] and [[2](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/12276#note_1200369)].
### Distribution
- RADV: Do not distribute JSON manifest if ICD is missing as JSON manifest is generated even if RADV build fails.
# 21.3.4
- Updated Mesa3D to [21.3.4](https://docs.mesa3d.org/relnotes/21.3.4.html).
### Build script
- MSYS2: Revert 5aac0ca4 as this doesn't actually work as expected;
- Perform clover standalone+ICD preservation maneuver right after build;
- MSYS2/CLANG32: Fetch packages database when enabling it, fixes 4c3e785e;
- MSYS2: Take advantage of the new `cc` virtual package;
- MSYS2: Pull packages databases just once.
### Debug
- MSYS2: Simplify setup command and make it work in MSYS shell.
# 21.3.3
- Updated Mesa3D to [21.3.3](https://docs.mesa3d.org/relnotes/21.3.3.html).
### Build script
- Correct check for swr driver availability, fixes bba6cc7a and b902610d;
- clover: When disabling SPIR-V binary support, do it explicitly;
- MSYS2: Use a more recommended way to update packages;
- clover: Try keeping ICD build intact while building standalone version and vice versa;
- LLVM: Implement incremental build support for when only SPIRV translator and libclc need rebuild.
### Out of tree patches
- Limit SWR MSVC build fix for 21.3 to all releases prior to 21.3.3.
### Documentation
- End user guide: Document clover driver availability.
# 21.3.2
- Updated Mesa3D to [21.3.2](https://docs.mesa3d.org/relnotes/21.3.2.html).
### Build script
- clover build: Don't enable native OpenCL backend as [it's not supported on Windows](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/12276#note_1175794);
- SPIRV tools: checkout and update stable branch only;
- Avoid potential dangerous race condition in LLVM sources checkout after SPIRV tools build which can occur because both x86 and x64 builds can run simultaneously for both SPIRV tools and LLVM.
### Out of tree patches
- Revise patches fixing Mesa3D build with MSYS2 MinGW-W64 clang;
- Restrict link flags passing fix for MinGW to Mesa 21.3.1 and older.
### Distribution
- Add support for clover OpenCL stack;
- Take into account that RADV can be built for 32-bit [22.0+].
# 21.3.1-2
### Build script
- Adjustments to reflect swr driver removal [22.0+].
### Out of tree patches
- Revise and split patch fixing Mesa3D build with MSYS2 MinGW-W64 clang and apply its components all the time;
- Add patch fixing symbols exporting for MinGW-W64 GCC x86.
# 21.3.1
- Updated Mesa3D to [21.3.1](https://docs.mesa3d.org/relnotes/21.3.1.html).
### Documentation
- Update for 21.3 features.
### Build script
- MSYS2: Use distinct build folders for GCC and clang;
- Update SPIRV Tools even when not building it;
- Change LLVM build and install folders so Git ignores them;
- Update SPIRV translator if possible even when not building LLVM;
- Some more 32-bit build host improvements, 435beaca follow up;
- Be more comprehensive on what Mesa3D components require LLVM;
- Announce Git version control operations;
- Make SPIRV tools build configuration command match Mesa3D CI;
- Use absolute paths with cmake anywhere we can as libclc can hit too long paths;
- Specify LLVM RTTI support to Mesa3D [22.0+];
- MSYS2: Implement CLANG32 build support and activate its toolchain only when using it;
- MSYS2: Explicitly install ZSTD as it's necessary when building with clang;
- d3d10sw: Perform WDK check only when all other checks pass due to it being expensive as it runs for 5-10s everytime;
- MSYS2: Use binary wrap to link LunarG Vulkan SDK when building with clang;
- MSYS2: Simplify LLVM binary wrap fallback.
### Debug
- MSYS2: Support clang and UCRT GCC prefixes;
- MSYS2: Use dedicated command to clear pacman cache.
### Build environment information
- Get 7-zip version from command line tool;
- Automatically get LunarG Vulkan SDK version.
### Out of tree patches
- Add patch fixing link flags passing for MinGW;
- Restrict RADV build fix with LLVM 13 and MSVC patch applicability to reflect 21.2 backport;
- Add patch to fix Mesa3D build with MSYS2 MinGW-W64 clang and only apply it when building with clang.
# 21.3.0
- Updated Mesa3D to [21.3.0](https://docs.mesa3d.org/relnotes/21.3.0.html).
### Build script
- Finish SPIRV Tools build;
- Improve and re-enable MinGW clang build;
- Enforce Microsoft OpenCL compiler dependency on clang and lld;
- Mesa3D clean build: Pause after displaying build configuration command;
- LLVM MSVC build: Fix RTTI enablement;
- Force convert unicode to ASCII when parsing plaintext files in for loops;
- LLVM: Offer to build AMDGPU target on 32-bit;
- Build SPIRV Tools from stable branch;
- Fix an excessive build blocking condition when patches are disabled as individual components are disabled as necessary;
- Support building RADV for 32-bit [22.0+];
- Support building libclc when performing 32-bit Mesa build by handling it like pkgconf;
- Query LLVM RTTI support without relying on llvm-config;
- Misc fixes for 32-bit build host;
- clover build support - #28 and #81.
### Distribution
- Add version info to Microsoft OpenCL compiler.
### Build environment information
- Fix version information retrieval for Resource hacker by creating build script assets folder in advance;
- Add SPIRV Tools version.
### Out of tree patches
- Restrict RADV build fix with LLVM 13 and MSVC patch applicability.
# 21.2.5
- Updated Mesa3D to [21.2.5](https://docs.mesa3d.org/relnotes/21.2.5.html).
### Build script
- Do not link regex when building with MSVC, regression from 50115ec7 [21.3+];
- Explicitly handle EGL build configuration option value to ensure incremental build consistency [21.3+];
- MinGW: Update hardcoded libraries fallback for LLVM 13;
- Make incremental build resilient against toolchain switch operations.
### Distribution
- Add version info to Mesa3D EGL library [21.3+];
- Avoid copying Meson 0.60 and newer JSON build artifacts.
### Deployment
- Add support for Mesa3D EGL library to per application deployment tool [21.3+].
### Out of tree patches
- Add patch fixing swr driver build with LLVM 13;
- Add patch fixing swr driver build with MSVC [21.3+];
- Add patches fixing RADV driver build with MSVC and LLVM 13;
- Add patch fixing d3d10sw build [21.3+];
- Add patch fixing vulkan core build with MSVC 32-bit [21.3+].
### Miscellaneous
- Refactor gitignore to ignore binaries from everywhere in this repository.
# 21.2.4
- Updated Mesa3D to [21.2.4](https://docs.mesa3d.org/relnotes/21.2.4.html).
### Build script
- MSVC build: Python 3.10 and newer support;
- MSVC build: Make Python PATH loading consistent with official installer;
- MSVC LLVM build: Update to 13.0.0;
- LLVM MSVC build v13+: Consider SPIRV translator dependency on SPIRV headers.
# 21.2.3
- Updated Mesa3D to [21.2.3](https://docs.mesa3d.org/relnotes/21.2.3.html).
### Build script
- MinGW: Always link regex [21.3+], fixes #79.
# 21.2.2
- Updated Mesa3D to [21.2.2](https://docs.mesa3d.org/relnotes/21.2.2.html).
### Build script
- Avoid pulling source update immediately after fresh source cloning.
### Distribution and deployment
- Add support for [standalone OpenGL gallium megadriver](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/12677) [21.3+].
# 21.2.1
- Updated Mesa3D to [21.2.1](https://gitlab.freedesktop.org/mesa/mesa/-/blob/21.2/docs/relnotes/21.2.1.rst?ref_type=heads&plain=0).
### Build script
- MinGW: Build RADV with mingw-w64-libelf instead of libelf-lfg-win32.
### End-user guide
- Document 21.2 Windows specific features.
### Out of tree patches
- Restrict RADV build fix for MinGW patch to 21.2 series before 21.2.1 as patch was backported.
# 21.2.0
- Updated Mesa3D to [21.2.0](https://docs.mesa3d.org/relnotes/21.2.0.html).
### Build script
- Always use C17 and VC++latest standards;
- Make sure libelf is up to date;
- Remove dead code related to regex dependency;
- Enforce RADV dependency on libelf;
- LLVM: Save time by not offering to build AMDGPU target on 32-bit as RADV is unsupported in this scenario;
- Improve code for patch reversal.
# 21.1.6
- Updated Mesa3D to [21.1.6](https://docs.mesa3d.org/relnotes/21.1.6.html).
### Build script
- zink MSVC build: Fix Vulkan runtime delay load [21.2+];
- Mesa3D build: Keep going as far as possible on build failure;
- Fix radv build with MinGW and disable it for 32-bit [21.2+];
- Fix d3d10sw build and enforce its dependency on WDK [21.2+].
### Distribution
- Fix JSON for radv [21.2+];
- Add version info to RADV and d3d10sw [21.2+];
- DirectX IL for redistribution deployment: Windows 11 SDK compatibility.
### Debugging
- Remove obsolete scons MSVC sample.
# 21.1.5
- Updated Mesa3D to [21.1.5](https://docs.mesa3d.org/relnotes/21.1.5.html).
### Build script
- Support building Mesa3D without softpipe and llvmpipe;
- Support building zink with MSVC and delay load Vulkan runtime for it [21.2+];
- Microsoft OpenCL compiler also depends on LLVM core;
- Support AMD Vulkan driver - radv [21.2+];
- Support Mesa3D D3D10 software renderer [21.2+];
- Misc incremental build fixes.
### Build environment information
- Add LunarG Vulkan SDK version to MSVC build environmment information.
### Dependencies
- Fetch LLVM 12.0.1 if LLVM source code is missing.
# 21.1.4-2
- Restore swr driver in MinGW package.
# 21.1.4
- Updated Mesa3D to [21.1.4](https://docs.mesa3d.org/relnotes/21.1.4.html).
### Build script
- Mesa3D: Treat all files as UTF-8 encoded, port mesa3d/mesa@b437fb81.
# 21.1.3
- Updated Mesa3D to [21.1.3](https://docs.mesa3d.org/relnotes/21.1.3.html).
### Build script
- Improve libclc build cleaning;
- LLVM: Don't print 2 new lines when skipping build on demand;
- Display generated libclc build configuration command;
- Only build libclc with x64 LLVM to avoid needless duplicated work and install it separated from x64 and x86 LLVM due to being non-machine code, see https://gitlab.freedesktop.org/mesa/mesa/-/issues/4888 for more information;
- Fix logic determining when lavapipe cannot build.
### Documentation
- Document `libvulkan-1.dll` being missing error.
# 21.1.2
- Updated Mesa3D to [21.1.2](https://docs.mesa3d.org/relnotes/21.1.2.html).
### Binary version info
- Set revision in a single central spot.
### Documentation
- End user guide: Document that zink driver now works with Vulkan CPU devices when `ZINK_USE_LAVAPIPE=true` is set as expected;
- End user guide: Correct scenario description that leads to `libglapi.dll` missing error.
### Build script
- MSYS2: Disable option to use clang compiler instead of GCC as Mesa3D fails to build with it most of the time;
- LLVM: Initial libclc build support;
- Prepare Mesa3D build for Microsoft OpenCL compiler.
### Utilities
- Implement unattended mode in MinGW vulkan loader compatibility tool.
# 21.1.1
- Updated Mesa3D to [21.1.1](https://docs.mesa3d.org/relnotes/21.1.1.html).
### Build script
- Fix lavapipe build with MinGW static CRT without using out of tree patch;
- MSYS2: Use Meson find_library to switch zlib and ZSTD dependencies to static linking;
- LLVM: Add SPIRV LLVM Translator build required by Microsoft OpenCL compiler;
- LLVM: Add AMDGPU target required by RADV;
- LLVM: Refactor build configuration command to match Mesa3D CI as much as possible;
- Mesa3D source fetch: Adjust default branch to main.
### Out of tree patches
- Limit lavapipe patches to 21.1 before 21.1.1 stable as both got backported.
### Build environment info dumper
- Always use x64 config tool to find LLVM, fixes e2587645;
- Add manually updated Vulkan SDK version.
# 21.1.0
- Updated Mesa3D to [21.1.0](https://docs.mesa3d.org/relnotes/21.1.0.html).
### Build script
- LLVM: Show build configuration command before wiping existing build;
- LLVM: Build clang tools with clang and lld - fixes eb27094;
- LLVM: Restore config tool build for x64 when using VS backend - fixes e155b4c;
- Mesa3D: Retry build logic improvements.
### Out of tree patches
- Add lavapipe build fix for MinGW static CRT - [MR 10305](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/10305);
- Add lavapipe crash fix for MinGW - [MR 10379](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/10379);
- Add lavapipe build fix for MSVC x86 32-bit - [MR 10573](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/10573).
### Documentation
- Document lavapipe support in 21.1.0 and beyond.
# 21.0.3
- Updated Mesa3D to [21.0.3](https://docs.mesa3d.org/relnotes/21.0.3.html).
### End-user documentation
- Make it clear that `libglapi.dll` is required by all OpenGL/GLES drivers when present in release package.
### Debugging
- Implemented list, git and current folder showing commands in patch tester.
# 21.0.2
- Updated Mesa3D to [21.0.2](https://docs.mesa3d.org/relnotes/21.0.2.html).
### Deployment
- Add support for GLonD3D12 standalone driver in system wide deployment tool;
- Avoid potential errors during uninstall in system-wide deployment tool.
### End-user documentation
- Add known issues section;
- Drop obsolete info;
- Expand description of Mesa3D drivers available on Windows. See [#55](https://github.com/pal1000/mesa-dist-win/issues/55) and [#59](https://github.com/pal1000/mesa-dist-win/issues/59) for support tickets hinting that there is not enough info in documentation.
### Build script
- Restore x64 llvm-config tool build as it's needed during build environment info dump.
### Debug tools
- MSYS2: Drop clang from setup command and break between packages install and cache clearing.
# 21.0.1
- Updated Mesa3D to [21.0.1](https://docs.mesa3d.org/relnotes/21.0.1.html).
### Build script
- MSVC build: Switch LLVM discovery method from config tool to cmake;
- LLVM: Build install target again now that configuration has been optimized.
### Deployment
- Add version info for Microsoft SPIR-V to DXIL library.
### Documentation
- Add info about zink, GLonD3D12 and SPIR-V to DXIL tool to end user guide.
# 21.0.0
- Updated Mesa3D to [21.0.0](https://docs.mesa3d.org/relnotes/21.0.0.html).
### Debug
- Install gdb to help with debugging MinGW-W64 build;
- Standalone MinGW-W64 test: Add zink driver and multilib support;
- Standalone MinGW-W64 test: Switch to debug optimized build.
### Build script
- Allow building SWR AVX512 with MinGW-W64 when out of tree patches are disabled;
- Restore incremental build support to Mesa3D;
- LLVM build: Install CMake modules;
- Add support for lavapipe driver [21.1+];
- Add support for SPIR-V to DXIL tool - Fixes [#49](https://github.com/pal1000/mesa-dist-win/issues/49).
### Deployment tools
- Drop problematic delay support from system wide deployment tool unattended mode;
- Support deploying DirectX IL for redistribution only in system wide deployment tool;
- Support keeping DirectX IL for redistribution in system wide deployment tool during uninstall.
# 20.3.4
- Updated Mesa3D to [20.3.4](https://docs.mesa3d.org/relnotes/20.3.4.html).
### Build script
- Add support for Microsoft OpenGL over D3D12 driver [21.0+];
- Make it possible to re-try Mesa3D build on failure;
- Support choosing Vulkan SDK to use with Mesa3D zink driver build [21.0+].
### Build dependencies
- Update zlib wrap to 1.2.11-5;
- Update DirectX headers before build [21.0+].
### Release utilities
- Make improvements to `libvulkan-1.dll` error fixing tool [21.0+].
### Distribution creation
- Collect DXIL runtime from Windows SDK if GLonD3D12 is present in release package [21.0+];
- Add version info to ICD build of Microsoft OpenGL over D3D12 driver [21.0+].
### Deployment tools
- Add support for DirectX IL runtime [21.0+];
- Create symlink for libglapi even if missing from release package;
- Support for unattended mode in system wide deployment tool - [#48](https://github.com/pal1000/mesa-dist-win/issues/48);
- Per-app deployment: Remove .local files if no filename is provided to help with reversing per-app deployment actions if necessary.
### Debug
- Tweak standalone MinGW-W64 build test to reproduce https://gitlab.freedesktop.org/mesa/mesa/-/issues/4151 [21.0+].
# 20.3.3
- Updated Mesa3D to [20.3.3](https://docs.mesa3d.org/relnotes/20.3.3.html).
### Build script
- LLVM: Add support for building LLVM with clang and lld;
- Update pkgconf source code before build.
# 20.3.2
- Updated Mesa3D to [20.3.2](https://docs.mesa3d.org/relnotes/20.3.2.html).
### Debuggers
- MSYS2: Setup command now minimizes pacman cache after installation phase.
# 20.3.1
- Updated Mesa3D to [20.3.1](https://docs.mesa3d.org/relnotes/20.3.1.html).
### Release utilities
- Add tool to fix error related to `libvulkan-1.dll` being missing which can occur if Mesa3D was built with zink driver - [issue 30](https://github.com/pal1000/mesa-dist-win/issues/30).
### Build dependencies
- Update LLVM binary wrap fallback for LLVM 11.
### Build script
- Take into account osmesa classic removal in Mesa 21.0.
# 20.3.0
- Updated Mesa3D to [20.3.0](https://docs.mesa3d.org/relnotes/20.3.0.html).
### Build script
- zink driver support is postponed to 21.0 series.
# 20.2.3
- Updated Mesa3D to [20.2.3](https://docs.mesa3d.org/relnotes/20.2.3.html).
### Debug
- Add patch test tool.
### Build script
- Initial preparation for zink driver.
# 20.2.2
- Updated Mesa3D to [20.2.2](https://docs.mesa3d.org/relnotes/20.2.2.html).
### Build script
- MinGW: Use pkgconf as pkg-config implementation.
# 20.2.1
- Updated Mesa3D to [20.2.1](https://docs.mesa3d.org/relnotes/20.2.1.html).
### Docs
- Update end-user guide.
### Build script
- Add experimental build with MSVC and clang (currently disabled);
- Get LLVM 11.0.0 by default if LLVM is missing.
### Debug
- MSYS2: Allow selecting MSYS2 shell.
### Patching
- Disable LLVM build fix patch for MSVC>=16.7.0 as it's no longer needed with LLVM>=11.0.0.
# 20.2.0
- Updated Mesa3D to [20.2.0](https://docs.mesa3d.org/relnotes/20.2.0.html).
### Build script
- Mesa3D: Avoid using Meson options that don't work with toolchain in use.
### Debug
- MSYS2: Add setup command to install Mesa3D build dependencies.
# 20.1.8
- Updated Mesa3D to [20.1.8](https://docs.mesa3d.org/relnotes/20.1.8.html);
- ZSTD is now used for certain compression tasks in MinGW package.
### Build script
- Limit swr driver mingw build compatibility patch to Mesa 20.1 before 20.1.8 and 20.2 before 20.2.0 stable;
- MSYS2: Use a very brutal but simpler approach to static linking zlib and reuse it for zstd.
# 20.1.7
- Updated Mesa3D to [20.1.7](https://docs.mesa3d.org/relnotes/20.1.7.html);
- Added swr driver to mingw package.
### Build script
- Refactor check that determines if swr driver is buildable to support mingw.
# 20.1.6
- Updated Mesa3D to [20.1.6](https://docs.mesa3d.org/relnotes/20.1.6.html).
### Build script
- Fix build of Mesa 20.2 and higher, regression from 5f35c3e4;
- LLVM build: Use relative path in CMAKE_INSTALL_PREFIX;
- MSYS2/zlib subproject: Request static library via per subproject wrap force fallback feature introduced in Meson 0.55 instead of a dirty old patch to Mesa source code;
- Move out of tree patches applicability test before pkgconf and LLVM build;
- MSYS2 patch: Support patching multiple source repositories.
### Out of tree patching
- LLVM: Add patch to fix build with Visual Studio 16.7 and newer.
# 20.1.5
- Updated Mesa3D to [20.1.5](https://docs.mesa3d.org/relnotes/20.1.5.html).
### Out of tree patching
- Don't apply force static zlib link patch when building with MSVC as it's not necessary.
### Debug
- Add a minimal Scons build with MSVC and Python 3.
# 20.1.4
- Updated Mesa3D to [20.1.4](https://docs.mesa3d.org/relnotes/20.1.4.html).
# 20.1.3
- Updated Mesa3D to [20.1.3](https://docs.mesa3d.org/relnotes/20.1.3.html).
### Build script
- Switched Mesa3D internal libraries to shared linking like [upstream](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/5689/diffs?commit_id=ee056dfef6e3567d49e82fe4af8604885ef736f5);
- Support both old and new style booleans of Mesa3D build options.
### Distribution creation
- Detect and handle dual and single osmesa without relying on toolchain type;
- Update vendor string following upstream lead in [mesa3d/mesa#5483](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/5483).
# 20.1.2
- Updated Mesa3D to [20.1.2](https://docs.mesa3d.org/relnotes/20.1.2.html).
### Build script
- Restore some LLVM build reduction used with Ninja that doesn't break Meson runtime dependency detection;
- Support building LLVM core from monorepo;
- Display LLVM build configuration command on screen.
### Debug
- Fix fatal flaw in LLVM install modifier tool;
- Add monorepo support to LLVM install modifier tool.
# 20.1.1-2
- This is a re-release of 20.1.1 with swr driver restored.
### Build script
- Mesa3D: Make build config aware of out of tree patching being disabled or unsupported;
- Use a command line option to disable out of tree patches for Mesa3D;
- Show in title bar when out of tree patches are disabled via command line;
- Be verbose about Meson wraps fallbacks;
- Move pkgconf build files from `pkgconf\build` to `pkgconf\pkgconf` to have them ignored by git;
- Abort Mesa3D build when out of tree patching is simultaneously required and disabled.
### Debug
- LLVM: Add install modifier tool.
### Out of tree patching
- Add MSVC swr build fix - [!5166](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/5166).
# 20.1.1
- Updated Mesa3D to [20.1.1](https://www.mesa3d.org/relnotes/20.1.1.html).
### Known issue
- swr driver is missing from this release due to build failure.
### Build script
- Simplify zlib dependency wrap and avoid hardcoding its library name;
- LLVM: Automatically wrap runtime dependency whenever possible - required by [#28](https://github.com/pal1000/mesa-dist-win/issues/28) and [#34](https://github.com/pal1000/mesa-dist-win/issues/34);
- MSVC: Disable LLVM build reduction used with Ninja due incompatibility with Meson runtime dependency wrap.
### Early development
- Add MSVC ARM and ARM64 Meson cross files - [#35](https://github.com/pal1000/mesa-dist-win/issues/35).
# 20.1.0
- Updated Mesa3D to [20.1.0](https://www.mesa3d.org/relnotes/20.1.0.html).
### Build script
- Select ABI after toolchain which opens possibility to filter supported ABIs per toolchain - required for [#35](https://github.com/pal1000/mesa-dist-win/issues/35).
### Patches
- Update dual osmesa patch to keep working after gallium state trackers rename to frontends;
- Remove filenames parity patch as it's from before 19.3.0 stable.
### Debug and work-in-progress development
- Draft ARM and ARM64 builds using [standalone MinGW-W64 clang toolchain](https://github.com/mstorsjo/llvm-mingw/releases), that unfortunately fail to link for now - [#35](https://github.com/pal1000/mesa-dist-win/issues/35).
# 20.0.7
- Updated Mesa3D to [20.0.7](https://www.mesa3d.org/relnotes/20.0.7.html).
### Debug
- Add a minimal standalone MinGW-W64 build with TDM-GCC;
- MSYS2: Prompt for updates check instead of always doing it.
### Build script
- Misc: Fix setting and testing against errorlevels;
- Misc: Load Git for Windows in MSYS2 when available to get commit hash when building with MSYS2 MinGW-w64;
- Ensure git for windows is used over MSYS2 git, when available;
- Support MSYS2 MinGW-W64 clang compiler;
- LLVM: Remove some unnecessary build targets from configuration.
### Patches
- Update native mingw buildfix patch for 20.1 and above to its merged form.
### Build enviroment information document
- Remove build commands section due to bit rot.
# 20.0.6
- Updated Mesa3D to [20.0.6](https://www.mesa3d.org/relnotes/20.0.6.html).
### Distribution creation
- Take into account that osmesa swrast is missing from MSYS2 MinGW-w64 release package.
### Build configure
- zlib: Unify MSVC and MSYS2 wrap generators in a single module;
- Meson: Avoid reconfiguration by ensuring wrap files don't get dirty if unchanged.
### Patches
- Fix regression with native mingw builds affecting 20.1 and master branches.
# 20.0.5
- Updated Mesa3D to [20.0.5](https://www.mesa3d.org/relnotes/20.0.5.html).
### Build script
- MSYS2: Use Meson builtin options to pass compiler and linker flags;
- Remove Scons build support;
- Refactor: cleanup variables defined for Scons build;
- Refactor: use a consistent path format in MSYS2;
- MSYS2: Add a hardcoded libraries list to use when llvm-config is busted;
- MSYS2: Use pacman to find LLVM version in Meson wrap generator;
- Don't fail to apply Mesa3D patches via MSYS2 GNU patch if available when building with MSVC and git is missing;
- Support custom wrapping MSYS2 mingw-w64-zlib static library;
- Always explicitly request static libraries in custom wrap generators;
- Provide support for disabling out of tree patches to ease upstreaming.
### .gitignore
- Prepare for binary distribution using Meson install layout.
# 20.0.4
- Updated Mesa3D to [20.0.4](https://www.mesa3d.org/relnotes/20.0.4.html).
### Mesa3D Meson build
- Support building both x86 and x64 simultaneously.
# 20.0.3
- Updated Mesa3D to [20.0.3](https://www.mesa3d.org/relnotes/20.0.3.html).
### Distribution creation
WIP: Disabled: Use Meson install in MSYS2;
WIP: Disabled: Replicate layout of MSVC Meson install.
### Meson wrap
- Do not clear unpacked zlib source code as Meson builds suprojects under main project now.
# 20.0.2
- Updated Mesa3D to [20.0.2](https://www.mesa3d.org/relnotes/20.0.2.html);
- Switched MSYS2 MinGW-w64 build to Meson.
### End-user docs
- Update to reflect changes triggered by MSYS2 MinGW-w64 build switch to Meson.
### Patching
- Prefer MSYS2 GNU patch for applying patches when available as it supports both CRLF and LF simultaneously.
### MSYS2 build dependencies
- Eliminate redundancy in pacman -S command;
- Use current name for Python 3 mako group.
### MSYS2 MinGW-w64 build
- Get static linking with Meson working, avoiding [this problem](https://gitlab.freedesktop.org/mesa/mesa/issues/2012).
### Per application deployment
- Only ask for osmesa type if both swrast and gallium are available in release package.
### Work in progress (disabled)
- Use Meson install for collecting binaries, libraries and headers.
# 20.0.1
- Updated Mesa3D to [20.0.1](https://www.mesa3d.org/relnotes/20.0.1.html).
# 20.0.0
- Updated Mesa3D to [20.0.0](https://www.mesa3d.org/relnotes/20.0.0.html).
### Build script
- Support Scons with Python 3 in MSYS2;
- Don't apply Meson related patches when using Scons;
- Get ready for MSVC build with Scons and Python 3.
# 19.3.4
- Updated Mesa3D to [19.3.4](https://www.mesa3d.org/relnotes/19.3.4.html).
### Build script
- Explicitly request static libraries from LLVM;
- Refactor code to easily share it with related projects;
- Fix 32-bit LLVM build with MsBuild.
# 20.0.0rc1
### Out of tree patches
- Update swr AVX512 build fix patch to work with 20.0 and keep old version for 19.3.
# 19.3.3
- Updated Mesa3D to [19.3.3](https://www.mesa3d.org/relnotes/19.3.3.html).
### Deployment
- Use Powershell to request admin rights for better compatibility.
### Build script
- Meson: Fix zlib wrap update.
# 19.3.2
- Updated Mesa3D to [19.3.2](https://www.mesa3d.org/relnotes/19.3.2.html).
### Build script
- Mesa: Avoid harmless error when build is already clean;
- Ensure print of new line after git clone commands for Mesa3D and pkgconf codebases;
- Disable osmesa classic when building with Meson and Mingw due to build failure;
- Mesa build with Meson: Prepare for possibility of building multiple gallium drivers.
### Debug scripts
- MSYS2: Update packages before openning interactive shell;
- MSYS2: Switch to a prompt for command loop system.
# 19.3.1
- Updated Mesa3D to [19.3.1](https://www.mesa3d.org/relnotes/19.3.1.html).
# 19.3.0-2
### Deployment
- Avoid missing `libglapi.dll` related errors since 19.3.0 when switching from Mingw to MSVC release package with programs that use any Mesa3D desktop OpenGL driver via per app deployment tool.
### Known issue
- You may encounter errors related to missing `libglapi.dll` if you used per app deployment. See [readme](#important-notes-about-errors-related-to-missing-libglapidll) for resolution.
# 19.3.0
- Updated Mesa3D to [19.3.0](https://www.mesa3d.org/relnotes/19.3.0.html).
### New features and changes
- switched MSVC packages to Meson build - [#7](https://github.com/pal1000/mesa-dist-win/issues/7);
- enabled experimental swr AVX512 support thanks to switch to Meson build and an out of tree patch with progress on official support being tracked [here](https://gitlab.freedesktop.org/mesa/mesa/issues/1990) - [#2](https://github.com/pal1000/mesa-dist-win/issues/2);
- restored standalone OpenGL ES drivers in MSVC release package thanks to switch to Meson build;
- added Mesa3D test suite to MSVC release package thanks to switch to Meson build.
### Documentation
- Update end-user guide to reflect new features and changes.
### Important notes about updating from older versions
- You may experience errors related to missing `libglapi.dll` when updating from a release that isn't between 18.1.2.600-1 and 18.2.6 with programs that had any Mesa3D desktop OpenGL driver deployed with per app deployment tool. To correct them you have to re-deploy. If you don't remember if an affected program is 32-bit or 64-bit, right click on opengl32.dll shortcut in the folder where the program executable is located and select open file location. If location ends in x64 then it's 64-bit otherwise it's 32-bit.
# 19.2.7
- Updated Mesa3D to [19.2.7](https://www.mesa3d.org/relnotes/19.2.7.html).
# 19.2.6
- Updated Mesa3D to [19.2.6](https://www.mesa3d.org/relnotes/19.2.6.html).
# 19.2.5
- Updated Mesa3D to [19.2.5](https://www.mesa3d.org/relnotes/19.2.5.html).
### Build script
- pywin32 : Detect when installer was used and require it for updates;
- MSYS2: Use braces when expanding shell script variables;
- LLVM Meson wrap file generator: Detect RTTI support instead of making any assumptions;
- MSYS2: Install tar package to support PKGBUILD.
### Deployment tools
- Improve elevation routine based on pal1000/Realtek-UAD-Generic#18.
# 19.2.4
- Updated Mesa3D to [19.2.4](https://www.mesa3d.org/relnotes/19.2.4.html).
### Build script
- Don't apply filename parity patch to Mesa3D < 19.3.
# 19.2.3-2
### Build script
- Meson build: Pause after clean build warning in order to give chance to cancel build.
# 19.2.3
- Updated Mesa3D to [19.2.3](https://www.mesa3d.org/relnotes/19.2.3.html).
### Build script
- MSYS2: Keep pacman cache size under control;
- Meson build: Get MSYS2 Mingw-w64 working;
- Meson build: Hide it when it can't be used;
- More verbose errors about when build is impossible;
- Meson build: Ensure LLVM is disabled when asked;
- Meson build: Use 64-bit compiler when using Ninja when possible;
- Meson: Always clean build;
- Add build system to Window title.
### Deployment tools
- Per app deployment: Fix osmesa gallium solo deployment;
- Add support for swr AVX512 to deployment tools.
### Patches
- Add a patch that ensures filenames parity with Scons - https://gitlab.freedesktop.org/mesa/mesa/merge_requests/2496 ;
- Allow building osmesa gallium and swrast simultaneously with Meson.
### Build environment information
- Add pkg-config.
### Version information
- Add version information to swr AVX512 drivers.
# 19.2.2
- Updated Mesa3D to [19.2.2](https://www.mesa3d.org/relnotes/19.2.2.html).
### Build script
- Meson build: Fix pkg-config-lite detection;
- Meson build: Release from manual startup mode;
- Meson build: Update subprojects;
- Remove UWP Python from PATH when using MSVC as soon as Python discovery routine begins as it may cause issues with Meson build;
- Meson build: Pause between configure and build phase similarly to LLVM;
- Meson build: Add support for pkgconf as pkg-config-lite alternative;
- Split other dependencies to share git version control detection across the board;
- Meson build: Enable llvmpipe and swr drivers;
- Meson build: Hooked untested MSYS2 Mingw-w64 support;
- Implemented aggressive build environment cleanup.
### Version information
- Refactored code and added osmesa gallium solo and graw null support.
### Distribution
- Add libraries and headers for Meson build;
- Don't create osmesa-gallium and osmesa-swrast folders when building with Meson as [it may only support osmesa gallium long term](https://gitlab.freedesktop.org/mesa/mesa/merge_requests/1243).
### Deployment
- Per app deployment: Add osmesa gallium solo and graw null support;
- System wide deployment: Add osmesa gallium solo and graw null support.
### Patch
- Meson build: Remove expat subproject update as it is no longer used on windows since mesa3d/mesa@4441da00;
- Drop Scons Python 3 compatibility patch as it's ineffective on Windows;
- Drop LLVM 9 compatibility, posix flag fix and MSYS2 Mingw-w64 compatibility patches because they are present in all stable branches (19.1.8, 19.2.1 and master);
- Meson build: Add [tentative fix for swr AVX512](https://gitlab.freedesktop.org/mesa/mesa/issues/1990).
### Distribution creation
- Add Mesa3D test suite to release package when building with Meson.
### EXE Setup maker
- Remove this feature. It bitrotted and maintaining it is even harder with Meson build.
# 19.2.1
- Updated Mesa3D to [19.2.1](https://www.mesa3d.org/relnotes/19.2.1.html).
### Patches
- Simplified MSYS2 compatibility patch;
- MSYS2 patch: Do not create .orig backups.
### Build script
- Restricted LLVM 9, MSYS2 and Python 3 compatibility patches to Mesa 19.2.0/19.1.7 and below as they landed upstream;
- Mesa3D build: Mention patch that is applied;
- LLVM build: Include coroutines component in order to enable compute shaders in Mesa3D llvmpipe driver on Mesa 19.3;
- Mesa3D: Prepared for Scons build with Python 3;
- Do not require CMake if LLVM is prebuilt as this causes the display of a misleading warning;
- Mesa3D: Automatically build without LLVM if LLVM is missing. The appropriate warning is displayed close enough so this may look like warning spam to certain users;
- LLVM: Build LLVMAggressiveInstCombine library as it is needed by coroutines component introduced to enable compute shaders. This also needs this [upstream cntribution](https://gitlab.freedesktop.org/mesa/mesa/merge_requests/2215) in order to be effective.
# 19.2.0
- Updated Mesa3D to [19.2.0](https://www.mesa3d.org/relnotes/19.2.0.html).
### Patches
- Backport [this commit](https://gitlab.freedesktop.org/mesa/mesa/commit/88eb2a1f7e6277c7f10adfc95ebeaf3d2f73e862) to Mesa 19.1 in order for LLVM 9 compatibility fix to apply cleanly.
# 19.1.7
- Updated Mesa3D to [19.1.7](https://www.mesa3d.org/relnotes/19.1.7.html).
### Build script
- LLVM build: Clean up component names used to call llvm-config with. Tests done with llvm-config indicate that only engine and irreader component names are needed to get the list of all necessary libraries for Mesa3D build, everything else being superfluous. This cleanup also made build script ready for LLVM 9;
- LLVM build: Exclude LLVMAggressiveInstCombine from build as it's not used by Mesa3D;
- Also add Python Scripts folder to PATH in addition to Pyhon root folder just to be safe and to match what Mesa3D official AppVeyor CI does.
### Debug
- LLVM needed libraries dumper can now work with or without those libraries being present. If some libraries are present only missing libraries names are dumped.
### Upstream contribution
- A patch to support Mesa3D build with LLVM 9 was added and sent [upstream for review and integration](https://gitlab.freedesktop.org/mesa/mesa/merge_requests/1894).
# 19.1.6
- Updated Mesa3D to [19.1.6](https://www.mesa3d.org/relnotes/19.1.6.html).
# 19.1.5
- Updated Mesa3D to [19.1.5](https://www.mesa3d.org/relnotes/19.1.5.html).
### Deployment
- System wide deployment : Get Mesa3D install status in main menu routine. Hide update and uninstall options when Mesa3D is not installed.
# 19.1.4
- Updated Mesa3D to [19.1.4](https://www.mesa3d.org/relnotes/19.1.4.html).
### Deployment
- Declare update operation in system wide deployment as failed when no Mesa3D driver is installed (bug reported in #26);
- Made deployment tools aware that Mingw build doesn't include swr driver (bug reported in #26).
# 19.1.3
- Updated Mesa3D to [19.1.3](https://www.mesa3d.org/relnotes/19.1.3.html).
# 19.1.2
- Updated Mesa3D to [19.1.2](https://www.mesa3d.org/relnotes/19.1.2.html).
# 19.1.1
- Updated Mesa3D to [19.1.1](https://www.mesa3d.org/relnotes/19.1.1.html).
### Build script
- Meson build: don't overwrite backend string, it is too risky;
- Meson build: fix gles and shared glapi configuration;
- Meson build: mention that buildcmd variable stores the build execution command;
- Meson build with Ninja: VS Cross Tools is not supported so use 32-bit compiler instead;
- Meson build: Disable lookup for Mingw pkg-config as it doesn't work anymore and also fix lookup for pkg-config-lite;
- Python 2.x: wheel is no longer necessary to install scons if pip and setuptools are up-to-date;
- Set MSVC CRT even if LLVM build dependencies are missing avoiding a glitch with build environment information dumper when LLVM is missing;
- Add version information to shared glapi and standalone OpenGL ES drivers.
# 19.1.0
- Updated Mesa3D to [19.1.0](https://www.mesa3d.org/relnotes/19.1.0.html).
### Build script
- MSYS2 refactor: Remove runmsys module as it is too small to be necessary;
- Python doscovery refactor: Use exitloop variable to break from for loops;
- Display Visual Studio edition in toolchain selection menu and build environment information file;
- Improve performance of toolchain selection menu by deduplicating calls to vswhere tool;
- Clean-up toolchain selection validation;
- Hide Powershell errors when aborting pywin32 COM and services component update by canceling at UAC prompt.
### Source control
- Stop treating .rc files as text as they are no longer tracked by git.
# 19.0.6
- Updated Mesa3D to [19.0.6](https://www.mesa3d.org/relnotes/19.0.6.html).
### Build script
- Implement automatic version information attaching to binaries using Resource Hacker - fixes #19;
- Clean PATH after Mesa3D build in the same fashion it is done for LLVM;
- Guard toolchain selection and python launcher menus from bad user input;
- MSYS2: Workaround msys2/MSYS2-packages#1658 and future equivalents;
- MSYS2 Debug: Imlement pacman cache eraser support;
- MSYS2 initial setup: Do not ask about updates when done as it is highly unlikely to be out-of-date;
- Run "pacman -Syu" 2 times when updating MSYS2, once for core packages and twice for the rest to ensure everything is updated;
- Implement automatic build environment information dumper.
### MSVC build environment updates
- mako 1.0.9 -> 1.0.12;
- Visual Studio 16.1.0 -> 16.1.2;
- cmake 3.14.4 -> 3.14.5
### MSYS2 MINGW build environment status
- MSYS2 MINGW build environment status is available [here](https://raw.githubusercontent.com/pal1000/mesa-dist-win/19.0.6/buildinfo/mingw.txt).
### Patches
- Remove scons development version string compatibility patch as it has been upstreamed months ago;
- Update MSYS2 Mingw-w64 compatibility patch.
# 19.0.5
- Updated Mesa3D to [19.0.5](https://www.mesa3d.org/relnotes/19.0.5.html).
### Version control
- Allow diffing resource script files;
- Make .gitignore easier to read and add Visual Studio compiled resource scripts (*.aps) to it.
### End-user guide
- Add citra emulator OpenGL context override and SiN 1998 extensions list trimming examples;
- Add a missing TOC entry.
### Build script
- Re-implement LLVM efficient build without requiring temporary file.
### MSVC build environment updates
- Visual Studio 16.0.3 -> 16.1.0;
- cmake 3.14.3 -> 3.14.4;
- wheel 0.33.3 -> 0.33.4.
# 19.0.4
- Updated Mesa3D to [19.0.4](https://www.mesa3d.org/relnotes/19.0.4.html).
### Changes
- Version information has been added to binaries via Resource Hacker instead of Visual Studio.
### Build script
- Display toolchain name and CPU cap in Command Prompt window title;
- Redesigned Python launcher interface to filter old Python versions, improve script performance, code readability and ease support of future versions of Python;
- Improve Python version checking by treating version as a fractional number and by also using sys.version_info python function.
### Other
- Add resource script file for each binary (#19).
### MSVC build environment updates
- Visual Studio 16.0.2 -> 16.0.3;
- pip 19.1 -> 19.1.1;
- winflexbison 2.5.18-devel -> 2.5.18;
- wheel 0.33.1 -> 0.33.3.
# 19.0.3
- Updated Mesa3D to [19.0.3](https://www.mesa3d.org/relnotes/19.0.3.html).
### Build script
- Fixed a critical bug causing build script to abort execution when MSYS2 is missing;
- Compatibility update for Windows 10 Version 1903: Remove Python UWP installer from PATH - [#23](https://github.com/pal1000/mesa-dist-win/issues/23);
- Make sure initial MSYS2 required double update only occurs once by looking for a specific MSYS package needed by Mesa3D build that is not included in a fresh install of MSYS2;
- Avoid a harmless error when Visual Studio is not installed.
### MSVC build environment updates
- Host OS 10.0.17763 -> 10.0.18362;
- Visual Studio 16.0.1 -> 16.0.2;
- Windows SDK 10.0.17763.132 -> 10.0.18362.1;
- cmake 3.14.1 -> 3.14.3;
- setuptools 41.0.0 -> 41.0.1;
- pip 19.0.3 -> 19.1;
- mako 1.0.8 -> 1.0.9.
# 19.0.2
- Updated Mesa3D to [19.0.2](https://www.mesa3d.org/relnotes/19.0.2.html).
### Debug
- Add a MSYS2 console for debug purposes;
- llvm-config debug tool: Support returning libraries list in both python list and ninja targets format.
### Build script
- Build LLVM efficiently when using Ninja by only building llvm-config tool, required libraries and headers;
- Detect Visual Studio installations using vswhere;
- Support handling missing Desktop development with C++ workload through Visual Studio installer.
### MSVC build environment updates
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
### MSVC build environment updates
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
### MSVC build environment updates
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
### MSVC build environment updates
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
### MSVC build environment updates
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
### MSVC build environment updates
- cmake 3.13.1 -> 3.13.3;
- Visual Studio 15.9.3 -> 15.9.5;
- setuptools 40.6.2 -> 40.6.3;
- Git 2.20.0.1 -> 2.20.1.1;
- LLVM 7.0.0 -> 7.0.1.
# 18.3.0
- Updated Mesa3D to [18.3.0](https://www.mesa3d.org/relnotes/18.3.0.html).
### Removed features
- shared glapi and standalone GLES drivers support in Scons build has been removed upstream in [this commit](https://gitlab.freedesktop.org/mesa/mesa/commit/45bacc4b63d83447c144d14cb075eaf7a458c429). @jrfonseca chose to cut down this build configuration altogether instead of fixing osmesa build.
### MSVC build environment updates
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
### MSVC build environment updates
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
### MSVC build environment updates
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
### MSVC build environment updates
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
### MSVC build environment updates
- git 2.19.0.1 -> 2.19.1.1;
- Visual Studio 15.8.6 -> 15.8.7.
# 18.2.2
- Updated Mesa3D to [18.2.2](https://www.mesa3d.org/relnotes/18.2.2.html);
- swr driver is back.
### Known issue
- osmesa support is limited. OpenGL ES and swr driver integration have to be stripped due to build failure.
### MSVC build environment updates
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
### MSVC build environment updates
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
### Documentation
- Add a notice for enterprise environments documenting a scenario where running 3rd-party unsigned executables is prohibited, See [#11](https://github.com/pal1000/mesa-dist-win/issues/11).
### MSVC build environment updates
- Visual Studio 15.8.1 -> 15.8.3;
- Add 7-zip to build environment configuration info as it is used to package releases.
# 18.1.7
- Updated Mesa3D to [18.1.7](https://www.mesa3d.org/relnotes/18.1.7.html).
### Build script
- Mesa3D build finally works with parallel dual Python. Python 2.7.x exclusive for Scons and Python 3.5.x+ exclusive for Meson.
### MSVC build environment updates
- Visual Studio 15.7.6 -> 15.8.1;
- setuptools 40.0.0 -> 40.2.0.
# 18.1.6
- Updated Mesa3D to [18.1.6](https://www.mesa3d.org/relnotes/18.1.6.html).
### Build script
- Do not pass texture float build option to Mesa 18.2 and up;
- Mesa3D Meson build: Implement Msbuild support.
### MSVC build environment updates
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
### MSVC build environment updates
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
### MSVC build environment updates
- setuptools 39.2.0 -> 40.0.0;
- Visual Studio 15.7.4 -> 15.7.5.
# 18.1.3.601-1
- Updated Mesa3D to [18.1.3](https://www.mesa3d.org/relnotes/18.1.3.html).
### New features
- Enabled texture float and renderbuffers as patent expired on 6/17/2018.
### Build script
- Improve osmesa dual pass build workaround hack to minimize regression. osmesa classic should have integration with other drivers fully restored. Also there is no need to backup and restore softpipe and llvmpipe anymore.
### MSVC build environment updates
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
### MSVC build environment updates
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
### MSVC build environment updates
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
### MSVC build environment updates
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
### MSVC build environment updates
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
### MSVC build environment updates
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
### MSVC build environment updates
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
### MSVC build environment updates
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
