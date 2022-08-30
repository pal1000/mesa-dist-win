# Debug MinGW binaries
# --------------------
# - Install MSYS2: https://www.msys2.org/#installation
# - Open a MSYS2 MINGW64 shell from Start menu even if you are debugging a 32-bit program
# - Update MSYS2: https://www.msys2.org/docs/updating/ 
# - Open a MSYS2 MINGW64 shell again if MSYS2 needed to restart itself
# Install GNU Debugger
pacman -S ${MINGW_PACKAGE_PREFIX}-gdb --needed --noconfirm
# - Adjust command bellow changing working directory, the crashing target executable and debug symbol file path
# - Cut `-ex 'symbol-file <full-symbol-file-path' ` if you don't know the faulting module name
# GDB uncovers it after crash anyway but it can also be uncovered without GDB after a crash from
# Control Panel - Security and maintenance - Reliability history or in %ALLUSERSPROFILE%\Microsoft\Windows\WER\ReportArchive # under the newest created folder whose name begins with AppCrash in Report.wer file from there
# - Run this shell script in MSYS2 by copy-pasting full path to it there
# - Once the faulting module is known add back the symbol file to GDB command bellow then re-run this shell script
# The symbol file name has to match faulting module name with extra .sym extension
cd "c:\Software\systools\GPU/GPU_Caps_Viewer";gdb -ex 'symbol-file c:/Software/Development/projects/mesa-dist-win/debugsymbols/x86/clon12compiler.dll.sym' -ex 'target exec GPU_Caps_Viewer.exe' -ex 'run'
# - Once program crashes collect backtrace by entering `bt` at GDB shell then type `continue`
# - Repeat last step until the crashing program is closed
# You can do more complex debugging if you are an advanced GDB user
# Copy-paste all backtraces in an issue report at Mesa3D: https://gitlab.freedesktop.org/mesa/mesa/-/issues
# To quit GDB enter `q`