Coupled = 1;
TwoCarriers = 1;
RC = 1;

nx = 201;
l = 1e-6;

x =linspace(0,l,nx);
dx = x(2)-x(1);
xm = x(1:nx-1) + 0.5*dx;

% % Exponentially varying doping profile
% % NetDoping_0 = linspace(1e16 * 1e6, 20e16 * 1e6, nx);

NetDoping = (1e16 * 1e6) * exp(linspace(0, log(20), nx));

%NetDoping = logspace(log10(1e16 * 1e6), log10(20e16 * 1e6), nx);


% % NetDoping = exp(NetDoping_0);

% % Linearly varying doping profile
% Nd_start = 1e16 * 1e6; 
% Nd_end = 20e16 * 1e6; 
% NetDoping = linspace(Nd_start, Nd_end, nx); 

% Nd = 1e16 * 1e6; % Const. 1/cm3 (100 cm/m)^3
% NetDoping = ones(1,nx).*NetDoping_0; % doping

% NetDoping = ones(1,nx).*Nd; % doping

x0 = l/2;
nw = l/20;

npDisturbance = 0;
% npDisturbance = 1e16*1e6*exp(-((x-x0)/nw).^2);

LVbc = 0;
RVbc = 0;

TStop = 14200000*1e-18;
PlDelt = 100000*1e-18;

% PlotYAxis = {[-1e-15 2e-15] [-2e-9 2e-9] [-1.5e-12 1.5e-12]...
%     [1e22 2e22] [0 1e22] [0 20e43]...
%     [-20e33 15e33] [-2.5e34 2e34] [-1.1e8 1.1e8] ...
%     [-1e8 1e8] [-10e-3 10e-3] [0 2e22]};

doPlotImage = 0;
PlotFile = 'Gau2CarRC.gif';
