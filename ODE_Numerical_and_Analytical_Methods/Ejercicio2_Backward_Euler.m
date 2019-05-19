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

%% Backward Euler
for n = 1:N
    %dp = r*b*(1-P(n))*dt;
    P(n+1) = ((P(n)+0.002*dt)/(1+0.002*dt));
    t(n+1)=t(n)+dt;
end

Percentage_Hipsters_Time50 = P(end);
plot(t,P)
hold on
plot(t(end),P(end),"r*","LineWidth",3);
hold off
title('Evolution of the percentage of Hipsters in a Population - Backward Euler')
xlabel('Time (in periods)')
ylabel('Percentage of Hipsters at time t')

fprintf('Percentage of Hipsters after 50 periods (Using Forward Euler):  %.9f Percent \n',Percentage_Hipsters_Time50)
