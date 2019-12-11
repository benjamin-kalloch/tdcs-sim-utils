// The creation of spheres is only possible with OCC Kernel
SetFactory("OpenCASCADE");


// Adjust settings
// 0.01 creates around 15 Mio. tetrahedra
// 0.005 creates aroung 120 Mio. tetrahedra
// -> increased resolution by 8
// -> This amount cannot be imported to OpenFOAM (with ~60GB RAM)
// 0.00629961 (= 0.01 / (4^(1/3)) creates around 60 Mio. tetrahedra
// -> increased resolution by ~4
Mesh.CharacteristicLengthMax=0.00629961;

// ######## outer sphere ########
Sphere(1) = { 0, 0, 0, 92./97. };   // we use 5mm offset layer since we cannot model point-electrode with OpenFOAM
Sphere(2) = { 0, 0, 0, 85./97. };   // radii according to the Rush&Driscoll paper
Sphere(3) = { 0, 0, 0, 80./97. };

Physical Surface("outer layer") = Boundary{Volume{1};};

// Subtract the skull sphere from the skin sphere to avoid overlap
BooleanDifference(101) = { Volume{1}; Delete; }{ Volume{2}; };
// Subtract the brain sphere from the skull sphere to avoid overlap 
BooleanDifference(102) = { Volume{2}; Delete; }{ Volume{3}; };

// Create volumes of the two outer shells and the inner most (brain) sphere
Physical Volume("skin") = {101};
Physical Volume("skull") = {102};
Physical Volume("brain") = {3};

