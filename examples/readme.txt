Here are some examples on how to override OpenGL contexts and one that shows how to use swr instead of
llvmpipe. This is required for most applications on Windows using OpenGL 3.2 and higher on Mesa 18.1
and 3.1 or higher on Mesa 18.0 as Mesa3D compatibility contexts support is limited.
Probably as a side-effect shading language and OpenGL version don't sync by default
for most OpenGL versions above 3.0 except 3.3 and 3.1 for Mesa 18.1 and 3.0 for Mesa 18.0

Examples:
1. Getting Desmume emulator OpenGL 3.2 rendering to work.
   Requires OpenGL 3.2. Trial and error shows it works best with Core profile.
   Solutions:
   a. Override OpenGL version to 3.2 and shading language to 1.50
   OpenGL and shading language should always sync.
   Solution highlighted in desmume.cmd.
   b. Slightly easier. Override OpenGL version to 3.3. Get shading language sync for free.
   Going above requirements is most of times pretty safe.
   Solution highlighted in desmume2.cmd.

2. GPU Caps Viewer
   Tessellation is not supported by Mesa software rendering so only OpenGL 3.x, OpenGL 2.1 and OpenGL 1.2
   benchmarks can run. A lot of demos expect OpenGL 3.2. In conclusion we need OpenGL 3.2 or 3.3
   with either Core profile or compatibility context. Core profile works because since Mesa 18.0 switch
   from OpenGL 3.1 and above with core profile down to OpenGL 3.0 and older finally works seamlessly.
   In conclusion OpenGL 3.3 with anything other than forward compatible context is the easiest choice
   as shown in GPUCapsViewer.cmd.

3. rpcs3 - Playstation 3 emulator.
   System requirements: OpenGL 4.3 with GLSL 4.30 as specified here:
   https://rpcs3.net/quickstart
   Example highlighted in rpcs3.cmd
   This example shows it is possible to request an incomplete OpenGL context as long as required extensions
   are available. At this moment Mesa3D software rendering only supports OpenGL 3.3 fully in Core profile.

4. swr example
   PPSSPP doesn't need any kind of OpenGL context configuration as it's one of the few programs that request
   OpenGL core profile. This example shows how to use swr instead of llvmpipe. There no conflict between
   gallium driver selection and OpenGL context configuration override. You can mix them if necessary.
