clc
close all
clear


p = 1 -exp(-1* ( 0.002*50 - log(1-0.01)));

fprintf('Analytical Solution for p: %.16f \n',p)