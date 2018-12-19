// define the characteritic length of a 'point'
// influences the distribution of the mesh element sizes.
lc = 0.05;
// define a plane with 4 vertices and 4 edges
Point(1) = {0.0,0.0,0.0,lc};
Point(2) = {1,0.0,0.0,lc};
Point(3) = {1,1,0.0,lc};
Point(4) = {0,1,0.0,lc};
Line(1) = {4,3};
Line(2) = {3,2};
Line(3) = {2,1};
Line(4) = {1,4};
// define the plane as a boundary surface
Line Loop(5) = {2,3,4,1};
Plane Surface(6) = {5};
// extrude the plane to get the full cube
// tmp will be the result of the extrusion.
// according to the GMSH docs the structure of the array is:
//  0     - the original surface that was extruded
//  1     - the whole volume, created by the extrusion
//  2...n - the additional 'side'-faces that got created as an result of the extrusion 
//          (so in the cube case that would be left,right,top, bottom) 
tmp[] = Extrude {0,0.0,1} {
  Surface{6};
};
Physical Volume(1) = tmp[1];
Physical Surface("front") = {6};
Physical Surface("back") = {tmp[0]};
//+
Extrude {0, 0, 2} {
  Line{11}; Line{10}; Line{8}; Line{9}; Layers{1}; Recombine;
}
