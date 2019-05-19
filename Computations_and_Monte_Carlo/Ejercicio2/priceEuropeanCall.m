function price = priceEuropeanCall(S0,K,r,T,sigma)
%% priceEuropeanCall: Price a Eurpean Call using the Black Scholed Formula
%
%% SYNTAX:
%        price = priceEuropeanCall(S0,K,r,T,sigma)
%
%% INPUT:
%       S0 : Initial value of the underlying asset
%        K : Strike price of the option
%        r : Risk free intrest rate
%        T : Time to expiry 
%    sigma : Volatility 
%% OUTPUT:
%    price : Price of the European Call Option



discountedK = K.*exp(-r.*T);

totalVolatility = sigma.*sqrt(T);

d_plus = log(S0./discountedK)./totalVolatility + 0.5*totalVolatility;
d_minus = d_plus - totalVolatility;


price = S0.*normcdf(d_plus) - discountedK.*normcdf(d_minus);
end
