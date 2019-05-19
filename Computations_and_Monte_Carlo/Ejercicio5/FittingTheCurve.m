clc
clear
close


%% In this test program we want to find out which degree polinomial can fit the curve previuosly calculated while keeping an error lower than 0.01

S0 = 100; K = 90; r = 0.1; T = 2; A = 10;

Sigmas = linspace(0.1,0.5);

Vegas_2D = vegaDigital(S0,K,r,T,Sigmas,A);

%The lowest degree polinomial fit that gives back a relative error lower
%than 0.01 is 3, with an error of 0.0051616 (2 degree polinomial gives an
%error of 0.013244).

Polynomial_3 = polyfit(Sigmas,Vegas_2D,3);
Estimate_3 = polyval(Polynomial_3,Sigmas);
Error_3 = sum(abs((Estimate_3-Vegas_2D)/Vegas_2D));
figure(1)
plot(Sigmas,Vegas_2D)
xlabel('Sigma')
ylabel('Vega')
hold on
plot(Sigmas,Estimate_3,'r')
legend('Real values','3rd Degree polynomial estimate','Location','southeast')
title('Third degree polynomial approximation')
disp(['The relative error of the 3rd degree polinomial estimate is:  ',num2str(Error_3)])

%% (EXTRA)
%The fourth degree polynomial looks like it fits better the data without
%giving signs of overfitting
figure(2)
plot(Sigmas,Vegas_2D)
xlabel('Sigma')
ylabel('Vega')
hold on
Polynomial_4 = polyfit(Sigmas,Vegas_2D,4);
Estimate_4 = polyval(Polynomial_4,Sigmas);
Error_4 = sum(abs((Estimate_4-Vegas_2D)/Vegas_2D));
plot(Sigmas,Estimate_4,'r')
legend('Real values','4th Degree polynomial estimate','Location','southeast')
title('Fourth degree polynomial approximation')
disp(['The relative error of the 4rd degree polinomial estimate is:  ',num2str(Error_4)])

