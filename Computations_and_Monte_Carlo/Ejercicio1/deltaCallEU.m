function delta = deltaCallEU(h,S0,K,r,T,sigma)

%% deltaCallEU: delta de una call europea
%
%% SYNTAX:
%       delta = deltaCallEU(h,S0,K,r,T,sigma)
%
%% INPUT:
%       S0 : Initial value of the underlying asset
%        K : Strike price of the option
%        r : Risk free intrest rate
%        T : Time to expiry 
%   	 sigma : Volatility 
%        h : Sensibility of the numerical derivative
%% OUTPUT:
%    delta : Delta of the European Call Option
%
%%  EJEMPLO 1:
%  S0 = 100; K = 90; r = 0.03; T = 2; sigma = 0.4;
%  h = 1e-5;
%  delta = deltaCallEU(h,S0,K,r,T,sigma)
%  blsdelta(S0,K,r,T,sigma)
             
             

%Define f as the price of an european option in function of price
%while keeping all the other values constant.
f = @(price_undelying)priceEuropeanCall(price_undelying,K,r,T,sigma);

%Delta calculated as the derivative of the call price with respect to price.
delta = numericalDerivative(f,S0,h);