Use quick deploy utility to avoid manual copy-pastes of Mesa drivers. It allows saving
storage space and update all copies of Mesa drivers from a single location using NTFS
symlinks. Applications requiring OpenGL 3.1 or newer may need Manual OpenGL context
configuration. Some applications are smart enough to not load opengl32.dll from their
folder. Federico Dossena wrote Mesainjector to workaround this.
Complete usage guide is available here:
https://github.com/pal1000/mesa-dist-win/blob/master/readme.md