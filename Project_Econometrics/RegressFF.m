close
clear
clc

%Loading the data into matlab
load Momentum.txt
load Fattori4.txt
load Average_Value_Weighted_Returns

%Defining the variables:

MOM = Momentum(:,2);
Mkt_RF = Fattori4(:,2);
SMB = Fattori4(:,3);
HML = Fattori4(:,4);
Timestamps = Fattori4(:,1);
RF = Fattori4(:,5);

%Defining the matrix X_all of all the factors in the order (Mkt-RF  SMB  HML MOM)
X_all = [Mkt_RF, SMB, HML, MOM];


%Removing the timestamp from the Returns
Average_Value_Weighted_Returns = Average_Value_Weighted_Returns(:,2:26);

%Number of portfolios
Np = size(Average_Value_Weighted_Returns,2);

%Number of periods
T = size(Average_Value_Weighted_Returns,1);

%Total number of Factors
Nf = size(X_all,2);


%Defining the variable "Y" as the variable containing the extra-returns from all the portfolios

Y = zeros(T,Np);

for i=1:Np
    Y(:,i) = Average_Value_Weighted_Returns(:,i) - RF;
end;

%===================================================================================
%===================================================================================
%===================================================================================

coeff = zeros(25,5);
tStat = zeros(25,5);
std_ = zeros(25,5);

for i=1:25
    model = fitlm(X_all,Y(:,i));
    coeff(i,:) = model.Coefficients.Estimate
    tStat(i,:) = model.Coefficients.tStat
    Rsquared(i) = model.Rsquared(1).Ordinary
    std_(i,:) = model.Coefficients.SE
end

mean_coeff = mean(coeff);
mean_Tstat = mean(tStat);
meanstd = mean(std_)
meanRsquared = mean(Rsquared)

%===================================================================================
%===================================================================================
%Dibujando

