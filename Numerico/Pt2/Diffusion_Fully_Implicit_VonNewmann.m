% test for the fully implicit method to solve a diffusion equation
close all
clear
clc

% Parameters to define the heat equation and the range in space and time

Smax = 1;           % Maximum length
Tmax = 3;        	% Maximum time 
D = 1;              % Conductivivity of the material

%  Parameters needed to implement the fully implicit method
Nt = 300;                 % Number of time steps
dt = Tmax/Nt;             % Time step
NS = 300;                 % Number of space steps
dS = Smax/NS;             % Space step	
alpha = D*dt/(dS*dS);     % alpha parameter in the finite-difference implementation
fprintf('This Method is always stable\n')

S = linspace(0,Smax,NS);
t = linspace(0,Tmax,Nt);

V = zeros(NS,Nt);
V(:,1) = 1;  % u-> Space x Time -> (Nx x Nt)
%plot(x,u(:,1)) % Check the conditions

% Creating the initial matrix
M_central = diag(ones(1,NS-1)*(1+2*alpha),0);
M_right = diag(ones(1,NS-2)*(-alpha),1);
M_left = diag(ones(1,NS-2)*(-alpha),-1);
Matrix_M = M_left + M_central + M_right;

%% Applying Von Newmann boundary conditions to the Matrix
Matrix_M(1)   = Matrix_M(1)   -alpha/(1+dS);
Matrix_M(end) = Matrix_M(end) - alpha/(1+dS);

%% Implementation of the FTCS implicit method
for j=1:Nt-1
    V(2:end,j+1) = (inv(Matrix_M))*V(2:end,j);
end
% Readjusting the vector and matrix to be Nx-1
V = V(2:end,:);
S = S(2:end);
