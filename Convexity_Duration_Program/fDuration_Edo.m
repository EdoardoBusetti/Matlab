function [Duration] = fDuration_Edo(Price,IRR,CashFlows,Maturities)

sumflows_dur = 0;
for i = 1:length(CashFlows)
    flow = ((Maturities(i))*CashFlows(i))/((1 + IRR)^Maturities(i));
    sumflows_dur = sumflows_dur + flow;
end

Duration = sumflows_dur/(Price);