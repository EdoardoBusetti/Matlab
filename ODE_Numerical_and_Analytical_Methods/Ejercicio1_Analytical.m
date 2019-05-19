clc
clear
close all

x_0 = 2.5; %m
r = 0.03; %m
V_0 = 6*pi; %m^3
r_0 = 2.6833; %m
tg_alpha = r_0/x_0;
g = 9.8; %m / sec^2

Integrando_x = @(x) x^(3/2);
Integrando_t = -0.6*(0.03^2)*sqrt(2*g)/(tg_alpha^2);

Integral_t = Integrando_t*600;

x = (Integral_t/0.4 + 2.5^(5/2))^(2/5);
fprintf('Analytical Solution for X %.16f \n',x)