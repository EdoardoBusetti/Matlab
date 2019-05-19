 function gamma = gammaCallEU(h,S0,K,r,T,sigma)
% gammaCallEU: gamma de una call europea
%
%% SYNTAX:
%       gamma = gammaCallEU(h,S0,K,r,T,sigma)
%
%% INPUT:
%       S0 : Initial value of the underlying asset
%        K : Strike price of the option
%        r : Risk free intrest rate
%        T : Time to expiry 
%   	 sigma : Volatility 
%        h : Sensibility of the numerical derivative
%% OUTPUT:
%    gamma : gamma of the European Call Option
%
%% EJEMPLO 1:
%  S0 = 100; K = 90; r = 0.03; T = 2; sigma = 0.4;
%  h = 1e-4;
%  gamma = gammaCallEU(h,S0,K,r,T,sigma)
%  blsgamma(S0,K,r,T,sigma)

             

           
%Define f as the price of an european option in function of price
%while keeping all the other values constant.
f = @(price_undelying)priceEuropeanCall(price_undelying,K,r,T,sigma);

%gamma calculated as the second order derivative of the call price with respect to price.
% using the formula derivated in the fist part of this exercise.
gamma = (f(S0*(1+h)) + f(S0*(1-h)) - 2*f(S0))/((h*S0)^2);