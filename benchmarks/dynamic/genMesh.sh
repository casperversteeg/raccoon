#!/usr/bin/env bash

gmsh mesh/dynamic_branching_geom.geo -2 -o mesh/dynamic_branching_geom.msh
gmsh mesh/quasistatic_geom.geo -2 -o mesh/quasistatic_geom.msh
