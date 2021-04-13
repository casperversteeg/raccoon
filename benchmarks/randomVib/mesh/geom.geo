SetFactory("OpenCASCADE");
Mesh.ElementOrder = 1;
Mesh.SecondOrderLinear = 0;
Mesh.RecombinationAlgorithm = 8;
Mesh.Algorithm = 5;

elemThroughWall = 3;
wallThickness = 3;


Point(1) = {-0.05, -0.05, 0, 0.001*wallThickness/elemThroughWall};
Point(2) = { 0.05, -0.05, 0, 0.001*wallThickness/elemThroughWall};
Point(3) = { 0.05,  0.05, 0, 0.001*wallThickness/elemThroughWall};
Point(4) = {-0.05,  0.05, 0, 0.001*wallThickness/elemThroughWall};
Point(5) = {-(0.05-0.001*wallThickness), -(0.05-0.001*wallThickness), 0, 0.00092*wallThickness/elemThroughWall};
Point(6) = { (0.05-0.001*wallThickness), -(0.05-0.001*wallThickness), 0, 0.00092*wallThickness/elemThroughWall};
Point(7) = { (0.05-0.001*wallThickness),  (0.05-0.001*wallThickness), 0, 0.00092*wallThickness/elemThroughWall};
Point(8) = {-(0.05-0.001*wallThickness),  (0.05-0.001*wallThickness), 0, 0.00092*wallThickness/elemThroughWall};

Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};

Line(5) = {5, 6};
Line(6) = {6, 7};
Line(7) = {7, 8};
Line(8) = {8, 5};

Line Loop(1) = {1, 2, 3, 4};
Plane Surface(1) = {1};
Line Loop(2) = {5, 6, 7, 8};
Plane Surface(2) = {2};

BooleanDifference{ Surface{1}; }{ Surface{2}; Delete; }
Recursive Delete { Surface{1}; }

Recombine Surface {2};
