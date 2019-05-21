function [Convexity] = fConvexity_Edo (Price,IRR,CashFlows,Maturities)

sumflows_conv = 0;
for i = 1:length(CashFlows)
    flow = ((Maturities(i)+ Maturities(i)^2)*CashFlows(i))/((1 + IRR)^Maturities(i));
    sumflows_conv = sumflows_conv + flow;
end

Convexity = sumflows_conv/(Price*(1+IRR)^2);