winstyle = 'docked';
% winstyle = 'normal';

set(0,'DefaultFigureWindowStyle',winstyle)
set(0,'defaultaxesfontsize',18)
set(0,'defaultaxesfontname','Times New Roman')
% set(0,'defaultfigurecolor',[1 1 1])

% clear VARIABLES;
clear
global spatialFactor;
global c_eps_0 c_mu_0 c_c c_eta_0
global simulationStopTimes;
global AsymForcing
global dels
global SurfHxLeft SurfHyLeft SurfEzLeft SurfHxRight SurfHyRight SurfEzRight



dels = 0.75;
spatialFactor = 1;

c_c = 299792458;                  % speed of light
c_eps_0 = 8.8542149e-12;          % vacuum permittivity
c_mu_0 = 1.2566370614e-6;         % vacuum permeability
c_eta_0 = sqrt(c_mu_0/c_eps_0);


tSim = 200e-15;
f = 100e12;
lambda = c_c/f;


xMax{1} = 20e-6;
nx{1} = 200;
ny{1} = 0.75*nx{1};


Reg.n = 1;

mu{1} = ones(nx{1},ny{1})*c_mu_0;

% This sets the whole grid to the base epsilon
epi{1} = ones(nx{1},ny{1})*c_eps_0;

%epi{1}(125:150,55:95)= c_eps_0*11.3;
% q = 8 ;
% epi{1}(60/q:80/q,55:95)= c_eps_0*11.3;
% epi{1}(80/q:100/q,65:85)= c_eps_0*11.3;
% epi{1}(100/q:120/q,55:95)= c_eps_0*11.3;
% epi{1}(120/q:140/q,65:85)= c_eps_0*11.3;
% epi{1}(140/q:160/q,55:95)= c_eps_0*11.3;
% epi{1}(160/q:180/q,65:85)= c_eps_0*11.3;
% x= 50;
% epi{1}(60/q:80/q,55+x:95+x)= c_eps_0*11.3;
% epi{1}(80/q:100/q,65+x:85+x)= c_eps_0*11.3;
% epi{1}(100/q:120/q,55+x:95+x)= c_eps_0*11.3;
% epi{1}(120/q:140/q,65+x:85+x)= c_eps_0*11.3;
% epi{1}(140/q:160/q,55+x:95+x)= c_eps_0*11.3;
% epi{1}(160/q:180/q,65+x:85+x)= c_eps_0*11.3;
% y = -50;
% epi{1}(60/q:80/q,55+y:95+y)= c_eps_0*11.3;
% epi{1}(80/q:100/q,65+y:85+y)= c_eps_0*11.3;
% epi{1}(100/q:120/q,55+y:95+y)= c_eps_0*11.3;
% epi{1}(120/q:140/q,65+y:85+y)= c_eps_0*11.3;
% epi{1}(140/q:160/q,55+y:95+y)= c_eps_0*11.3;
% epi{1}(160/q:180/q,65+y:85+y)= c_eps_0*11.3;

% Define ring center
cx = round(nx{1} / 2);
cy = round(ny{1} / 2);

% Define inner and outer radius of the ring
R_out = 40;  % Outer radius
R_in = 35;   % Inner radius (controls thickness)

% Create coordinate grid
[X, Y] = meshgrid(1:ny{1}, 1:nx{1});
dist = sqrt((X - cy).^2 + (Y - cx).^2);

% Create ring mask
ring_mask = (dist >= R_in) & (dist <= R_out);

epi{1}(20:190,113:116)= c_eps_0*11.3;
epi{1}(20:190,33:36)= c_eps_0*11.3;
% epi{1}(58:62,35:115)= c_eps_0*11.3;
epi{1}(ring_mask) = c_eps_0 * 11.3;  % Ring (hollow circle)

% Define half the side length of the diamond
side_length_1 = 35;  % Adjust as needed
side_length_2 = 30;

% Create coordinate grid
[X, Y] = meshgrid(1:ny{1}, 1:nx{1});

% Calculate the distance from the center for the diamond shape
diamond_mask = abs(X - cy) + abs(Y - cx) <= side_length_1;
diamond_mask_2 = abs(X - cy) + abs(Y - cx) <= side_length_2;

% Apply the diamond shape to epi{1}
epi{1}(diamond_mask) = c_eps_0 * 11.3;  % Diamond shape
epi{1}(diamond_mask_2) = c_eps_0;  % Diamond shape

sigma{1} = zeros(nx{1},ny{1});
sigmaH{1} = zeros(nx{1},ny{1});

dx = xMax{1}/nx{1};
dt = 0.25*dx/c_c;
nSteps = round(tSim/dt*2);
yMax = ny{1}*dx;
nsteps_lamda = lambda/dx;

% Parameters to set up the plot
movie = 1;
Plot.off = 0;
Plot.pl = 0;
Plot.ori = '13';
Plot.N = 100;
Plot.MaxEz = 3.0;
Plot.MaxH = Plot.MaxEz/c_eta_0;
Plot.pv = [0 0 90];
Plot.reglim = [0 xMax{1} 0 yMax];

% Original Source
bc{1}.NumS = 2;
bc{1}.s(1).xpos = nx{1}/(4) - 10;
bc{1}.s(1).type = 'ss';
bc{1}.s(1).fct = @PlaneWaveBC;

% 2nd Source
bc{1}.s(2).xpos = (nx{1}/(4))*2 + 50 ;
bc{1}.s(2).type = 'ss';
bc{1}.s(2).fct = @PlaneWaveBC;

% Parameters of Source 1
mag1 = 5;
phi1 = 45;
omega1 = f*1*pi;
betap1 = 0;
t01 = 30e-15;
st1_1 = 15e-15;
s1_1 = 0;
y01 = yMax/2;
sty1 = 1.5*lambda;

% Parameters of Source 2
mag2 = 0;
phi2 = 0;
omega2 = f*2*pi;
betap2 = 0;
t02 = 30e-15;
st2_2 = 15e-15;
s2_2 = 0;
y02 = yMax/2;
sty2 = 1.5*lambda;

% Adding the parameters
bc{1}.s(1).paras = {mag1,phi1,omega1,betap1,t01,st1_1,s1_1,y01,sty1,'s'};
bc{1}.s(2).paras = {mag2,phi2,omega2,betap2,t02,st2_2,s2_2,y02,sty2,'s'};

% Plots of y for both sources
Plot.y01 = round(y01/dx);
Plot.y02 = round(y02/dx);

% Controls the boundary conditions (either absorbing or reflecting)
bc{1}.xm.type = 'a';
bc{1}.xp.type = 'e';
bc{1}.ym.type = 'a';
bc{1}.yp.type = 'a';

pml.width = 20 * spatialFactor;
pml.m = 3.5;

Reg.n  = 1;
Reg.xoff{1} = 0;
Reg.yoff{1} = 0;

RunYeeReg






