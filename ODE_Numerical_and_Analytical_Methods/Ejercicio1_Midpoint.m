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

%% Midpoint Method

%initialization value

X_minus1 = x_0 - dt*(-0.6*pi*r^2*sqrt(2*g)*sqrt(X(1))/A(X(1)));

X = [X_minus1 X];

for n = 2 : N+1
    X(n+1) = X(n-1) + 2*dt*(-0.6*pi*r^2*sqrt(2*g)*sqrt(X(n))/A(X(n)));
    t(n+1)=t(n)+dt;
end

X = X(2:end);
t = t(1:end-1);

Water_Level_T = X(end);
plot(t,X)
hold on
plot(t(end),X(end),"r*","LineWidth",3);
hold off
title('Water dripping out of a cone - Midpoint Method')
xlabel('Time (in seconds)')
ylabel('Water level (in meters)')

fprintf('Water lever after 10 minutes (Using Midpoint Method):  %.9f Meters \n',Water_Level_T)

%% Error of the numerical solution
x_analytical = 2.1489055841903624; %Analytical solution for x
error = abs(Water_Level_T-x_analytical);
fprintf('The error of the estimation is %.16f \n',error)