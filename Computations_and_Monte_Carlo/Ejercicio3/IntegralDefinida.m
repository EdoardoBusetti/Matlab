function [Int] = IntegralDefinida(f,a,b,N)

h = (b-a)/N;

Int = (f(a)/2 + sum(f(a+(1:N)*h)) + f(b)/2)*h;
end
