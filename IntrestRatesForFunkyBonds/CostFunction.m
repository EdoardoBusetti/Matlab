function [cost, IntrestRates_Matrix] = CostFunction(CashFlows_All,TTMaturity_CashFlows_All,Prices_All,Theta)


%Calculating the intrest rates using linear regression
IntrestRates_All = zeros(size(CashFlows_All,1),size(CashFlows_All,2));
for Asset_index=1:size(CashFlows_All,1)
    for CF_index=1:size(CashFlows_All,2)
        if TTMaturity_CashFlows_All(Asset_index,CF_index)~=0
            IntrestRates_All(Asset_index,CF_index) = Theta(1) + Theta(2)*TTMaturity_CashFlows_All(Asset_index,CF_index);
        else
            IntrestRates_All(Asset_index,CF_index) = 0;
        end
    end
end

%Calculating the total cost
sumcost = 0;
for Asset_index=1:size(CashFlows_All,1)
    CashFlow = CashFlows_All(Asset_index,:);
    TTMaturity_CashFlows = TTMaturity_CashFlows_All(Asset_index,:);
    IntrestRates = IntrestRates_All(Asset_index,:);
    Price = Prices_All(Asset_index);
    cost_j = abs(PriceOfAsset(CashFlow,TTMaturity_CashFlows,IntrestRates) -Price );
    sumcost = sumcost + cost_j;
end
cost = sumcost;
IntrestRates_Matrix = IntrestRates_All;