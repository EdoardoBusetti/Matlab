clc
clear
close



N = 100000;
t0 = 0;
T = 50;
dt = (T-t0)/N;

p0 = 0.01; % Percentage of Hipsters in the population at time 0
r = 0.1; % Percentage of people born Hipster from couples with at least 1 non Hipsters parent
b = 0.02; %Birth rate


P = [p0 zeros(1,N)];
t = [t0 zeros(1,N)];

%% 4th Order Runge - Kutta Method 

for n = 1 : N
    k1 = r*b*(1-P(n))*dt; 
    P_midstep_1 = P(n) + k1/2; 
    
    k2 = r*b*(1-P_midstep_1)*dt; 
    P_midstep_2 = P(n) + k2/2;
    
    k3 = r*b*(1-P_midstep_2)*dt; 
    P_midstep_3 = P(n) + k3;
    
    k4 = r*b*(1-P_midstep_3)*dt; 
    
    P(n+1) = P(n) + (1/6)*(k1 + 2*k2 + 2*k3 + k4);
    t(n+1)=t(n)+dt;
end








P = P(2:end);
t = t(1:end-1);


Percentage_Hipsters_Time50 = P(end);
plot(t,P)
hold on
plot(t(end),P(end),"r*","LineWidth",3);
hold off
title('Evolution of the percentage of Hipsters in a Population - 4th Order Runge Kutta Method')
xlabel('Time (in periods)')
ylabel('Percentage of Hipsters at time t')

fprintf('Percentage of Hipsters after 50 periods (Using 4th Order Runge - Kutta Method):  %.9f Percent \n',Percentage_Hipsters_Time50)

%% Error of the numerical solution
p_analytical = 0.1042109561444000; %Analytical solution for p
error = abs(Percentage_Hipsters_Time50-p_analytical);
fprintf('The error of the estimation is %.16f \n',error)