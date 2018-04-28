### Notes

[1]Executed from an x64 Native Tools Command Prompt for VS 2017 shell

[2]Executed from an x64_x86 Cross Tools Command Prompt for VS 2017 shell

[3]Executed after each build configuration on same command shell

[4]Executed from a standard Command Prompt.
### Hardware
| | |
|-|-|
System | [Dell Vostro 2521-9566 Q1 2013](http://www.dell.com/support/home/en/us/robsdt1/product-support/product/vostro-2521)
CPU | [Intel Core I3-2375M](https://ark.intel.com/products/74259/Intel-Core-i3-2375M-Processor-3M-Cache-1_50-GHz)
RAM | 4GB DDR3 1600 MHz dual channel
dGPU | None
OS | Windows 10 Version 1709 Pro x64
### Visual Studio
| | |
|-|-|
Edition | 2017 Community
Version | 15.6.7
Windows 10 SDK Version | 10.0.16299.91
Windows 10 SDK install method | standalone
### LLVM
| | |
|-|-|
LLVM Version | 6.0.0
CMake version | 3.11.1
CMake ARCH | x64
Ninja version | 1.8.2
LLVM build configure x64[1] | cd llvm-6.0.0.src & md buildsys-x64 & cd buildsys-x64 & cmake -G "Ninja" -Thost=x64 -DLLVM_TARGETS_TO_BUILD=X86 -DCMAKE_BUILD_TYPE=Release -DLLVM_USE_CRT_RELEASE=MT -DLLVM_ENABLE_RTTI=1 -DLLVM_ENABLE_TERMINFO=OFF -DCMAKE_INSTALL_PREFIX=../x64 ..
LLVM build configure x86[2] | cd llvm-6.0.0.src & md buildsys-x86 & cd buildsys-x86 & cmake -G "Ninja" -Thost=x64 -DLLVM_TARGETS_TO_BUILD=X86 -DCMAKE_BUILD_TYPE=Release -DLLVM_USE_CRT_RELEASE=MT -DLLVM_ENABLE_RTTI=1 -DLLVM_ENABLE_TERMINFO=OFF -DCMAKE_INSTALL_PREFIX=../x86 ..
LLVM build execute[3] | ninja install
### Python
| | |
|-|-|
Version | 2.7.14
ARCH | x64
pip version | 10.0.1
setuptools version | 39.1.0
pywin32 / pypiwin32 version | 223
scons version | 3.0.1
Mako version | 1.0.7
MarkupSafe version | 1.0
### winflexbison
| | |
|-|-|
Package version | 2.5.14
Bison version | 3.0.4
Flex version | 2.6.4
### Git version control
| | |
|-|-|
Git For Windows portable | 2.17.0.1
### Mesa3D
| | |
|-|-|
Build config and execute x64 [4] | scons build=release platform=windows machine=x86_64 libgl-gdi swr=1 graw-gdi osmesa
Build config and execute x86 [4] | scons build=release platform=windows machine=x86 libgl-gdi graw-gdi osmesa