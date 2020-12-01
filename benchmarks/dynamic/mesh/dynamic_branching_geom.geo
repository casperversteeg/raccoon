h = 20;
w = 50;

E = 0.3;

Point(1) = {    0, 0, 0,    E};
<<<<<<< HEAD
Point(2) = {    w, 0, 0,    E};
Point(3) = {    w, h, 0,    E};
Point(4) = {0.5*w, h, 0,    E};
Point(5) = {   -w, h, 0, 10*E};
Point(6) = {   -w, 0, 0,  5*E};
=======
Point(2) = {   10, 0, 0,    E};
Point(3) = {    w, 0, 0,  3*E};
Point(4) = {    w, h, 0,    E};
Point(5) = {0.5*w, h, 0, 10*E};
Point(6) = {   -w, h, 0, 20*E};
Point(7) = {   -w, 0, 0, 20*E};
>>>>>>> release rate mumbo jumbo


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
Physical Line("center") = {1};
Physical Line("right") = {2};
Physical Line("top") = {3, 4};
Physical Line("left") = {5};
