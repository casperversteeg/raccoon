h = 8;
w = 16;

E = 0.025;

Point(1) = {-w+4,   0, 0,    E};
Point(2) = {   w,   0, 0,    E};
Point(3) = {   w, h/2, 0, 10*E};
Point(4) = {   w,   h, 0, 25*E};
Point(5) = {  -w,   h, 0, 25*E};
Point(6) = {  -w,   0, 0, 25*E};
Point(7) = {   0, h/2, 0,    E};


// Lines
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 5};
Line(5) = {5, 6};
Line(6) = {6, 1};
Line Loop(1) = {1, 2, 3, 4, 5, 6};
Plane Surface(1) = {1};
Line(7) = {1, 7};
Line(8) = {7, 3};
Line{7, 8} In Surface {1};

// Names
Physical Surface("all") = {1};
Physical Line("center") = {1};
Physical Line("right") = {2, 3};
Physical Line("top") = {4};
Physical Line("left") = {5};
