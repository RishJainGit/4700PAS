% Given parameters
Is = 0.01e-6; % 0.01 pA in A
Ib = 0.1e-6;  % 0.1 pA in A
Vb = 1.3;     % in V
Gp = 0.1;     % in S (Ω⁻¹)

% Create V vector from -1.95V to 0.7V with 200 steps
V = linspace(-1.95, 0.7, 200);

% Compute I vector using the given formula
I = Is*(exp((1.2/0.025)*V) - 1) + Gp*V - Ib*(exp(-(1.2/0.025)*(V+Vb)) - 1);

% Create a second I vector with 20% random variation
noise = 0.2 * I .* (2 * rand(size(I)) - 1);
I_noisy = I + noise;

% Polynomial Fits
coeff_4th = polyfit(V, I, 4);
coeff_8th = polyfit(V, I, 8);
I_fit_4th = polyval(coeff_4th, V);
I_fit_8th = polyval(coeff_8th, V);

% --- Define Nonlinear Fit Models ---
fo_full = fittype('A*(exp((1.2/0.025)*x) - 1) + B*x - C*(exp(-(1.2/0.025)*(x+D)) - 1)', ...
                  'independent', 'x', 'coefficients', {'A', 'B', 'C', 'D'});

% Case (a): Fit A & C (Fix B = Gp, D = Vb)
B_fixed = Gp;
D_fixed = Vb;
fo_AC = fittype('A*(exp((1.2/0.025)*x) - 1) + B_fixed*x - C*(exp(-(1.2/0.025)*(x+D_fixed)) - 1)', ...
                'independent', 'x', 'coefficients', {'A', 'C'}, ...
                'problem', {'B_fixed', 'D_fixed'});

ff_AC = fit(V', I', fo_AC, 'StartPoint', [1e-6, 1e-6], 'problem', {B_fixed, D_fixed});
If_AC = feval(ff_AC, V);

% Case (b): Fit A, B, C (Fix D = Vb)
fo_ABC = fittype('A*(exp((1.2/0.025)*x) - 1) + B*x - C*(exp(-(1.2/0.025)*(x+D_fixed)) - 1)', ...
                 'independent', 'x', 'coefficients', {'A', 'B', 'C'}, ...
                 'problem', {'D_fixed'});

ff_ABC = fit(V', I', fo_ABC, 'StartPoint', [1e-6, 0.1, 1e-6], 'problem', {D_fixed});
If_ABC = feval(ff_ABC, V);

% Case (c): Fit A, B, C, and D (Full fitting)
ff_ABCD = fit(V', I', fo_full, 'StartPoint', [1e-6, 0.1, 1e-6, 1.3]);
If_ABCD = feval(ff_ABCD, V);

% Train Neural Network
inputs = V';
targets = I';
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize);
net.trainFcn = 'trainlm'; % Use Levenberg-Marquardt
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
[net,tr] = train(net,inputs,targets);
outputs = net(inputs);
performance = perform(net,targets,outputs);
view(net);
If_NN = outputs; 


m = fitrgp(V', I');

xp = linspace(min(V), max(V), 100)'; 

yp = predict(m, xp);

figure;
subplot(4,2,1);
plot(V, I, 'b', 'LineWidth', 1.5); 
hold on;
plot(V, I_noisy, 'r--', 'LineWidth', 1.2);
plot(V, I_fit_4th, 'g-', 'LineWidth', 1.2);
plot(V, I_fit_8th, 'c-', 'LineWidth', 1.2);
hold off;
xlabel('Voltage (V)');
ylabel('Current (A)');
legend('Original I', 'Noisy I','4th Order Fit','8th Order Fit');
title('Polynomial Fits (Linear)');

subplot(4,2,2);
semilogy(V, abs(I), 'b', 'LineWidth', 1.5);
hold on;
semilogy(V, abs(I_noisy), 'r--', 'LineWidth', 1.2);
semilogy(V, abs(I_fit_4th), 'g-', 'LineWidth', 1.2);
semilogy(V, abs(I_fit_8th), 'c-', 'LineWidth', 1.2);
hold off;
xlabel('Voltage (V)');
ylabel('Log Current (A)');
legend('Original I', 'Noisy I','4th Order Fit','8th Order Fit');
title('Polynomial Fits (Semilog)');


subplot(4,2,3);
plot(V, I, 'k-', 'LineWidth', 1.5);
hold on;
plot(V, If_AC, 'r--', 'LineWidth', 1.5);
plot(V, If_ABC, 'g--', 'LineWidth', 1.5);
plot(V, If_ABCD, 'b-', 'LineWidth', 1.5);
hold off;
xlabel('Voltage (V)');
ylabel('Current (A)');
legend('Original I', 'Fit A & C', 'Fit A, B & C', 'Fit A, B, C & D');
title('Nonlinear Fits (Linear)');

subplot(4,2,4);
semilogy(V, abs(I), 'k-', 'LineWidth', 1.5);
hold on;
semilogy(V, abs(If_AC), 'r--', 'LineWidth', 1.5);
semilogy(V, abs(If_ABC), 'g--', 'LineWidth', 1.5);
semilogy(V, abs(If_ABCD), 'b-', 'LineWidth', 1.5);
hold off;
xlabel('Voltage (V)');
ylabel('Log Current (A)');
legend('Original I', 'Fit A & C', 'Fit A, B & C', 'Fit A, B, C & D');
title('Nonlinear Fits (Semilog)');

%
subplot(4,2,5);
plot(V, I, 'k-', 'LineWidth', 1.5);
hold on;
plot(V, If_NN, 'm-', 'LineWidth', 1.5);
hold off;
xlabel('Voltage (V)');
ylabel('Current (A)');
legend('Original I', 'Neural Net Fit');
title('Neural Network Fit (Linear)');

subplot(4,2,6);
semilogy(V, abs(I), 'k-', 'LineWidth', 1.5);
hold on;
semilogy(V, abs(If_NN), 'm-', 'LineWidth', 1.5);
hold off;
xlabel('Voltage (V)');
ylabel('Log Current (A)');
legend('Original I', 'Neural Net Fit');
title('Neural Network Fit (Semilog)');

subplot(4,2,7)
plot(V, I, 'bo', 'DisplayName', 'Training Data'); hold on;
plot(xp, yp, 'r-', 'DisplayName', 'GPR Prediction');
legend; xlabel('Voltage (V)'); ylabel('Current (A)');
title('Gaussian Process Regression (Linear Scale)');

subplot(4,2,8)
semilogy(V, abs(I), 'b', 'DisplayName', 'Training Data'); hold on;
semilogy(xp, abs(yp), 'r--', 'DisplayName', 'GPR Prediction');
legend; xlabel('Voltage (V)'); ylabel('Log Current (A)');
title('Gaussian Process Regression (Semilog Scale)');


grid on;
