% This example shows how to calculate and plot both the
% fundamental TE and TM eigenmodes of an example 3-layer ridge
% waveguide using the full-vector eigenmode solver.  

% Refractive indices:
n1 = 3.34;          % Lower cladding
n2 = 3.44;          % Core
n3 = 1.00;          % Upper cladding (air)

% Layer heights:
h1 = 2.0;           % Lower cladding
h2 = 1.3;           % Core thickness
h3 = 0.5;           % Upper cladding

% Horizontal dimensions:
rh = 1.1;           % Ridge height
rw = 1.0;   % Ridge half-width
side = 1.5;         % Space on side
rw_start = 0.325;   % Starting ridge half-width
rw_end = 1.0;       % Ending ridge half-width
steps = 10;         % Number of steps for ridge half-width

% Grid size:
dx = 0.0250;        % grid size (horizontal)
dy = 0.0250;        % grid size (vertical)

lambda = 1.55;      % vacuum wavelength
nmodes = 1;         % number of modes to compute

% Initialize arrays for tracking neff
rw_values = linspace(rw_start, rw_end, steps);
neff_values = zeros(1, steps);

% Loop over ridge half-widths
for i = 1:steps
    rw = rw_values(i);
    
    % Generate waveguide mesh for the current ridge width
    [x, y, xc, yc, nx, ny, eps, edges] = waveguidemesh([n1, n2, n3], ...
                                                       [h1, h2, h3], ...
                                                       rh, rw, side, dx, dy);
    
    % Solve for the fundamental TE mode
    [Hx, Hy, neff] = wgmodes(lambda, n2, nmodes, dx, dy, eps, '000A');
    neff_values(i) = neff; % Store the effective index
    
    fprintf(1, 'Ridge half-width = %.3f, neff = %.6f\n', rw, neff);
    
    % Plot the mode profiles
    figure(i);
    subplot(121);
    contourmode(x, y, Hx);
    title(['Hx (TE mode), rw = ', num2str(rw)]);
    xlabel('x'); ylabel('y');
    for v = edges, line(v{:}); end
    
    subplot(122);
    contourmode(x, y, Hy);
    title(['Hy (TE mode), rw = ', num2str(rw)]);
    xlabel('x'); ylabel('y');
    for v = edges, line(v{:}); end
end
% Next consider the fundamental TM mode
% (same calculation, but with opposite symmetry)

% [Hx,Hy,neff] = wgmodes(lambda,n2,nmodes,dx,dy,eps,'000S');
% 
% fprintf(1,'neff = %.6f\n',neff);
% 
% figure(2);
% subplot(121);
% contourmode(x,y,Hx);
% title('Hx (TM mode)'); xlabel('x'); ylabel('y'); 
% for v = edges, line(v{:}); end
% 
% subplot(122);
% contourmode(x,y,Hy);
% title('Hy (TM mode)'); xlabel('x'); ylabel('y'); 
% for v = edges, line(v{:}); end
