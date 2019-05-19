function vega = vegaDigital(S0,K,r,T,sigma,A)
% vegaDigital: vega de of a Digital europea
%% SYNTAX:
%       vega = vegaDigital(S0,K,r,T,sigma,A)
%
%% INPUT:
%       S0 : Initial value of the underlying asset
%        K : Strike price of the option
%        r : Risk free intrest rate
%        T : Time to expiry 
%   	 sigma : Volatility 
%        A : Payout
%% OUTPUT:
%    vega : vega of the Digital Option
%% Example:
% S0 = 100; r = 0.05; K = 90; T = 2; sigma = 0.4; A = 10;
% vegaDigital(S0,K,r,T,sigma,A)


payoff = @(ST)A*(ST>K); % payoff of a Digital option

%Define f as the price of an european option in function of sig (sigma)
%while keeping all the other values constant.
f = @(sig)priceEuropeanOption(S0,r,T,sig,payoff);

% h is the precision of the numerical derivative
% h is set bigger than usual to smooth out the final curve estimated
h = 1e-3;

%Vega calculated as the derivative of the call price with respect to sigma.
vega = numericalDerivative(f,sigma,h);