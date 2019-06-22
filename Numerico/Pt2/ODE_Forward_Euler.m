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

%% Forward Euler
for n = 1:N
    dx =(-0.6*pi*r^2*sqrt(2*g)*sqrt(X(n))/A(X(n)))*dt;
    X(n+1) = X(n) + dx;
    t(n+1)=t(n)+dt;
end


Water_Level_T = X(end);
plot(t,X)
hold on 
scatter(t(end),X(end),'LineWidth',5)
title('Water dripping out of a cone - Forward Euler')
xlabel('Time (in seconds)')
ylabel('Water level (in meters)')

fprintf('Water lever after 10 minutes (Using Forward Euler):  %.16f Meters \n',Water_Level_T)

%% Error of the numerical solution
x_analytical = 2.1489055841903624; %Analytical solution for x
error = abs(Water_Level_T-x_analytical);
fprintf('The error of the estimation is %.16f \n',error)