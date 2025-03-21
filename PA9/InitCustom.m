doPlot = 1;
dt = 5e-15;
TStop = 3000 * dt;
InitDist = 0.0;
Method = 'VE'; % VE -- Velocity Verlet; FD -- Forward Difference

Mass0 = 14 * C.am; % Silicon
Mass1 = 100 * C.am; % Argon

AtomSpacing = 0.5430710e-9;
LJSigma = AtomSpacing / 2^(1 / 6);
LJEpsilon = 1e-21;

PhiCutoff = 3 * AtomSpacing * 1.1;

T = 30; % Temperature

% Create a rectangular atomic array as a background
AddRectAtomicArray(10, 10, 0, 0, 0, 0, 0, T, 0);

% Add a circular atomic array at the center (10 * AtomSpacing, 10 * AtomSpacing)
rad = 5; % Radius of the circular atomic array in atomic units
X0 = 10 * AtomSpacing;
Y0 = 10 * AtomSpacing;
VX0 = 0;
VY0 = 0;
Type = 1; % Set type to 1 (Argon in this case)

% Call the function that creates a circular atomic structure with an explosion effect
AddCircAtomicArray(rad, X0, Y0, VX0, VY0, InitDist, T, Type);

% Simulation boundaries and plotting parameters
Size = 10 * AtomSpacing;
Limits = [-Size +Size -Size +Size]; % Define simulation area
PlDelt = 5 * dt;

PlotFile = 'Explosion.gif'; % Output GIF file
PlotPosOnly = 1;
doPlotImage = 0;
PlotSize = [100, 100, 1049, 1049];

ScaleV = .02e-11;
ScaleF = 10;
