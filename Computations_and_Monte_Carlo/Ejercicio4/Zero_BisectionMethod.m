function [Midpoint, Estimation_Error, NumerOfIterations] = Zero_BisectionMethod (f,a,b)

% Zero_BisectionMethod: Finds the zero af a function given that f(a)*f(b)<0
%
% SYNTAX:
%       [Midpoint, Estimation_Error, NumerOfIterations] = Zero_BisectionMethod (f,a,b)
%
% INPUT:
%      f : Handle to the function that we want the zero of
%     a : lower bound of the interval
%     b : higher bound of the interval
%
% OUTPUT:
%     Midpoint : Implied volatility
%     NumerOfIterations : The number of iterations needed for the convergence
%     Estimation_Error : The error of the estimation
%
%% 


% Check if the function gives changes sign at the extremes of the given
% interval
    if f(a) * f(b) > 0
        warning('The function might not have a zero')
        return
    end
    
Estimation_Error = b-a;
Midpoint = (a+b)/2;
NumerOfIterations = 0;
TOL_ABS = 1e-8;
%Finds a point closer than TOL_ABS to the zero of the given function
while Estimation_Error > TOL_ABS
    NumerOfIterations = NumerOfIterations +1;
    Midpoint = (a+b)/2;
    Estimation_Error = Estimation_Error/2;
    if f(a)*f(Midpoint) < 0
        b = Midpoint;
    else
        a = Midpoint;
    end
end
