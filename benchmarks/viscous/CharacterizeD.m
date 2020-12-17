clear all; close all; clc;

Gc = 0.45;
l = 0.02;
c0 = pi;
dt = 0.005;

E = readtable("mechanical_fracture1d_energies_0.0.csv");
TE = E.total_energy;
D = max(TE) - TE;
I = readtable("sdf.csv");
gamma = I.gamma;
gamma_dot = I.gamma_dot;

Dest = l * pi * gamma;

ax = axes; hold(ax,'on'); grid(ax,'on');
plot(ax, D); ax.TickLabelInterpreter = 'latex';
ax.XLim = [200 1000];
plot(ax, Dest);
