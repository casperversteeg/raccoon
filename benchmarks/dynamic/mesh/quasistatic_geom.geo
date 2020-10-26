a = 0.5;
r = 0.0005;

E = 0.1;
e = 0.004;

Point(1) = {-a, -a, 0, E};
Point(2) = {-a, -r, 0, E};
Point(3) = {-r, -r, 0, e};
Point(4) = {-r, 0, 0, e};
Point(5) = {-r, r, 0, e};
Point(6) = {-a, r, 0, E};
Point(7) = {-a, 0.5, 0, E};
Point(8) = {a, a, 0, E};
Point(9) = {a, a/10, 0, e};
Point(10) = {a, -a/10, 0, e};
Point(11) = {a, -a, 0, E};

Point(12) = {-r, a/10, 0, e};
Point(13) = {-r, -a/10, 0, e};
Point(14) = {-a/10, r, 0, e};
Point(15) = {-a/10, -r, 0, e};

Line(1) = {1, 2};
Line(2) = {2, 15};
Line(3) = {15, 3};
Circle(4) = {3, 4, 5};
Line(5) = {5, 14};
Line(6) = {14, 6};
Line(7) = {6, 7};
Line(8) = {7, 8};
Line(9) = {8, 9};
Line(10) = {9, 10};
Line(11) = {10, 11};
Line(12) = {11, 1};
Line(13) = {12, 9};
Line(14) = {13, 10};
Circle(15) = {12, 5, 14};
Circle(16) = {15, 3, 13};
/* Line(13) = {12, 14};
Line(14) = {13, 15}; */
Line Loop(1) = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12};

Plane Surface(1) = {1};
Line{13, 14, 15, 16} In Surface {1};

Physical Surface("all") = {1};
Physical Line("top") = {8};
Physical Line("bottom") = {12};
Physical Line("left") = {1, 7};
Physical Line("right") = {9, 10, 11};
