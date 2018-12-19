//
// A cube with a with boundary conditions inside
//

// define the characteritic length of a 'point'
// influences the distribution of the mesh element sizes.
lc = 0.01;

// ######## outer domain ##########
// define a plane with 4 vertices and 4 edges
Point(1) = {0.0,0.0,0.0,lc};
Point(2) = {1.0,0.0,0.0,lc};
Point(3) = {1.0,1.0,0.0,lc};
Point(4) = {0.0,1.0,0.0,lc};
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
//  0     - the "top" original surface that was extruded
//  1     - the original surface
//  2...n - the additional 'side'-faces that got created as an result of the extrusion 
//          (so in the cube case that would be left,right,top, bottom) 
outer_cube[] = Extrude {0.0,0.0,1.0} {
  Surface{6};
};
Surface Loop(7) = {6, outer_cube[0], outer_cube[2], outer_cube[3], outer_cube[4], outer_cube[5]};


// ########### the point charge ############
lc_half = lc/2.0;
lower_bound = 0.5 - lc_half;
upper_bound = 0.5 + lc_half;

Point(101) = {lower_bound,lower_bound,lower_bound,lc};
Point(102) = {upper_bound,lower_bound,lower_bound,lc};
Point(103) = {upper_bound,upper_bound,lower_bound,lc};
Point(104) = {lower_bound,upper_bound,lower_bound,lc};
Line(101) = {104,103};
Line(102) = {103,102};
Line(103) = {102,101};
Line(104) = {101,104};
// define the plane as a boundary surface
Line Loop(105) = {102,103,104,101};
Plane Surface(106) = {105};
// extrude the plane to get the full cube
// tmp will be the result of the extrusion.
// according to the GMSH docs the structure of the array is:
//  0     - the "top" original surface that was extruded
//  1     - the  original surface
//  2...n - the additional 'side'-faces that got created as an result of the extrusion 
//          (so in the cube case that would be left,right,top, bottom) 
inner_cube[] = Extrude {0.0,0.0,lc} {
  Surface{106};
};
Surface Loop(107) = {106, inner_cube[0], inner_cube[2], inner_cube[3], inner_cube[4], inner_cube[5]};

// Remove the automatically created volumes of the two cubes
// Otherwise an meshing will succeed, but print and error message
Delete{ Volume{1,2}; }

Volume(1000) = {7,107};
Physical Volume(1001) = {1000};

Physical Surface("pc_front") = {106};
Physical Surface("pc_back") = {inner_cube[0]};
Physical Surface("pc_top") = {inner_cube[2]};
Physical Surface("pc_bottom") = {inner_cube[3]};
Physical Surface("pc_left") = {inner_cube[4]};
Physical Surface("pc_right") = {inner_cube[5]};



