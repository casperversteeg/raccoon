h = 20;
w = 50;

E = 0.1;

Point(1) = {    0, 0, 0,    E};
Point(2) = {   10, 0, 0,    E};
Point(3) = {    w, 0, 0,  2*E};
Point(4) = {    w, h, 0,    E};
Point(5) = {0.5*w, h, 0, 10*E};
Point(6) = {   -w, h, 0, 20*E};
Point(7) = {   -w, 0, 0, 20*E};


// Lines
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 5};
Line(5) = {5, 6};
Line(6) = {6, 7};
Line(7) = {7, 1};
Line Loop(1) = {1, 2, 3, 4, 5, 6, 7};
Plane Surface(1) = {1};
Line (8) = {2, 4};
Line{8} In Surface {1};

// Names
Physical Surface("all") = {1};
Physical Line("center") = {1, 2};
Physical Line("right") = {3};
Physical Line("top") = {4, 5};
Physical Line("left") = {6};
