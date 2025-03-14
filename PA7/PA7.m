% %X = [Vn1 Vn2 Vn3 Vn4 Vn5 is I3 IL];
% 
% % Given parameter values
% R1 = 1; C = 0.25; R2 = 2; L = 0.2; R3 = 10; alpha = 100; R4 = 0.1; RO = 1000;
% 
% % Compute conductance values
% G1 = 1 / R1;
% G2 = 1 / R2;
% G3 = 1 / R3;
% G4 = 1 / R4;
% G5 = 1 / RO;
% 
% G = [ G1  -G1   0   0   0    -1   0    0;
%      -G1  G1+G2 0   0   0     0   0    1;
%       0    0   G3  0   0     0   -1   0;
%       1    0   0   0   0     0   0    0;
%       0    0   G3  0   0     0   -1   0;
%       0    0   0   1   0     0  -alpha  0;
%       0    0   0  -G4  G4+G5  0   0    0;
%       0    0   0   0   0     0   0    0];
% 
% 
% C = [ C  -C   0   0   0   0   0   0;
%      -C   C   0   0   0   0   0   0;
%       0   0   0   0   0   0   0   0;
%       0   0   0   0   0   0   0   0;
%       0   0   0   0   0   0   0   0;
%       0   0   0   0   0   0   0   0;
%       0   0   0   0   0   0   0   0;
%       0   1  -1   0   0   0   0  -L];
% 
% F = [ 0; 0; 0; V_IN; 0; 0; 0; 0];
% 
% V = (G + 1i * C) \ F;
% 
% disp('G matrix:');
% disp(G);
% disp('C matrix:');
% disp(C);

% Given circuit parameters
R1 = 1; C = 0.25; R2 = 2; L = 0.2; R3 = 10; alpha = 100; R4 = 0.1; RO = 1000;

% Compute conductance values
G1 = 1 / R1;
G2 = 1 / R2;
G3 = 1 / R3;
G4 = 1 / R4;
G5 = 1 / RO;

% Define G matrix
G = [ G1  -G1   0   0   0    -1   0    0;
     -G1  G1+G2 0   0   0     0   0    1;
      0    0   G3  0   0     0   -1   0;
      1    0   0   0   0     0   0    0;
      0    0   G3  0   0     0   -1   0;
      0    0   0   1   0     0  -alpha  0;
      0    0   0  -G4  G4+G5  0   0    0;
      0    0   0   0   0     0   0    0];

% Define C matrix (including L)
C_matrix = [ C  -C   0   0   0   0   0   0;
            -C   C   0   0   0   0   0   0;
             0   0   0   0   0   0   0   0;
             0   0   0   0   0   0   0   0;
             0   0   0   0   0   0   0   0;
             0   0   0   0   0   0   0   0;
             0   0   0   0   0   0   0   0;
             0   1  -1   0   0   0   0  -L];

disp('G matrix:');
disp(G);
disp('C matrix:');
disp(C_matrix);

% Check rank of matrices
disp(['Rank of G: ', num2str(rank(G))]);
disp(['Size of G: ', num2str(size(G,1))]);

% If singular, add small perturbation
if rank(G) < size(G,1)
    warning('G matrix is singular! Adding a small perturbation...');
    G = G + 1e-9 * eye(size(G));
end

% Solve system
V = G \ F;



% %% **(c) DC Sweep: V1 from -10V to 10V**
% V1_range = linspace(-10, 10, 100); % Sweep from -10V to 10V
% V3_values = zeros(size(V1_range));
% VO_values = zeros(size(V1_range));
% 
% for i = 1:length(V1_range)
%     F = [0; 0; 0; V1_range(i); 0; 0; 0; 0];  % Set V1
%     V = G \ F;  % Solve DC circuit (G * X = F)
%     V3_values(i) = V(3);  % Store V3
%     VO_values(i) = V(5);  % Store VO
% end
% 
% figure;
% subplot(2,1,1);
% plot(V1_range, VO_values, 'b', 'LineWidth', 1.5);
% xlabel('V1 (V)'); ylabel('V_O (V)'); title('DC Sweep: Output Voltage V_O');
% grid on;
% 
% subplot(2,1,2);
% plot(V1_range, V3_values, 'r', 'LineWidth', 1.5);
% xlabel('V1 (V)'); ylabel('V_3 (V)'); title('DC Sweep: Voltage at V3');
% grid on;
% 
% % %% **(d) AC Analysis: Frequency Sweep**
% % frequencies = logspace(0, 6, 100);  % Frequency range 1Hz to 1MHz
% % VO_ac = zeros(size(frequencies));
% % 
% % for i = 1:length(frequencies)
% %     omega = 2 * pi * frequencies(i);
% %     F = [0; 0; 0; 1; 0; 0; 0; 0];  % AC analysis with V1 = 1V
% %     V = (G + 1i * omega * C_matrix) \ F; % Solve (G + jωC)V = F
% %     VO_ac(i) = abs(V(5));  % Magnitude of V_O
% % end
% % 
% % % Gain in dB: 20 * log10(VO/V1)
% % Gain_dB = 20 * log10(VO_ac / 1);
% % 
% % figure;
% % subplot(2,1,1);
% % semilogx(frequencies, VO_ac, 'b', 'LineWidth', 1.5);
% % xlabel('Frequency (Hz)'); ylabel('V_O (V)'); title('AC Analysis: Output Voltage V_O');
% % grid on;
% % 
% % subplot(2,1,2);
% % semilogx(frequencies, Gain_dB, 'r', 'LineWidth', 1.5);
% % xlabel('Frequency (Hz)'); ylabel('Gain (dB)'); title('AC Gain (20 log_{10}(V_O/V_1))');
% % grid on;
% % 
% % %% **(e) AC Gain with Random Perturbations on C**
% % num_samples = 1000;  % Number of random samples
% % std_dev = 0.05;  % Given standard deviation
% % omega_pi = pi;  % Frequency at ω = π
% % 
% % gain_samples = zeros(num_samples,1);
% % 
% % for i = 1:num_samples
% %     C_perturbed = C + std_dev * randn;  % Apply normal perturbation
% %     C_matrix_perturbed = C_matrix;
% %     C_matrix_perturbed(1,1) = C_perturbed;
% %     C_matrix_perturbed(1,2) = -C_perturbed;
% %     C_matrix_perturbed(2,1) = -C_perturbed;
% %     C_matrix_perturbed(2,2) = C_perturbed;
% % 
% %     F = [0; 0; 0; 1; 0; 0; 0; 0];  % AC analysis with V1 = 1V
% %     V = (G + 1i * omega_pi * C_matrix_perturbed) \ F; % Solve (G + jωC)V = F
% %     VO_perturbed = abs(V(5));  % Magnitude of V_O
% %     gain_samples(i) = 20 * log10(VO_perturbed / 1);  % Compute Gain in dB
% % end
% % 
% % % Plot histogram of gain variations
% % figure;
% % histogram(gain_samples, 30, 'FaceColor', 'b', 'EdgeColor', 'k');
% % xlabel('Gain (dB)'); ylabel('Frequency'); title('Histogram of Gain with Perturbations on C');
% % grid on;
