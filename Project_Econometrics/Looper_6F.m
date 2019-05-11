close
clear
clc

%Loading the data into matlab
load Momentum.txt
load Fattori5.txt
load Average_Value_Weighted_Returns

%Defining the variables:
%Since we have limited data for the 5 factors we can oly use data from the
%07/1963 to the 02/2019
Timestamps = Fattori5(end-667:end,1);
Mkt_RF = Fattori5(end-667:end,2);
SMB = Fattori5(end-667:end,3);
HML = Fattori5(end-667:end,4);
RMW = Fattori5(end-667:end,5);
CMA= Fattori5(end-667:end,6);
RF= Fattori5(end-667:end,7);
MOM = Momentum(end-667:end,2);



%Defining the matrix X_all of all the factors in the order (Mkt-RF  SMB  HML MOM)
X_all = [Mkt_RF, SMB, HML, MOM, RMW, CMA];


%Removing the timestamp from the Returns
Average_Value_Weighted_Returns = Average_Value_Weighted_Returns(:,2:26);

%Number of portfolios
Np = size(Average_Value_Weighted_Returns,2);

%Number of periods
T = size(Timestamps,1);

%Total number of Factors
Nf = size(X_all,2);


%Defining the variable "Y" as the variable containing the extra-returns from all the portfolios

Y = zeros(T,Np);

for i=1:Np
    Y(:,i) = Average_Value_Weighted_Returns(end-667:end,i) - RF;
end;

%===================================================================================
%===================================================================================
%===================================================================================

%Estimating an OLS model for each factor

%The size of each window will be 60 periods
WindowSize = 60;

%The total number of windows
NumWindows = T- WindowSize;

%Reformatting the timestamp into Dates
for i=1:NumWindows
    Dates(i) = datetime(num2str(Timestamps(i+WindowSize)),'InputFormat','yyyyMM','Format','MM/yyyy');
end


%We will have as the result a 3-Dimensional matrix
%The first dimension is for the number of windows that will be considered
%The second dimension is for the number of portfolios considered 
%The third dimension is for the number of factors considered
%The elements in the matrix will be the betas of the regression, we will
%not save the constant term(alpha) since we don't need it.
Theta = zeros(NumWindows,Np,Nf);

% j will be the variable that loops trough each factor
for j=1:Nf
    %We define the matrix X as a matrix with a column of ones and a column
    %with the factor "j"
    X = [ones(T,1),X_all(:,j)];
    
    % i is the variable that loops through time to build the windows
    for i=1:NumWindows
        %Building the windows taking all the colums but only the rows from
        %i to i+59 (That is only 60 months)
        Xwindow = X(i:i+(WindowSize-1),:);
        Ywindow = Y(i:i+(WindowSize-1),:);
        
        % k is the variable that loops thourgh the 25 different portfolios
        for k=1:Np
            
            %This estimates the coefficients (Alpha and Beta) for the
            %factor j,the window i and the portfolio k
            coefficients = (Xwindow'*Xwindow)^(-1)*(Xwindow'*Ywindow(:,k));
            Theta(i,k,j) = coefficients(2);
            %This saves only the Beta coefficient to the slot (i,k,j) of
            %the Theta matrix
            %{
            Example:
            If I'm at the time t=80 (that is the window number 20 (80-60)) of the third portfolio and the second
            factor(SMB) then:
            
            j = 2 (Second Factor -> SMB)
            i = 20 (The window number 20)
            k = 3 (Third portfolio)
            
            The variable coeffients will contain [Alpha_jik   Beta_jik]
            
            Theta(i,k,j) will save only the Bete_jik in the slot (i,k,j) of
            the 3-Dimensional matrix Theta.
            
            %}
        end
    end
end

%Cleaning Up some useless variables
%clearvars Average_Value_Weighted_Returns HML MOM Mkt_RF Momentum RF SMB Timestamps X X3_fattori Xwindow Ywindow coefficients i j k

%===================================================================================
%===================================================================================
%===================================================================================
                                %Part 2
                                
%Doing OLS to regress NumWindows linear models where in each we use the
%extra-returns from the 25 portfolios as the dependent variable and we use
% all the betas from the 6 considered factors as regressors

%Deleting the first 60 observations for Y, that is because we don't have
%parameters(Beta) for them.

Y = Y((WindowSize+1):T,:);
%Transposing Y so that we have 25 rows and NumWindows colums
Y = Y';

Gamma = zeros(NumWindows,Nf +1);

for i=1:NumWindows
    %the new dependent variable will be a vector (25x1) with the 25 extra-returns
    %for the window i
    Y_new = Y(:,i);
    
    %The new indipendent variables wil be a (25x4) matrix with all the factors
    % for each porfolio considered  
    %adding a column of ones to X_new for the constant term
    X_new = [ones(Np,1) squeeze(Theta(i,:,:))];
    
    %Estimating the parameters and setting each row in the matrix Gamma as
    %the estimated parameters for the model excluding the constant term.
    
    coefficients = (X_new'*X_new)^(-1)*X_new'*Y_new;
    Gamma(i,:) = coefficients;
end

%Calculating the average of the Gammas
GammaMeans = mean(Gamma);


%Calculating the standard deviation of the Gammas (regular Method)
GammaStd = zeros(size(GammaMeans));
for i=1:Nf+1
    GammaStd(i)=(std(Gamma(:,i)))/sqrt(NumWindows-1);
end



%Estimating the Std using Litzenberger y Ramaswamy method:

disp("Using The Litzenberger y Ramaswamy Adjustment")

%Calculating the estimated market return and the sample variance for the period considered in the
%estimation
Rm = (sum(Mkt_RF(61:end,:) + RF(61:end,:)))/NumWindows;
Vm = var(Mkt_RF(61:end,:));


%Calculating the Adjustment Factor:
AdjustmentFactor = 1 + ((Rm - GammaMeans(1))^2)/Vm;

GammaStd = GammaStd*AdjustmentFactor;
%Calculating the t_test to test that each variable gamma is significative
%Null Hypotesis: Gamma==0
t_test = GammaMeans./GammaStd

%Checking if we reject the Null Hypotesis -> with confidence interval 95%
%The test isdistributed as a N(0,1) and it's an asyntotic test
results = abs(t_test)>=1.95;
Names = ["Constant", "Mkt_RF", "SMB", "HML", "MOM", "RMW", "CMA"];

for i=1:size(Names,2)
    if results(i)==1
        X = ["The variable ",Names(i), "is significative at a 95% confidence level",newline];
        disp(join(X))
    else
        X = ['The variable ',Names(i), ' is NOT significative at a 95% confidence level',newline];
        disp(join(X))
    end
end
%}

%===================================================================================
%===================================================================================
%Dibujando

Y = Y';
Y_mean = mean(Y);
Beta_RMW = mean(squeeze(Theta(:,:,6)));
model = fitlm(Y_mean,Beta_RMW);
Tstat = model.Coefficients.tStat;
Coeff = model.Coefficients.Estimate;
R = model.Rsquared(1).Ordinary

plot(model);
xlabel('Beta Robust Minus Weak')
ylabel('Extra-Returns')
title('Relationship between the estimated coefficient for RMW and the Extra-returns')
%}
