h = 8;
w = 16;

E = 0.1;

Point(1) = {   0, 0, 0,   E};
Point(2) = {   w, 0, 0,   E};
Point(3) = {   w, h, 0, 2*E};
Point(4) = {  -w, h, 0, 5*E};
Point(5) = {  -w, 0, 0,   E};
Point(6) = {-w+4, 0, 0,   E};


// Lines
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 5};
Line(5) = {5, 6};
Line(6) = {6, 1};
Line Loop(1) = {1, 2, 3, 4, 5, 6};
Plane Surface(1) = {1};

// Names
Physical Surface("all") = {1};
Physical Line("center") = {1, 6};
Physical Line("right") = {2};
Physical Line("top") = {3};
Physical Line("left") = {4};
