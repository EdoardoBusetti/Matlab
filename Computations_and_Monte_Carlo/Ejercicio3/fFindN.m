function [Int,N] = fFindN(f,a,b,TOL_ABS)


realInt = integral(f,a,b,'AbsTol',1e-16);

N = 1;
error = 1;
while error > TOL_ABS
    N = N+1;
    Int = IntegralDefinida_1(f,a,b,N);
    error = abs(Int - realInt);
end