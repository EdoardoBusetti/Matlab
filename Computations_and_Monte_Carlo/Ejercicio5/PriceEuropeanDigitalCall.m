function  price = PriceEuropeanDigitalCall(S0,r,T,sigma,K,A)
%% PriceEuropeanDigitalCall: Price of a European Digital call option
%
%% SYNTAX:
%        price = PriceEuropeanDigitalCall(S0,r,T,sigma,K,A)
%
%% INPUT:
%       S0 : Initial value of the underlying asset
%        r : Risk-free interest rate 
%        T : Time to expiry 
%    sigma : Volatility 
%        K : Strike Price
%        A : Payout given if the option gets excerced
% 
%
%
%% EXAMPLE:   
%         S0 = 100; K = 90; r = 0.05; T = 2; sigma = 0.4; K = 80; A = 10;
%        price = PriceEuropeanDigitalCall(S0,r,T,sigma,K,A)
%   
%% Alternative Number 1:
%External Function Method
%payoff = payoff_digital_call(ST,K,A);

%% Alternative Number 2:
%In Line Function Method
payoff = @(ST)A*(ST > K);

%% Calling the priceEuropeanOption function with the Digital Call Payoff function.
price = priceEuropeanOption(S0,r,T,sigma,payoff);