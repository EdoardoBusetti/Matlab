clc
clear
close

N = 100000;
t0 = 0;
T = 600; %seconds
dt = (T-t0)/N;

x_0 = 2.5; %m
r = 0.03; %m
r_0 = 2.6833; %m
tg_alpha = r_0/x_0;
rx = @(x)tg_alpha * x;
g = 9.8; %m / sec^2
A =@(x)(rx(x).^2)*pi;

X = [x_0 zeros(1,N)];
t = [t0 zeros(1,N)];

%% 4th Order Runge-Kutta Method

% y_(i+1) = y_i + 1/6 * (k1 + 2k2 + 2k3 + k4) + O(dt^5)
% k1 = dt * f(t_i , y_i)
% k2 = dt * f(t_i + dt/2 , y_i + k1/2)
% k3 = dt * f(t_i + dt/2 , y_i + k2/2)
% k4 = dt * f(t_i + dt , y_i + k3)

for n = 1 : N
    k1 = (-0.6*pi*r^2*sqrt(2*g)*sqrt(X(n))/A(X(n)))*dt; 
    X_midstep_1 = X(n) + k1/2; 
    
    k2 = -0.6*pi*r^2*sqrt(2*g)*sqrt(X_midstep_1)/A(X_midstep_1)*dt; 
    X_midstep_2 = X(n) + k2/2;
    
    k3 = -0.6*pi*r^2*sqrt(2*g)*sqrt(X_midstep_2)/A(X_midstep_2)*dt;
    X_midstep_3 = X(n) + k3;
    
    k4 = -0.6*pi*r^2*sqrt(2*g)*sqrt(X_midstep_3)/A(X_midstep_3)*dt;
    
    X(n+1) = X(n) + (1/6)*(k1 + 2*k2 + 2*k3 + k4);
    t(n+1)=t(n)+dt;
end

X = X(2:end);
t = t(1:end-1);

Water_Level_T = X(end);
plot(t,X)
hold on
plot(t(end),X(end),"r*","LineWidth",3);
hold off
title('Water dripping out of a cone - 4th Order Runge Kutta Method')
xlabel('Time (in seconds)')
ylabel('Water level (in meters)')

fprintf('Water lever after 10 minutes (4th Order Runge Kutta Method):  %.16f Meters \n',Water_Level_T)

%% Error of the numerical solution
x_analytical = 2.1489055841903624; %Analytical solution for x
error = abs(Water_Level_T-x_analytical);
fprintf('The error of the estimation is %.16f \n',error)