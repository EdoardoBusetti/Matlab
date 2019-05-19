close
clear
clc



% Test program used to find the value of the sensibility "h" of the
% numerical derivative that minimizes the error of estimation of the delta
% of a call.


S0 = 100; K = 90; r = 0.03; T = 2; sigma = 0.4; N = 15;



h_vec = linspace(0,5e-5,300);

error = zeros(length(h_vec),1);
for j=1:length(h_vec)
    error(j)  = abs(deltaCallEU(h_vec(j),S0,K,r,T,sigma) - blsdelta(S0,K,r,T,sigma))/blsdelta(S0,K,r,T,sigma);
end
figure(1)
plot(h_vec,error,'LineWidth',1)
%loglog(h_vec,error,'LineWidth',1)
set(gca, 'XDir','reverse')
xlabel('Value of h')
ylabel('Value of the error')
title('How the error changes with decreasing h')
hold on

[value,position] = min(error);
plot(h_vec(position),error(position),'r*','LineWidth',3)
min_error = value;
h_minerror = h_vec(position);

disp([newline,newline,'The value of h for the minimum error is:      ',num2str(h_minerror),newline])
disp(['The minimum error found is:               ',num2str(min_error)])



