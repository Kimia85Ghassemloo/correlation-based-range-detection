clc;
clear;
ts = 1e-9;
T = 1e-5;
tau = 1e-6;
fs = 1/ts;
t = 0:ts:T;
N_tau = length(0:ts:tau);
t_length = length(t);

x = zeros(1,t_length);
x(1:N_tau) = ones(1,N_tau);

%C = physconst('LightSpeed');
C = 3e8;
R = 450;
td = 2*R/C;
N_td = length(0:ts:td);
y = zeros(1,t_length);
alfa = 0.1;
y(N_td:N_td+N_tau-1) = alfa;

sigma = 0:0.1:1;
safePoint = 0;
meanError = zeros(1,length(sigma));
for i = 1:11
    meanError(i) = CalcMeanError(sigma(i), y);
    if meanError(i)<=10
        safePoint = sigma(i);
    end
end
figure
plot(sigma,meanError);
disp(safePoint);



