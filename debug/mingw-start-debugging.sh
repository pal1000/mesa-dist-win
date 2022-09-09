# Debug MinGW binaries
# --------------------
# - Install MSYS2: https://www.msys2.org/#installation;
# - Open a MSYS2 MINGW64 shell from Start menu even if you are debugging a 32-bit program;
# - Update MSYS2: https://www.msys2.org/docs/updating/;
# - Open a MSYS2 MINGW64 shell again if MSYS2 needed to restart itself;
# - Install GNU Debugger (to do so automatically when running this script uncomment next line);
# pacman -S ${MINGW_PACKAGE_PREFIX}-gdb --needed --noconfirm
# - Extract debug MinGW binaries replacing release copies;
# - Adjust command bellow changing working directory and the crashing target executable;
cd "c:\Software\systools\GPU/GPU_Caps_Viewer";gdb -ex 'target exec GPU_Caps_Viewer.exe' -ex 'run'
# - Run this script;
# - Once program crashes collect backtrace by entering `bt` at GDB shell then type `continue`;
# - Repeat last step until the crashing program is closed;
# You can do more complex debugging if you are an advanced GDB user.
# - Copy-paste all different backtraces in an issue report at Mesa3D: https://gitlab.freedesktop.org/mesa/mesa/-/issues.
# To quit GDB enter `q`.