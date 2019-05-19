function [sigm, nIter, error] = impliedVolatility_WithIterations(fPrice,fVega,price)
% impliedVolatility: Implied volatility of a derivative
%
% SYNTAX:
%       sigma = impliedVolatility_WithIterations(fPrice,fVega,price)
%
% INPUT:
%    fPrice : Handle to the function that gives the price of the derivative
%     fVega : Handle to the function that gives the vega of the derivative
%     price : The price of the derivative
%
% OUTPUT:
%     sigma : Implied volatility
%     nIter : The number of iterations needed for the convergence
%     error : The error of the estimation, as the difference between the
%     real price and the price at the calculated Implied Volatility
%
% EXAMPLE:   
%        S0 = 100; K = 90; r = 0.05; T = 2;
%        price = 19.8701;
%        fPrice = @(sigma)(priceEuropeanCall(S0,K,r,T,sigma));
%        fVega  = @(sigma)(vegaEuropeanCall(S0,K,r,T,sigma));
%        ImpliedSigma  = impliedVolatility(fPrice,fVega,price)
%        Price = priceEuropeanCall(S0,K,r,T,impliedSigma)  % should be equal to price    
%        Error = Price-price
 
%Setting the absolute tollerance to power(10,-8)
TOLABS  = 1e-8;

%The maximum number of iterations -> To prevent stuck loop.
MAXITER = 100;
 
sigm  = 0.3;         % intial estimate    %Seed Value
dSigma = 10*TOLABS;   % enter loop for the first time % the difference between sigma t-1 and sigma t
nIter  = 0;           %Counter of the number of iterations.


%Newton - Raphson implementation
while (nIter < MAXITER && abs(dSigma) > TOLABS) %Always set a max number of iterations.
    nIter = nIter + 1; %Always count the number of iterations.
    dSigma = (fPrice(sigm) - price)/fVega(sigm);
    sigm = (sigm - dSigma);
end
error = abs(dSigma);
%If the loop reaches the max number of iterations then it sends a warning
%telling that it failed to converge.
if (nIter == MAXITER)
    warning('Newton-Raphson not converged')
end
