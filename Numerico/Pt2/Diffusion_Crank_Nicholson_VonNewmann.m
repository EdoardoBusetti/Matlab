% test for the Crank Nicholson method to solve the diffusion equation using Von
% Newmann Boundary conditions
close all
clear;
clc

% Parameters to define the diffusion equation and the range in space and time
%       and to implement the Crank Nicholson Method

Lmax = 1;                 % Maximum length
Tmax = 1;                 % Maximum time 
D = 1;                    % Conductivivity of the material

Nt = 300;                 % Number of time steps
dt = Tmax/Nt;             % Time step
Nx = 300;                 % Number of space steps
dx = Lmax/Nx;             % Space step	
alpha = D*dt/(dx*dx);     % alpha parameter in the finite-difference implementation

%  Initial condition: the initial value of the u function
x = linspace(0,Lmax,Nx);
t = linspace(0,Tmax,Nt);

u = zeros(Nx,Nt);
u(:,1) = 1;  %  Space x Time -> (Nx x Nt)
%plot(x,u(:,1)) % Check the conditions

% Creating the initial matrices
% Right Matrix

% Left Matrix
ML_central =        diag(ones(1,Nx-1)*(2+2*alpha),0);
ML_right =          diag(ones(1,Nx-2)*(-alpha),1);
ML_left =           diag(ones(1,Nx-2)*(-alpha),-1);
Matrix_M_Left =     ML_left + ML_central + ML_right;

MR_central =        diag(ones(1,Nx-1)*(2-2*alpha),0);
MR_right =          diag(ones(1,Nx-2)*(alpha),1);
MR_left =           diag(ones(1,Nx-2)*(alpha),-1);
Matrix_M_Right =    MR_left + MR_central + MR_right;


%% Applying Von Newmann boundary conditions to the Matrices
% Left Matrix
Matrix_M_Left(1) =      Matrix_M_Left(1)             - alpha/(1+dx);
Matrix_M_Left(end) =    Matrix_M_Left(end)           - alpha/(1+dx);

% Right Matrix
Matrix_M_Right(1) =     Matrix_M_Right(1)            + alpha/(1+dx);
Matrix_M_Right(end) =   Matrix_M_Right(end)          + alpha/(1+dx);

%% Implementation of the Crank Nicholson method with Von Newmann boundaries

inverse_L = inv(Matrix_M_Left); % Inverting this matrix outise of the loop for efficiency

for j=1:Nt-1
    u(2:end,j+1) = (inverse_L)*(Matrix_M_Right)*u(2:end,j);
end
% Readjusting the vector and matrix to be Nx-1
u = u(2:end,:);
x = x(2:end);
