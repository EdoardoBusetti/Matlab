function [delta_MC,err_MC] = deltaCallEU_MC(M,S0,K,r,T,sigma)

%% deltaCallEU_MC: delta de una call europea mediante MC
%
%% SYNTAX:
%       [delta_MC,err_MC] = deltaCallEU_MC(M,S0,K,r,T,sigma)
%
%% INPUT:
%       S0 : Initial value of the underlying asset
%        K : Strike price of the option
%        r : Risk free intrest rate
%        T : Time to expiry 
%   	 sigma : Volatility 
%        h : Sensibility of the numerical derivative
%        M : Number of simulations
%
%% OUTPUT:
%    delta_MC : Delta of the European Call Option estimated via Monte Carlo
%    err_MC : Error of the Monte Carlo estimation
%
% EJEMPLO 1:
%  S0 = 100; K = 90; r = 0.03; T = 2; sigma = 0.4;
%  M = 1e7;
%  [delta_MC,err_MC] = deltaCallEU_MC(M,S0,K,r,T,sigma)
%  h = 1e-5;
%  deltaCallEU(h,S0,K,r,T,sigma)
%  blsdelta(S0,K,r,T,sigma)

%% generate M samples from N(0,1)
X = randn(M,1);

%% Set the value for Delta_x
Delta_x = 1e-4;

%% simulate M minus / plus trajectories in one step
S0_plus = S0+Delta_x;
S0_minus = S0-Delta_x;
%We simulate the paths that the asset would take in the case the underlying
%price was S0_plus and in the case it was S0_minus so that we can then
%apply the Divided Differences method for each simulated scenario

%% Calculate the M trajectories for S0_plus and S0_minus

TotalVolatitily = sigma*sqrt(T);
%Randomizing the Total Volatility to create M independent paths
TotalVolatitily = TotalVolatitily*X;

ST_plus = (S0_plus)*exp((r-(sigma^2)/2)*T+TotalVolatitily);
ST_minus = (S0_minus)*exp((r-(sigma^2)/2)*T+TotalVolatitily);

%% define minus / plus payoffs
payoffs_plus = max(ST_plus-K,0);
payoffs_minus = max(ST_minus-K,0);

%% compute Delta along each trajectory
discountFactor = exp(-r.*T);
%Applying the divided difference formula on the discounted payoffs (i.e. the prices)
delta_vector = (payoffs_plus*discountFactor - payoffs_minus*discountFactor)/(2*Delta_x);
%The variance is given by (∑(g(X_m)-⟨g(X)⟩_M )^2)/(M-1)
Standard_dev = std(delta_vector);
%% MC estimate
%The Monte Carlo Delta is the mean of the delta in each simulated scenario
delta_MC = mean(delta_vector);
%The error of the estimation is given by the std divided by sqrt(M)
err_MC = Standard_dev/sqrt(M);