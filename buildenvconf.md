# Hardware

System | [Dell Vostro 2521-9566 Q1 2013](http://www.dell.com/support/home/en/us/robsdt1/product-support/product/vostro-2521)
CPU | [Intel Core I3-2375M](https://ark.intel.com/products/74259/Intel-Core-i3-2375M-Processor-3M-Cache-1_50-GHz)
RAM | 4GB DDR3 1600 MHz dual channel
dGPU | None
OS | Windows 10 Version 1709 Pro x64

# Visual Studio

Edition | 2017 Community
Version | 15.5.2
Windows 10 SDK Version | 10.0.16299.91
Windows 10 SDK install method | standalone
Windows 8.1 SDK installed | Yes
Windows XP support for C++ installed | Yes

# LLVM

LLVM Version | 5.0.1
CMake version | 3.10.1
CMake ARCH | x64
LLVM build configure x64* | cd llvm-5.0.1-src & md cmake-x64 & cd cmake-x64 & cmake -G "Ninja" -DLLVM_TARGETS_TO_BUILD=X86 -DCMAKE_BUILD_TYPE=Release -DLLVM_USE_CRT_RELEASE=MT -DLLVM_ENABLE_RTTI=1 -DLLVM_ENABLE_TERMINFO=OFF -DCMAKE_INSTALL_PREFIX=../x64 ..
LLVM build configure x86** | cd llvm-5.0.1-src & md cmake-x86 & cd cmake-x86 & cmake -G "Ninja" -DLLVM_TARGETS_TO_BUILD=X86 -DCMAKE_BUILD_TYPE=Release -DLLVM_USE_CRT_RELEASE=MT -DLLVM_ENABLE_RTTI=1 -DLLVM_ENABLE_TERMINFO=OFF -DCMAKE_INSTALL_PREFIX=../x86 ..
LLVM build execute*** | ninja install

* Executed from an x64 Native Tools Command Prompt for VS 2017 shell
** Executed from an x64_x86 Cross Tools Command Prompt for VS 2017 shell
*** Executed after each build configuration on same command shell

# Python

Version | 2.7.14
ARCH | x64
pip version | 9.0.1
setuptools version | 38.2.4
pywin32 / pypiwin32 version | 221
scons version | 3.0.1
Mako version | 1.0.7
MarkupSafe | 1.0

# winflexbison

Package version | 2.5.13
Bison version | 3.0.4
Flex version | 2.6.4

# Mesa3D

Build config and execute x64 | scons build=release platform=windows machine=x86_64 libgl-gdi swr=1 osmesa graw-gdi
Build config and execute x86 | scons build=release platform=windows machine=x86 libgl-gdi osmesa graw-gdi

