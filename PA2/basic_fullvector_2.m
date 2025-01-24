% This example shows how to calculate and plot both the
% fundamental TE and TM eigenmodes of an example 3-layer ridge
% waveguide using the full-vector eigenmode solver.

% Refractive indices:
n1 = 3.34;          % Lower cladding
n3 = 1.00;          % Upper cladding (air)

% Layer heights:
h1 = 2.0;           % Lower cladding
h2 = 1.3;           % Core thickness
h3 = 0.5;           % Upper cladding

% Horizontal dimensions:
rh = 1.1;           % Ridge height
rw = 1.0;           % Ridge half-width
side = 1.5;         % Space on side

% Grid size:
dx = 0.0125;        % grid size (horizontal)
dy = 0.0125;        % grid size (vertical)

lambda = 1.55;      % vacuum wavelength
nmodes = 1;         % number of modes to compute

% Ridge index values
n2_start = 3.305;   % Starting ridge index
n2_end = 3.44;      % Ending ridge index
steps = 10;         % Number of steps for ridge index

% Initialize arrays for tracking neff
n2_values = linspace(n2_start, n2_end, steps);
neff_values = zeros(1, steps);

% Loop over ridge indices
for i = 1:steps
    n2 = n2_values(i);
    
    % Generate waveguide mesh for the current ridge index
    [x, y, xc, yc, nx, ny, eps, edges] = waveguidemesh([n1, n2, n3], ...
                                                       [h1, h2, h3], ...
                                                       rh, rw, side, dx, dy);
    
    % Solve for the fundamental TE mode
    [Hx, Hy, neff] = wgmodes(lambda, n2, nmodes, dx, dy, eps, '000A');
    neff_values(i) = neff; % Store the effective index
    
    fprintf(1, 'Ridge index = %.3f, neff = %.6f\n', n2, neff);
    
    % Plot the mode profiles
    figure(i);
    subplot(121);
    contourmode(x, y, Hx);
    title(['Hx (TE mode), n2 = ', num2str(n2)]);
    xlabel('x'); ylabel('y');
    for v = edges, line(v{:}); end
    
    subplot(122);
    contourmode(x, y, Hy);
    title(['Hy (TE mode), n2 = ', num2str(n2)]);
    xlabel('x'); ylabel('y');
    for v = edges, line(v{:}); end
end

% Plot neff as a function of ridge index
figure;
plot(n2_values, neff_values, '-o', 'LineWidth', 2);
xlabel('Ridge Index (n2)');
ylabel('Effective Index (neff)');
title('Effective Index vs Ridge Index');
grid on;
