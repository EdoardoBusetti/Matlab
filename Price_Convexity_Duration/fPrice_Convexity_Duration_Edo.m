function [] = fPrice_Convexity_Duration_Edo()
%% Function that calculates the Duration and Convexity of a matrix of assets
% Takes the inputs from user

%% Taking user input for the prices
NumAssets = input('Insert the number of Assets:   ');
Max_CashFlows = input('Insert the maximum number of cash flows for the assets:   '); % Nedded for zero padding
CashFlows_All = zeros(NumAssets,Max_CashFlows);
Maturities_All = zeros(NumAssets,Max_CashFlows);
CouponNum = zeros(1,NumAssets);
Market_IntrestRates = zeros(1,Max_CashFlows);

%% Insert the intrest rate for the first year
disp([newline,'The intrest rate function is  Const + Slope*t^(Exp)',newline])
Market_IntrestRates(1) = input('Insert the market intrest rate (Const):  ');
Intrest_rate_Slope = input('Insert the slope of the intrest rate function (Slope) :  ');
Intrest_rate_Exp = input('Insert the exponent of the intrest rate function (Exp)  :  ');
Market_IntrestRates = (Market_IntrestRates(1) + Intrest_rate_Slope*((1:Max_CashFlows).^Intrest_rate_Exp));
%% Generating the intrest rates curve


    
for i =1:NumAssets
    %% Number of coupons
    CouponNum(i) = input(['Insert the number of coupons of the asset ',num2str(i),':  ']);
    %% Cash Flows
    CashFlow_i = input(['Insert the coupon intrest rate of the asset ',num2str(i), ' as a % ']);
    CashFlows_All(i,1:CouponNum(i)) = [CashFlow_i*ones(1,CouponNum(i)-1) (CashFlow_i+100)];
    %% Maturities
    Maturity_i = input(['Insert the first Maturity of the asset ',num2str(i),' :']);
    Maturities_All(i,1:CouponNum(i)) = Maturity_i*1:CouponNum(i);

end



%clc
Convexity = zeros(NumAssets,1);
Duration = zeros(NumAssets,1);
DurationMod = zeros(NumAssets,1);
Price_vec = zeros(NumAssets,1);
IRR_vec = zeros(NumAssets,1);
for i = 1:NumAssets
    CashFlows = nonzeros(CashFlows_All(i,:));
    Maturities = nonzeros(Maturities_All(i,:));
    Market_IntrestRate = Market_IntrestRates(1:CouponNum(i));
    Price = PriceOfAsset(CashFlows,Maturities,Market_IntrestRate);
    IRR = fIRR_Edo(Price,CashFlows,Maturities);
    IRR_vec(i) = IRR;
    Price_vec(i) = Price;
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
Table_Matrix = [Price_vec';Duration';DurationMod';Convexity';IRR_vec'];
rowNames = {'Price','Duration','Modified Duration','Convexity','IRR'};
Table_Matrix = array2table(Table_Matrix,'RowNames',rowNames,'VariableNames',colNames);
disp(Table_Matrix)