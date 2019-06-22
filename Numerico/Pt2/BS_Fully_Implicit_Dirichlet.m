function price = BS_Fully_Implicit(S0, E, r, T, sigma,d)

% Parameters of the problem:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r_q = (r - d);      % Intrest rate net from dividends
Nt=5500;			% Number of time steps
Ns=200;				% Number of asset price steps
Smax=17;			% Maximum asset price considered
Smin=0;				% Minimum asset price considered
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Dt=(T/Nt);			% Time step
Ds=(Smax-Smin)/Ns;	% Price step
 
% Initializing the matrix of the option value
V = zeros(Ns+1,Nt+1);

% Discretization of asset (S) and tau (tau=T-t) variables
S=Smin+(0:Ns)*Ds;
tau=(0:Nt)*Dt;

% Initial conditions prescribed by the Put option payoff at expiry:
V(:,1)=max(E-S,0);

% Boundary conditions prescribed by the Put option:
V(1,:)=(E)*exp(-r_q*tau);                                    
V(end,:)= 0;

% Defining the matrix for the fully implicit method
aal(1:Ns-2) = 0.5*(r_q*(2:Ns-1)-sigma^2*(2:Ns-1).^2)*Dt;              % Below the main diagonal in MMl
bbl(1:Ns-1) = 1+(sigma^2*(1:Ns-1).^2+r)*Dt;                         % The main diagonal in MMl
ccl(1:Ns-2) = -0.5*(sigma^2*(1:Ns-2).^2+r_q*(1:Ns-2))*Dt;             % Above the main diagonal in MMl
MMl=diag(bbl,0)+diag(aal,-1)+diag(ccl,1);                           % Building the MMl matrix

invMML = inv(MMl);
%  Implementation of the fully implicit method
for j = 1:Nt
    rl = zeros(Ns-1,1);                                             % Initializing the r column vector for the implicit method
    rl(1,1) = 0.5*(-sigma^2*(1).^2+r_q*1)*Dt*V(1,j+1);              % Implementing boundary conditions in the r column vector
    V(2:Ns,j+1) = (invMML)*(V(2:Ns,j)-rl);
end
%% Finding the price of the option in t0
price = interp1(S(:),V(:,end),S0);

