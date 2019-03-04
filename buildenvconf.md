### Notes

[1]Executed from a x64 Native Tools Command Prompt for VS 2017 shell

[2]Executed from a x64_x86 Cross Tools Command Prompt for VS 2017 shell

[3]Executed after each build configuration on same command shell

[4]Executed from a standard Command Prompt.
### Hardware
| | |
|-|-|
System | [Dell Vostro 2521-9566 Q1 2013](http://www.dell.com/support/home/en/us/robsdt1/product-support/product/vostro-2521)
CPU | [Intel Core I3-2375M](https://ark.intel.com/products/74259/Intel-Core-i3-2375M-Processor-3M-Cache-1_50-GHz)
RAM | 4GB DDR3 1600 MHz
dGPU | None
OS | Windows 10 October 2018 Update Pro x64
### Visual Studio
| | |
|-|-|
Edition | 2017 Community
Version | 15.9.7
Windows 10 SDK Version | 10.0.17763.132
Windows 10 SDK install method | standalone
### LLVM
| | |
|-|-|
LLVM Version | 7.0.1
CMake version | 3.13.4
CMake ARCH | x64
Ninja version | 1.9.0
LLVM build configure x64[1] | cd llvm-7.0.1.src & md buildsys-x64-MT & cd buildsys-x64-MT & cmake -G "Ninja" -DLLVM_TARGETS_TO_BUILD=X86 -DCMAKE_BUILD_TYPE=Release -DLLVM_USE_CRT_RELEASE=MT -DLLVM_ENABLE_RTTI=1 -DLLVM_ENABLE_TERMINFO=OFF -DCMAKE_INSTALL_PREFIX=../x64-MT ..
LLVM build configure x86[2] | cd llvm-7.0.1.src & md buildsys-x86-MT & cd buildsys-x86-MT & cmake -G "Ninja" -DLLVM_TARGETS_TO_BUILD=X86 -DCMAKE_BUILD_TYPE=Release -DLLVM_USE_CRT_RELEASE=MT -DLLVM_ENABLE_RTTI=1 -DLLVM_ENABLE_TERMINFO=OFF -DCMAKE_INSTALL_PREFIX=../x86-MT ..
LLVM build execute[3] | ninja install
### Python
| | |
|-|-|
Version | 2.7.16
ARCH | x64
pip version | 19.0.3
setuptools version | 40.8.0
pywin32 / pypiwin32 version | 224
scons version | 3.0.1
Mako version | 1.0.7
MarkupSafe version | 1.1.1
wheel version | 0.33.1
### winflexbison
| | |
|-|-|
Package version | 2.5.17
GNU Bison version | 3.3.1
Flex version | 2.6.4
### Git version control
| | |
|-|-|
Git For Windows portable | 2.21.0.1
### Mesa3D
| | |
|-|-|
Enable S3TC texture cache [4] | git apply -v ..\mesa-dist-win\patches\s3tc.patch
Build config and execute x64 [4] | scons build=release platform=windows machine=x86_64 openmp=1 swr=1 .
Build config and execute x86 [4] | scons build=release platform=windows machine=x86 openmp=1 .
### Release packaging
| | |
|-|-|
7-zip version | 19.00
Compression level | ultra