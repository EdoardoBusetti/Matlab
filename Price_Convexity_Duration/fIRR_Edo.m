function TIR_result = fIRR_Edo(Price,CashFlows,Maturities)

%% %Example
% Price  = 102.20; 
% CashFlows = [6 6 106];
% Maturities = [0.47 1.47 2.47];
% TIR_result = tir_Edo(Price,CashFlows,Maturities)


%{ 
time = zeros(1,length(Maturities));
for i = 1:length(Maturities)
    time(i) = (Maturities(i) + Maturities(i)^2);
end
%}

syms TIR

DiscountFactors = ((1+TIR).^Maturities).^-1;

DiscountedCF = CashFlows.*DiscountFactors;

TIR_Eqn = sum(DiscountedCF) == Price;

s = vpasolve(TIR_Eqn, TIR);

TIR_result_vec = double(s);
TIR_result = min(real(TIR_result_vec));
