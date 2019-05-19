function [X,u,h] = simARMAGARCH(M,T,phi0,phi,theta,kappa,alpha,beta,X0,u0,h0)
% simARMAGARCH : Simulacion de un proceso ARMA(p,q) + GARCH(r,s)
%
% Sintaxis:
% X = simARMAGARCH(M,T,phi0,phi,theta,kappa,alpha,beta,X0,u0,h0)
%
% X : Matriz (M,T) que contiene las M trayectorias simuladas
% M : Numero de trayectorias simuladas
% T : Pasos para la simulacion
% phi0,phi,theta : Parametros que caracterizan el proceso ARMA(p,q)
% kappa,alpha,beta : Parametros que caracterizan el proceso GARCH(r,s)
% X0 : Valores iniciales de la serie temporal
% u0 : Valohelpres iniciales de las innovaciones
% h0 : Valores iniciales de la volatilidad
%
% Ejemplo 1: Simulacion ARMA(2,3) + GARCH(1,2)
% M = 3; T = 1000; d = 3;
% phi0 = 0.0; phi1 = [0.4 -0.2]; theta = [0.3 -0.6 0.1];
% kappa = 0.1; alpha = 0.1; beta = [0.6 0.2];
% X0 = [0 0 0]; u0 = [0 0 0];
% h0 = kappa/(1-sum(alpha)-sum(beta))*ones(d,1);
% [X,u,h]=simARMAGARCH(M,T,phi0,phi1,theta,kappa,alpha,beta,X0,u0,h0);
% diasEnAnyo = 250;
% S0 = 100; dT = 1/diasEnAnyo; S = cumprod([S0*ones(M,1) exp(X*dT)],2);
% figure(1); subplot(3,1,1); plot(1:T,X(:,1:T)); ylabel('Rendimiento');
% subplot(3,1,2); plot(1:T,S(:,1:T)); ylabel('Precio');
% subplot(3,1,3);
% plot(1:T,sqrt(diasEnAnyo*h(1,1:T)));ylabel('Volatilidad');
% figure(2); autocorr(X(1,:),30);
% figure(3); subplot(2,1,1); autocorr(u(1,:),30);
% subplot(2,1,2); autocorr(abs(u(1,:)),30);
%
%
% Ejemplo 2: Simulacion AR(1)
% M = 1; T = 1000; phi0 = 0.0; phi1 = -0.7; sigma = 0.25;
% theta = []; kappa = sigma; alpha = []; beta = []; % simula AR(1)
% X0 = 0; u0 = 0; h0 = sigma;
% [X,u,h]=simARMAGARCH(M,T,phi0,phi1,theta,kappa,alpha,beta,X0,u0,h0);
% figure(1); plot(1:T,X(:,1:T));
% figure(2); T1 = 50; plot(1:T1,X(:,1:T1));
% figure(3); autocorr(X(1,:),30);
% figure(4); subplot(2,1,1); autocorr(u(1,:),30);
% subplot(2,1,2); autocorr(abs(u(1,:)),30);
% figure(5); plot(1:T,h(1,:));
%
% Ejemplo 3: Simulacion AR(1) + GARCH(1,1)
% M = 1; T = 1000;
% phi0 = 0.0; phi1 = 0.2;
% theta = [];
% kappa = 0.1; alpha = 0.10; beta = 0.85;
% X0 = 0; u0 = 0; h0 = kappa/(1-alpha-beta);
% [X,u,h]=simARMAGARCH(M,T,phi0,phi1,theta,kappa,alpha,beta,X0,u0,h0);
% diasEnAnyo = 250;
% S0 = 100; dT = 1/diasEnAnyo; S = cumprod([S0*ones(M,1) exp(X*dT)],2);
% figure(1); subplot(3,1,1); plot(1:T,X(:,1:T)); ylabel('Rendimiento');
% subplot(3,1,2); plot(1:T,S(:,1:T)); ylabel('Precio');
% subplot(3,1,3);
% plot(1:T,sqrt(diasEnAnyo*h(1,1:T)));ylabel('Volatilidad');
% figure(2); autocorr(X(1,:),30);
% figure(3); subplot(2,1,1); autocorr(u(1,:),30);
% subplot(2,1,2); autocorr(abs(u(1,:)),30);
% 
% Ejemplo 0: Proposicion Profesor AR(1) y GARCH(1,1).
% M = 1; T = 1000;
% phi0  = 0;
% phi   = 0.15; theta = [] ; % AR(1)
% kappa = 0.1;  alpha = 0.1; beta = 0.7; % GARCH(1,1)
% [X,u,h] = simARMAGARCH(M,T,phi0,phi,theta,kappa,alpha,beta);
% diasEnAnyo = 250;
% S0 = 100; dT = 1/diasEnAnyo; S = cumprod([S0*ones(M,1) exp(X*dT)],2);
% figure(1); subplot(3,1,1); plot(1:T,X(:,1:T)); ylabel('Rendimiento');
% subplot(3,1,2); plot(1:T,S(:,1:T)); ylabel('Precio');
% subplot(3,1,3);
% plot(1:T,sqrt(diasEnAnyo*h(1,1:T)));ylabel('Volatilidad');
% figure(2); autocorr(X(1,:),30);
% figure(3); subplot(2,1,1); autocorr(u(1,:),30);
% subplot(2,1,2); autocorr(abs(u(1,:)),30);



r = length(alpha);
s = length(beta);
%% En caso de que no se proporcionen condiciones iniciales, se deben generar simulaciones a partir de condiciones iniciales razonables calculadas de manera automática.
% Set the intitial X0 to 0 if not specified otherwise
if ~exist('X0','var')
      X0 = zeros(1,M);
end
% Set the intitial u0 to 0 if not specified otherwise
if ~exist('u0','var')
    u0 = zeros(1,M);
end
% Set the intitial h0 to sigma if not specified otherwise and the model
% does not have GARCH volatility or to
% (kappa/(1-sum(alpha)-sum(beta)))*ones(1,M) if the model has GARCH
% volatility.
if ~exist('h0','var')
    if r == 0 && s == 0
        h0 = sigma*ones(1,M);
    else
        h0 = (kappa/(1-sum(alpha)-sum(beta)))*ones(1,M);
    end
end
%% Implementation
X = zeros(M,T);
u = zeros(M,T);
h = zeros(M,T);

for numsim=1:M
    [X(numsim,:), u(numsim,:), h(numsim,:)] = ARMAGARCH(T,phi0,phi,theta,kappa,alpha,beta,X0(numsim),u0(numsim),h0(numsim));
end