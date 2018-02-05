### Build environment updates
- pywin32 221 -> 222.
- Visual Studio 15.5.4 -> 15.5.6.
- setuptools 38.4.0 -> 38.4.1.
- Git 2.16.1.1 -> 2.16.1.2.
### Build script
- Experimental: Get pywin32 via pypi.
- Drop support for libxtc_dxtn standalone library. Mesa3D 17.2 reached end-of-life on 23rd December 2017.
### Build script documentaion
- pywin32 moved to Github.
- Drop support for libxtc_dxtn standalone library and other few miscellaneous changes.
### Inno Setup
- Drop S3TC standalone library support.
- Drop swr 32-bit support. Unsupported upstream.
### Debugging
- Add latest llvm-config output, valid for LLVM 5.0.x and 6.0 RC1. Allows for finding new LLVM libraries a lot easier using an online diff service like text-compare.com.