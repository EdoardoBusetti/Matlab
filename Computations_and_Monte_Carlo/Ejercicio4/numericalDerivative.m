function  derivative = numericalDerivative(f,x0,h)
% numericDerivative: Numerical estimate of the derivative of f at x0
%
% SYNTAX:
%        derivative = numericalDerivative(f,x0,h)
%
% INPUT:
%            f : Handle to the function whose derivative is being calculated
%           x0 : Point at which the derivative is calculated
%            h : Parameter for divided differences (1e-5 - 1e-6)
%
% OUTPUT:
%   derivative : Value of the derivative of f at x0  
%
% EXAMPLE:   
%            format short e
%            N = 13; h = logspace(-N,-1,N);
%            log10(h);
%            log10_error_sin = log10(abs(1-numericalDerivative(@sin,2*pi,h)));
%            log10_error_exp = log10(abs(1-numericalDerivative(@exp,0,h)));
%            subplot(2,1,1);
%            plot(log10(h),log10_error_sin)
%            title('sin Function error for h that goes from 1e-1 to 1e-13')
%            ylabel('Error')
%            xlabel('log10(h)')
%            subplot(2,1,2);
%            plot(log10(h),log10_error_exp)
%            title('exp Function error for h that goes from 1e-1 to 1e-13')
%            ylabel('Error')
%            xlabel('log10(h)')

if x0 == 0
    derivative = (f(h) - f(-h))./(2*h);
else
    %We use this formula beacuse this way the relative error is constant,
    %since h is always summed to 1 and not to x0 like it would be in a
    %different implementation of the numerical derivative.
    derivative = (f(x0*(1+h))-f(x0*(1-h)))./(2*h*x0);
end   
