Here are some examples on how to manually configure GL context. This is required for most
applications using OpenGL 3.1 and higher on Windows as GL_ARB_compatibility implemented
by all proprietary drivers is missing on Mesa. Probably as a side-effect shading language
and OpenGL version don't sync by default for most OpenGL versions except 3.3 and default
3.0.

Examples:
1. Getting Desmume emulator OpenGL 3.2 renderer to work.
   Require OpenGL 3.2. Trial and error shows it works best with Core profile.
   Solutions:
   a. Override GL version to 3.2 and shading language to 1.50
   OpenGL and shading language should always sync.
   Solution highlighted in desmume.cmd.
   b. Slightly easier. Override GL version to 3.3. Get shading language sync for free.
   Going above requirements is most of times pretty safe.
   Solution highlighted in desmume2.cmd.

2. GPU Caps Viewer
Tessellation is not supported by Mesa software renderers so only GL 3.x, GL 2.1 and GL 1.2
benchmarks can run. Most demos expect GL 3.2. In conclusion we need an OpenGL 3.2 or 3.3
compatibility context to simultaneously support GL 1.2, GL 2.1 and GL 3.x benchmarks. 
Again GL 3.3 compatibility context is easier as shown in GPUCapsViewer.cmd.

3. rpcs3 - Playstation 3 emulator.
System requirements: OpenGL 4.3 with GLSL 4.30 as specified here:
https://rpcs3.net/quickstart
Example highlighted in rpcs3.cmd  
  
