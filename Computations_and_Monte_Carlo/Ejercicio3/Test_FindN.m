clear
close all
clc


f = @(x)exp(x); a = 0; b = 3 ; TOL_ABS = 1e-8;

[Int_Value,NumIter] = fFindN(f,a,b,TOL_ABS);

disp(['The value of the integral is : ',num2str(Int_Value),newline,'The Absolute Tolerance is: ',num2str(TOL_ABS),newline,'The number of iterations needed is: ',num2str(NumIter)])