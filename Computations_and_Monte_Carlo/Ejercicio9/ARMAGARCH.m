function [X,u,h] = ARMAGARCH(T,phi0,phi,theta,kappa,alpha,beta,X0,u0,h0)
% ARMAGARCH: Calculating an ARMA process with GARCH variances
%% SYNTAX:
%       [X,u,h] = ARMAGARCH(T,phi0,phi,theta,kappa,alpha,beta,X0,u0,h0)
%
%% INPUT
% T : Pasos para la simulacion
% phi0,phi,theta : Parametros que caracterizan el proceso ARMA(p,q)
% kappa,alpha,beta : Parametros que caracterizan el proceso GARCH(r,s)
% X0 : Valores iniciales de la serie temporal
% u0 : Valohelpres iniciales de las innovaciones
% h0 : Valores iniciales de la volatilidad
%% OUTPUT:
%    X : the time series of a ARMAGARCH process


%% Defining variables and checking if the conditions are met
r = length(alpha);
s = length(beta);
p = length(phi);
q = length(theta);

if r > T
    error('r and cannot be bigger than T (Check size of alpha)')
elseif s > T
    error('s and cannot be bigger than T (Check size of beta)')
elseif p > T
    error('p and cannot be bigger than T (Check size of phi)')
elseif q > T
    error('q and cannot be bigger than T (Check size of theta)')
end  


%If we are using a GARCH(1,1) check that Alpha + Beta < 1 , because if not
%the model would have zero or negative coefficient of long-term variance
if r == 1 && s==1 && alpha + beta >=1
    warning('In GARCH(1,1) alpha + beta should be less than 1')
end


biggest_lag = max([r s p q]);

%% Implementation

X_vec = [X0*ones(1,biggest_lag) zeros(1,T)];
h_vec = [h0*ones(1,biggest_lag) zeros(1,T)];
u_vec = [u0*ones(1,biggest_lag) zeros(1,T)];

Eps = randn(1,T+biggest_lag);
for time=biggest_lag+1:T+biggest_lag
    %GARCH Part
    u_lags_r = u_vec(time-r:time-1); %The vector with r lags of u from t-1 to t-r
    h_lags = h_vec(time-s:time-1);
    h_vec(time) = kappa + sum((u_lags_r.^2).*alpha) + sum(h_lags.*beta);
    u_vec(time) = sqrt(h_vec(time))*Eps(time-1);
    
    
    %ARMA Part
    X_lags = X_vec(time-p:time-1);
    u_lags_q = u_vec(time-q:time-1);
    X_vec(time) = phi0 + sum(phi.*X_lags) + sum(theta.*u_lags_q) + u_vec(time);
end

u = u_vec(biggest_lag+1:end);
h = h_vec(biggest_lag+1:end);
X = X_vec(biggest_lag+1:end);