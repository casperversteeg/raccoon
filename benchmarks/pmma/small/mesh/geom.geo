h = 8;
w = 8;

E = 0.04;

Point(1) = {-w+2,   0, 0,    E};
Point(2) = {   w,   0, 0,    E};
Point(3) = {   w, h/6, 0,    E};
Point(4) = {   w,   h, 0, 15*E};
Point(5) = {  -w,   h, 0, 15*E};
Point(6) = {  -w, h/6, 0,  4*E};
Point(7) = {  -w,   0, 0,    E};
/* Point(8) = {  -w/2,   0, 0,    E}; */


// Lines
Line(1) = {1, 2};
/* Line(2) = {8, 2}; */
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 5};
Line(5) = {5, 6};
Line(6) = {6, 7};
Line(7) = {7, 1};
Line Loop(1) = {1, 2, 3, 4, 5, 6, 7};
Plane Surface(1) = {1};
Line(8) = {6, 3};
Line{8} In Surface{1};
/* Line(8) = {1, 7};
Line(9) = {7, 8};
Line(10) = {8, 3};
Line{8, 9, 10} In Surface {1}; */

// Names
Physical Surface("all") = {1};
Physical Line("center") = {1};
Physical Line("right") = {2, 3};
Physical Line("top") = {4};
Physical Line("left") = {5, 6};
