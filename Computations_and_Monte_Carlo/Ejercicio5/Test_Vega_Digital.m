close all
clear
clc
%% Testing how the Vega changes b changing the volatility in the interval [0.1 0.5]

%When the digital option is in the money volatility is bad, as it increases
%the change of the option getting out of the money --> That's why in this
%example we see that the vega is negative.
%Data:

S0 = 100; K = 90; r = 0.1; T = 2; A = 10;


Sigmas = linspace(0.1,0.5);

Vegas_2D = vegaDigital(S0,K,r,T,Sigmas,A);
plot(Sigmas,Vegas_2D)
xlabel('Sigma')
ylabel('Vega')
title('How the vega of a digital option changes by changing the price of Sigma')


%% (Extra) See how the vega changes also as a function of the underlying asset price
Prices = linspace(60,110);
Vegas_3D = zeros(100,100);
cumulatedmean = 0;
for price_index=1:100
    tic;
    price = Prices(price_index);
    Vegas_3D(price_index,:) = vegaDigital(price,K,r,T,Sigmas,A);
    
    disp(['Loading: ',num2str(price_index),'%'])
    time=toc;
    cumulatedmean = (cumulatedmean + time);
    timeleft = (cumulatedmean/price_index)*(100-price_index);
    disp([num2str(timeleft),' Seconds left',newline])
end

figure(4)
plot(Prices,Vegas_3D(:,20))
xlabel('Prices')
ylabel('Vega')
title('How the vega of a digital option changes by changing the price of the underlying asset')

figure(2)
[x,y] = meshgrid(Sigmas,Prices);
surf(x,y,Vegas_3D)
xlabel('Sigma')
ylabel('Prices')
zlabel('Vegas')

figure(3)
mesh(x,y,Vegas_3D)
xlabel('Sigma')
ylabel('Prices')
zlabel('Vegas')
