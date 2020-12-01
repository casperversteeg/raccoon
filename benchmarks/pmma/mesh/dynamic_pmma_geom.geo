h = 8;
w = 16;

<<<<<<< HEAD
E = 0.3;

Point(1) = {   0, 0, 0, E};
Point(2) = {   w, 0, 0, E};
Point(3) = {   w, h, 0, E};
Point(4) = {  -w, h, 0, E};
Point(5) = {  -w, 0, 0, E};
Point(6) = {-w+4, 0, 0, E};
=======
E = 0.02;

Point(1) = {-w+4,   0, 0,    E};
Point(2) = {   w,   0, 0,    E};
Point(3) = {   w, h/8, 0, 30*E};
Point(4) = {   w,   h, 0, 30*E};
Point(5) = {  -w,   h, 0, 30*E};
Point(6) = {  -w,   0, 0, 20*E};
Point(7) = {-w+5,h/16, 0,    E};
Point(8) = {-w/2, h/8, 0,    E};
Point(9) = {-w/2,   0, 0,    E};
>>>>>>> release rate mumbo jumbo


// Lines
Line(1) = {1, 9};
Line(2) = {9, 2};
Line(3) = {2, 3};
Line(4) = {3, 4};
Line(5) = {4, 5};
Line(6) = {5, 6};
Line(7) = {6, 1};
Line Loop(1) = {1, 2, 3, 4, 5, 6, 7};
Plane Surface(1) = {1};
<<<<<<< HEAD

// Names
Physical Surface("all") = {1};
Physical Line("center") = {1, 6};
Physical Line("right") = {2};
Physical Line("top") = {3};
Physical Line("left") = {4};
=======
Line(8) = {1, 7};
Line(9) = {7, 8};
/* Line(10) = {8, 9}; */
Line{8, 9} In Surface {1};

// Names
Physical Surface("all") = {1};
Physical Line("center") = {1, 2};
Physical Line("right") = {3, 4};
Physical Line("top") = {5};
Physical Line("left") = {6};
>>>>>>> release rate mumbo jumbo
