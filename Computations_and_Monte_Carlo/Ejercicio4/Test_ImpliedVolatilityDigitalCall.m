clc
close
clear

%% Estimating the implied volatility of  a Digital Optiin by finding the zero of a function in an interval
%We try 3 different methods of finding the implied volatility to check
%which one is more efficient and more precise (Bisecion Method - Newton Raphson - Matlab fzero)



%% Data for the example
S0 = 100; r = 0.1; price = 7.81; K = 90; A = 10; T = 2;


%% Functions needed for the Bisection MEthod implementation
%Payoff function of a digital
payoff_Digital = @(ST)A*(ST > K);


%Function Handle: Price of an digital option as a function of Sigma - the price of that option.
fPrice_minus_price = @(sigma)(priceEuropeanOption(S0,r,T,sigma,payoff_Digital)- price);

%% Functions needed for the Newton-Raphson implementation
fVega = @(sig)vegaDigital(S0,K,r,T,sig,A);
fPrice_Sigma = @(sigm)priceEuropeanOption(S0,r,T,sigm,payoff_Digital);



%%
%% Bisection method Results
tic;
%Doing the test 50 times for each method to reduce the variance of the Time to convergence results
for i=1:50
[IV_BM, Error_BM, NIter_BM] = Zero_BisectionMethod(fPrice_minus_price,0,10);
end
time = toc;
disp (['The estimated implied Volatility using the Bisection Method is: ',num2str(IV_BM),newline,'The Error of the estimation is: ', num2str(Error_BM),newline,'The number of iterations needed until convergence is: ', num2str(NIter_BM),newline,'The time to convergence is: ',num2str(time),newline,newline]);



%% Newton-Raphson Results
tic;
for i=1:50
[IV_NR , Niter_NR , Error_NR] = impliedVolatility_WithIterations(fPrice_Sigma,fVega,price);
end
time = toc;
disp(['The estimated implied Volatility using Newton-Raphson is: ',num2str(abs(IV_NR)),newline,'The Error of the estimation is: ', num2str(Error_NR),newline,'The number of iterations needed until convergence is: ', num2str(Niter_NR),newline,'The time to convergence is: ',num2str(time),newline,newline]);

%% fzero implementation
tic;
for i=1:50
[IV_fzero,Error_NR] = fzero(fPrice_minus_price,0);
end
time = toc;
disp(['The estimated implied Volatility using fzero is: ',num2str(abs(IV_fzero)),newline,'The Error of the estimation is: ', num2str(Error_NR),newline,'The time to convergence is: ',num2str(time)]);

%The result obteined with the function fzero is not only more efficient but
%also it returns a smaller error than both the Bisection Method and the
%Newton-Raphson method.