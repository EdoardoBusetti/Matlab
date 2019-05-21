function [] = fConvexityDuration_Edo()
%% Function that calculates the Duration and Convexity of a matrix of assets
% Takes the inputs from user

%% Taking user input for the prices
NumAssets = input('Insert the number of Assets:   ');
Max_CashFlows = input('Insert the maximum number of cash flows for the assets:   '); % Nedded for zero padding
Prices_All = zeros(1,NumAssets);
CashFlows_All = zeros(NumAssets,Max_CashFlows);
Maturities_All = zeros(NumAssets,Max_CashFlows);
for i =1:NumAssets
    %% Prices
    Prices_All(i) = input(['Insert the price of the asset ',num2str(i),':  ']);
    
    %% Cash Flows
    CashFlow_i = input(['Insert the cash flows of the asset ',num2str(i), ' as a row vector (using "[]") :   ']);
    CashFlows_All(i,1:length(CashFlow_i)) = CashFlow_i;
    %% Maturities
    Maturity_i = input(['Insert the maturities of the asset ',num2str(i), ' as a row vector (using "[]") :   ']);
    Maturities_All(i,1:length(Maturity_i)) = Maturity_i;
end

clc
Convexity = zeros(length(Prices_All),1);
Duration = zeros(length(Prices_All),1);
DurationMod = zeros(length(Prices_All),1);
IRR_vec = zeros(length(Prices_All),1);
for i = 1:length(Prices_All)
    Price = Prices_All(i);
    CashFlows = CashFlows_All(i,:);
    Maturities = Maturities_All(i,:);
    IRR = fIRR_Edo(Price,CashFlows,Maturities);
    IRR_vec(i) = IRR;
    Convexity(i) = fConvexity_Edo (Price,IRR,CashFlows,Maturities);
    Duration(i) = fDuration_Edo(Price,IRR,CashFlows,Maturities);
    DurationMod(i) = Duration(i)/(1+IRR);
end


%% Creating the Variable names for the Table
colNames = cell(1,NumAssets);
for i=1:NumAssets
    name = sprintf('Asset %i',i);
    varname = genvarname(name);
    colNames(i) = {varname};
end

%% Creating the table with TIR - Duration - DM - Convexity
Table_Matrix = [Duration';DurationMod';Convexity';IRR_vec'];
rowNames = {'Duration','Modified Duration','Convexity','IRR'};
Table_Matrix = array2table(Table_Matrix,'RowNames',rowNames,'VariableNames',colNames);
disp(Table_Matrix)