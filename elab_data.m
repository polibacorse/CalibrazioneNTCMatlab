%% load data
md = [-40 100.95; -30 53.1; -20 29.12; -10 16.6; 0 9.75; 
           10 5.97; 20 3.75; 25 3; 30 2.42; 40 1.6; 50 1.08;
           60 0.75; 70 0.53; 80 0.38; 90 0.28; 100 0.2; 110 0.15; 125 0.1]; % NTC manufacturer data

% Steinhart-Hart model for NTCs: https://it.wikipedia.org/wiki/Equazione_di_Steinhart-Hart

T = md(:, 1) + 273.16; % Reference temperatures [K]
R = 1000*md(:, 2); % NTC resistances @ reference temperatures [Ohms]

%% Coefficients calculation
k1 = 1;
k2 = 2;
k3 = 3;

L1 = log(R(k1));
L2 = log(R(k2));
L3 = log(R(k3));

Y1 = 1/T(k1);
Y2 = 1/T(k2);
Y3 = 1/T(k3);

g2 = (Y2 - Y1)/(L2 - L1);
g3 = (Y3 - Y1)/(L3 - L1);

C = (g3 - g2)/(L3 - L2)/(L1 + L2 + L3);
B = g2 - C*(L1^2 + L1*L2 + L2^2);
A = Y1 - (B + L1^2*C)*L1;

%% Steinhart-Hart model evaluation
Ti = linspace(min(T), max(T), length(T)*100);
y = (A - 1./Ti)/C;
x = sqrt((B/(3*C))^3 + (y/2).^2);
Rc = exp((x - y/2).^(1/3) - (x + y/2).^(1/3));

%% data plot
figure(1);
plot(T, R, 'ro', Ti, Rc, 'g-');
title('Manufacturer''s vs. Steinhart-Hart''s model data');
xlabel('temperature [K]');
ylabel('resistance [ohms]');
legend({'Manufacturer''s declared resistances', 'Steinhart-Hart''s model resistances'});

%% Load experimental data
meas = readmatrix('measurements.xls');
meas = meas(1:20000, :);

%%
Tref = meas(:, 2);
TH20 = meas(:, 3);
TOil = meas(:, 4);

x0 = [1, 1, 0, 0]; % initial conditions
x0 =  1.0e+11 *[ 0.7593    0.0009   -0.3383    1.1709]; % post elab initial conditions, for easier evaluation
%%option definition used to configure fminsearch function (see fminsearch documentation)
options = optimset; 
options.TolX = 1e-10;
options.TolFun = 1e-4;
options.MaxIter = 5000;
options.MaxFunEvals = 5000;
%%
Tc = TOil; % Change this value to TH20 to calibrate water temperature sensor
[x, erms, exitflag, output] = fminsearch(@meanerror, x0, options, Tref, Tc)  %finding values of G1,G2,A1,A2 that keep erms at its minimum
G1 = x(1);
G2 = x(2);
O1 = x(3);
O2 = x(4);
figure(2);
plot([Tref - (G1*Tc + O1)./(G2*Tc + O2)]);


