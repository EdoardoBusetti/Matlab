function  [Price] = PriceOfAsset(CashFlow,TTMaturity_CashFlows,IntrestRates)

%% Example
    %%Cash Flows for the asset C
        %CashFlow = [6 6 106];
    %%Maturity dates for the cash flows of C
        %TTMaturity_CashFlows = [0.47 1.47 2.47];
    %%Intrest Rates
        %IntrestRates = [0.05 0.07 0.09];
    %Price = PriceOfAsset(CashFlow,TTMaturity_CashFlows,IntrestRates)

 Price_sum = 0;
 for t=1:length(CashFlow)
     CashFlow_t = CashFlow(t)*(1+IntrestRates(t))^(-TTMaturity_CashFlows(t));
     Price_sum = Price_sum + CashFlow_t;
 end
 
Price = Price_sum;