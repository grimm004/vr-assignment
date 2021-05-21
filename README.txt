All problem implementations are demonstrated in a single scene (see scene hierarchy).
Respective problems have their game objects enabled and disabled as required.

Runtime usage:
- Press Left and Right Arrows to change camera (cycling between problems 0, 1, 2, 3.1, 3.3 starting with problem 1).
- Press "R" to toggle cube spinning.
- Press "E" to set cube rotations to 45 degrees about the y axis.
- When in a vertex shader problem (3.1 or 3.3), press Space to cycle between mesh vertex counts.

Project Structure:
/Assets/Materials - Materials corresponding to their respectively named shaders.
/Assets/Meshes - Mesh prefabs for problem 3.
/Assets/Scenes - Project scene
/Assets/Scripts - Custom component scripts
/Assets/Shaders - Custom shaders implementing the distortions
/Assets/Textures - Textures and Render Textures used for mesh projection

Material and shader naming:
- ForwardsRadial_Frag - Fragment shader implementation for Brown's simplified forwards radial distortion transform
- ForwardsRadial_Vert - Vertex shader implementation for Brown's simplified forwards radial distortion transform
- InverseRadial_Frag - Fragment shader implementation for Brown's simplified inverse radial distortion transform
- InverseRadial_Vert - Vertex shader implementation for Brown's simplified inverse radial distortion transform
- LateralChromaticAberration - Fragment shader implementation for producing and correcting LCA distortion

Scene hierarchy:
The Unity scene is split into modular parts:
The "Directional Light", "Scene Camera", and "Cubes" game objects under "CubeScene" form the untouched, undistorted rotating cube scene.
The "Problem0" game object simply reproduces the untouched, undistorted rotating cube scene.
The "Problem1" game object consists of the quad used to render the pre-distorted image and the camera used to capture (and simulate lens distortion on) it.
The "Problem2" game object consists of a similar setup to "Problem1", except performs LCA distortion and correction.
The "Problem3" game object consists of "Problem3.1" and "Problem3.3", both of which implement the ability to switch between meshes of varying vertex count (as part of Problem 3.2).
"Problem3.1" works in the same way as "Problem1", except renders the scene camera output to the selected subdivided surface mesh, where it is warped by the vertex shader and output to its camera.
"Problem3.3" is the same as "Problem3.1", except adds one more layer to perform mesh-based lens distortion to the corrected pre-distortion scene.

Notes for further customisation:
- To change values for c1, c2 and LCA distortion/undistortion shifts, open the inspector for the respective distortion material and change the desired uniform values.
- Cube rotation speed can be changed in their respective inspector pages.
- Lens simulation (including optional LCA and pincushion distortion) can be enabled for Problem1 and Problem2 on the respective inspector pages for their cameras (the "Lens" component and its two distortions are disabled by default).
