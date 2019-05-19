function [X,u] = simAR1(M,T, phi0,phi1,sigma,X0)
% simAR1 : Simulacion de un proceso AR(1)
%
% Sintaxis:
% X = simAR1(M,T,phi0,phi1,sigma,X0) 
%
% X : Matriz (M,T) que contiene los M trayectorias simuladas
% M : Numero de trayectorias simuladas
% T : Tiempos para la simulacion
% X0 : Valor inicial de la serie temporal
% phi0,phi1,sigma : Parametros que caracterizan el proceso AR(1)
%
% Ejemplo 1:
% M = 3; T = 1000; X0 = 0; phi0 = 0.0; phi1 = 0.7; sigma = 0.25;
% [X,u] = simAR1(M,T,phi0,phi1,sigma,X0);
% figure(1); plot(1:T,X(:,1:T));
% figure(2); autocorr(X(1,:),30);
% figure(3); subplot(2,1,1); autocorr(u(1,:),30);
% subplot(2,1,2); autocorr(abs(u(1,:)),30);
%
% Ejemplo 2: Simulacian aprox. estacionaria
% M = 1; T = 1000; X0 = 0; phi0 = 0.0; phi1 = -0.7; sigma = 0.25;
% [X,u] = simAR1(M,T,phi0,phi1,sigma,X0);
% figure(1); plot(1:T,X);
% figure(2); autocorr(X(1,:),30);
% figure(3); subplot(2,1,1); autocorr(u(1,:),30);
% subplot(2,1,2); autocorr(abs(u(1,:)),30);
%
% Ejemplo 3: Simulacian no estacionaria
% M = 1; T = 500; X0 = 10; phi0 = 0.0; phi1 = 0.95; sigma = 0.25;
% [X,u] = simAR1(M,T,phi0,phi1,sigma,X0);
% figure(1); plot(1:T,X);
%
%
%queremos una matriz X=(MxT)
Xt = [X0*ones(M,1) zeros(M,T)]; %Fijamos una dimension para la Matriz X y fijamos el primero valor como X0 por todas las M simulaciones
u = sigma*randn(M,T); %u son las innovaciones del proceso AR(1)
for m=1:M %desde la trayectoria 1 hasta la M
    for t= 2:T+1 %desde 2 hasta T + 1 -> Que son en total T tiempos para la simulacion
        Xt(m,t) = phi0 + phi1*Xt(m,t-1)+u(m,t-1); %valor de X por el proceso AR(1)
    end
end

% Borro la primera observacion de cada fila (ya que esta es X0)
X = Xt(:,2:end);