function [gamma_MC,err_MC] = gammaCallEU_MC(M,S0,K,r,T,sigma,Delta_x)

% deltaCallEU_MC: delta de una call europea mediante MC
%
%% SYNTAX:
%       [gamma_MC,err_MC] = gammaCallEU_MC(M,S0,K,r,T,sigma,Delta_x)
%
%% INPUT:
%       S0 : Initial value of the underlying asset
%        K : Strike price of the option
%        r : Risk free intrest rate
%        T : Time to expiry 
%   	 sigma : Volatility 
%        Delta_x : Sensibility of the numerical derivative
%        M : Number of simulations
%
%% OUTPUT:
%    gamma_MC : gamma of the European Call Option estimated via Monte Carlo
%    err_MC : Error of the Monte Carlo estimation
%
%% EJEMPLO 1:
%  S0 = 100; K = 90; r = 0.03; T = 2; sigma = 0.4;
%  M = 1e6;
%  [gamma_MC,err_MC] = gammaCallEU_MC(M,S0,K,r,T,sigma)
%  h = 1e-4;
%  gammaCallEU(h,S0,K,r,T,sigma)
%  blsgamma(S0,K,r,T,sigma)
 
if ~exist('Delta_x','var')
     % third parameter does not exist, so default it to something
     %Value of Delta_x that minimizes the error
      Delta_x = 10;
 end

%% generate M samples from N(0,1)
X = randn(M,1);

%% Set the value for Delta_x -> Not needed here
%Delta_x = 1;

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
ST = (S0)*exp((r-(sigma^2)/2)*T+TotalVolatitily);

%% define minus / plus payoffs
payoffs_plus = max(ST_plus-K,0);
payoffs_minus = max(ST_minus-K,0);
payoffs = max(ST-K,0);

%% compute Delta along each trajectory
discountFactor = exp(-r.*T);
%Applying the divided difference formula on the discounted payoffs
Prices_plus = payoffs_plus*discountFactor;
Prices_minus = payoffs_minus*discountFactor;
Prices = payoffs*discountFactor;

gamma_vector = (Prices_plus + Prices_minus - 2*Prices)/((Delta_x)^2);

var = sum((gamma_vector - blsgamma(S0,K,r,T,sigma)).^2)/(M-1);
%% MC estimate
%The Monte Carlo Gamma is the mean of the Gamma in each simulated scenario
gamma_MC = mean(gamma_vector);
%err_MC = std(gamma_vector)/sqrt(M);
err_MC = sqrt(var)/sqrt(M);