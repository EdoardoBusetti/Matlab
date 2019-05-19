function  price = priceEuropeanOption(S0,r,T,sigma,payoff)
%% priceEuropeanOption: Price of a European option in the Black-Scholes model
%
%% SYNTAX:
%        price = priceEuropeanOption(S0,r,T,sigma,payoff)
%
%% INPUT:
%       S0 : Initial value of the underlying asset
%        r : Risk-free interest rate 
%        T : Time to expiry 
%    sigma : Volatility 
%   payoff : Handle to the function of ST that specifies the payoff
%
%% OUTPUT:
%    price : Price of the option in the Black-Scholes model  
%
%% EXAMPLE:   
%S0 = 100; K = 90; r = 0.05; T = 2; sigma = 0.4;
%payoff = @(ST)(max(ST-K,0)); % payoff of a European call option
%price = priceEuropeanOption(S0,r,T,sigma,payoff);

%Creating the Final Value formula as a function of X (The Stock returns)
ST = @(x)(S0.*exp((r-(1/2).*sigma.^2).*T + sigma.*sqrt(T).*x));

%The integrando is given by the payoffs of the European Option multiplied
%by the probability density funcion of a Standard normal Distribution.
%(Under the hypothesis of standard normal returns)
integrando = @(x)(normpdf(x).*payoff(ST(x)));

R = 10; % R is equivalent to infinite for a N(0,1)

discount_factor = exp(-r*T);

%By setting RelTol lower than the default the program will be less computationaly
%efficient but it will give a more precise output
price = discount_factor.*integral(integrando,-R,R,'RelTol',1e-12,'ArrayValued',true);