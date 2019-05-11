clc
close
clear

%% Defining the assets:
%% Asset A
%Price of the asset A
Price_A = 94.5;
%Face Value of the asset A
FV_A = 100;
%Cash Flows for the asset A
CF_A = [100];
%Maturity dates for the cash flows of A
TTMat_A = [0.93];

%% Asset B
%Price of the asset B
Price_B = 99.9;
%Face Value of the asset B
FV_B = 100;
%Cash Flows for the asset B
CF_B = [5 105];
%Maturity dates for the cash flows of B
TTMat_B = [0.88 1.88];

%% Asset C
%Price of the asset C
Price_C = 102.20;
%Face Value of the asset C
FV_C = 100;
%Cash Flows for the asset C
CF_C = [6 6 106];
%Maturity dates for the cash flows of C
TTMat_C = [0.47 1.47 2.47];

%% Reordering the data
%Assuming that length C > length B > length A
CF_A(length(CF_C)) = 0;
CF_B(length(CF_C)) = 0;
TTMat_A(length(CF_C)) = 0;
TTMat_B(length(CF_C)) = 0;

%Different assets are in different rows, with theirs Cash Flows in the colums
CashFlows_All = [CF_A; CF_B; CF_C];
%Different assets are in different rows, with theirs Cash Flows Maturities in the colums
TTMaturity_CashFlows_All = [TTMat_A; TTMat_B; TTMat_C];
%Column vector with the prices of the Assets
Prices_All = [Price_A; Price_B; Price_C];

%Column vector with all the maturities
Maturities_Vector = [TTMat_A'; TTMat_B'; TTMat_C';];
Prices_Vector = [Price_A; Price_B; Price_C];

%Random Initialization of parameters a and b --> Theta = [a b]
%Theta = rand(1,2);


f = @(x)CostFunction(CashFlows_All,TTMaturity_CashFlows_All,Prices_All,[x(1) x(2)]);
Theta = fminsearch(f,[0.1,0.3]);
[cost, IntrestRates_Matrix] = CostFunction(CashFlows_All,TTMaturity_CashFlows_All,Prices_All,Theta);

rowNames = {'Asset A','Asset B','Asset c'};
colNames = {'R_CF1','R_CF2','R_CF3'};
Table = array2table(IntrestRates_Matrix,'RowNames',rowNames,'VariableNames',colNames);
disp(Table)
disp(['The total cost is:   ',num2str(cost)])