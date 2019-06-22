function price = BS_Explicit_FTCS(S0, E, r, T, sigma,d)
% Parameters of the problem:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r_q = (r - d);      % Intrest rate net from dividends
Nt=28000;			% Number of time steps
Ns=450;				% Number of asset price steps
Smax=17;			% Maximum asset price considered
Smin=0;				% Minimum asset price considered
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dt=(T/Nt);			% Time step
ds=(Smax-Smin)/Ns;	% Price step
% Initializing the matrix of the option value
V = zeros(Ns+1,Nt+1);
% Discretization of asset (S) and tau (tau=T-t) variables
S=Smin+(0:Ns)*ds;
tau=(0:Nt)*dt;
% Initial conditions prescribed by the European Call payoff at expiry: V(S,tau=0)=max(S-E,0)
V(:,1)=max(E-S,0);
% Boundary conditions prescribed by the European Put:
V(1,:)= E*exp(-r*tau) - 0;                             
V(end,:)= 0;            
% Implementing the explicit algorithm
for j=1:Nt              % Time  loop
    for n=2:Ns          % Asset loop
        V(n,j+1)=   0.5*dt*(sigma*sigma*n*n-r_q*n)*  V(n-1,j)+(1-dt*(sigma*sigma*n*n+r))*  V(n,j)+0.5*dt*(sigma*sigma*n*n+r_q*n)*  V(n+1,j);
    end
end
%% Finding the price of the option in t0
price = interp1(S(:),V(:,end),S0);
