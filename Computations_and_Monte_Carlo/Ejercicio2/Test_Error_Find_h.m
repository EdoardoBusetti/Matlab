clc
close all
clear
%% (IV) ¿Cuál es el valor de h que nos da el resultado con menor error? 
%Ilustra la repuesta con evaluaciones de la función para distintos valores de h. 

% Test program to find out the minimum value of h that minimizes the
% error of the estimation of the gamma of a call using the divided
% differences approach


S0 = 100; K = 90; r = 0.03; T = 2; sigma = 0.4; N = 16; 

h_vec = 10.^(0:-1:-N);

error = zeros(1,N);
for j=1:length(h_vec)
    h = h_vec(j);
    error(j)  = abs(gammaCallEU(h,S0,K,r,T,sigma) - blsgamma(S0,K,r,T,sigma));
end

%Minimum value found for the error and the h that generates that min error
[min_error,position] = min(error);
h_min = h_vec(position);

disp([newline,newline,'The value of h for the minimum error is:      ',num2str(h_min),newline])
disp(['The minimum error found is:               ',num2str(min_error)])

