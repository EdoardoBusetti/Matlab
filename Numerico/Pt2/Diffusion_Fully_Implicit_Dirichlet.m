% test for the fully implicit method to solve the diffusion equation using 
% Dirichelet conditions
close all
clear
clc

% Parameters to define the diffusion equation and the range in space and time
%       and to implement the fully implicit Method


Smax = 20;          % Maximum value considered for the underlying asset
Tmax = 1;        	% Maximum time 
E = 10;             % Strike price of the option
sigma = 0.2;        % Volatility of the underlying asset
payoff = 1;         % Payoff of the option

Nt = 5000;               % Number of time steps
dt = Tmax/Nt;             % Time step
Nx = 200;                 % Number of space steps
dx = Smax/Nx;             % Space step	

% defining D and alpha as a function of S
D = @(S)0.5*sigma*S.^2;
falpha = @(S)D(S)*dt/(dx*dx);     % alpha parameter in the finite-difference implementation

%%  Intializing variables for the later implementation
S = linspace(0,Smax,Nx+1);
tau = linspace(0,Tmax,Nt);
V = zeros(Nx+1,Nt); % Space x Time -> (Nx x Nt)

%% Initial conditions
V(:,1) = (S > E)*payoff;
%plot(S,u(:,1)) % Check the initial conditions


alpha_vec = falpha(S(2:end-1));
alpha_vec = alpha_vec';
%% Implementation of the Fully implicit method with Dirichlet boundaries

M_left = diag(ones(Nx-2,1).*(-alpha_vec(2:end)),-1);
M_right = diag(ones(Nx-2,1).*(-alpha_vec(1:end-1)),1);
M_center = diag(ones(Nx-1,1).*(1+ 2*alpha_vec),0);
M_Matrix = M_left + M_right + M_center;

inverse = inv(M_Matrix); % For efficiency we invert the matrix outside of the loop
for j=1:Nt
    V(2:end-1,j+1) = (inverse)*V(2:end-1,j);
    
    % Dirchlet boundary (only needed for V(end-1) because V(1) = 0;
    V(end-1,j+1) = V(end-1,j+1) + alpha_vec(end)*1;
end

% Readjusting the vector and matrix to be Nx-1
V = V(2:end-2,:);
S = S(2:end-2);
t = 0:dt:Tmax;