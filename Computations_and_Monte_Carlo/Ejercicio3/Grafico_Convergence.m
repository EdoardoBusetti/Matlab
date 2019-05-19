clc
close all
clear

%The function that we want to calculate the integral of
f = @(x)x*2;
a = 0;
b = 2;
Real_Int = 4;



%Values of N that we will test the algorithm on
N_test = (100:100:1000);


hold all
for j = 1:length(N_test)
    N = N_test(j);
    for i = 1:N
        N_vec = 1:i;
        Int(i,j) = IntegralDefinida(f,a,b,i);
        points_X = (1:N)/N;
    end
    Int_ToPlot = Int((round(N/2):end),:);
    Int_ToPlot(Int_ToPlot==0) = nan;
    plot(points_X(round(N/2):end),Int_ToPlot);
end
ylabel('Integral Value. True Value = 4')

plot([0.5 1],[4 4],'LineWidth',3)
hold off
%{
N = 500;
for i = 1:N
    N_vec = 1:i;
    Int(i) = IntegralDefinida(f,a,b,i);
end
points_X = (1:N)/N;
plot(points_X(round(N/2):end),Int(round(N/2):end),'r');
%}
