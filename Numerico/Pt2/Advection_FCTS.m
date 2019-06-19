%% FCTS Method
 
clear;
close all
clc
 
% Parameters to define the advection equation and the range in space and time
 
Smax = 20;      % Maximum length -> Lmax
E = 10;         % Strike Price
Tmax = 1.;      % Maximum time -> T
%c = 100;       % Advection velocity
fTau = @(t)(Tmax-t);
 
%  Parameters needed to implement the method
r = 0.04;           %Intrest rate
Nt = 5000;          % Number of time steps
Dt = Tmax/Nt;       % Time step
NS = 10000;          % Number of space steps
DS = Smax/NS;       % Space step    
alpha = r*Dt/(2*(DS));      % alpha parameter in the finite-difference implementation
t = 0:Dt:Tmax;
%  Initial condition: the initial value of the u function (amplitude of the wave initially)
 
Nfront=round(NS/2); % The wave-front: intermediate point from which u = 0
for n = 1:(NS+1)
   if n > Nfront
      V(n,1)=1;
   else
      V(n,1)=0.;
   end 
   S(n) =(n-1)*DS;  % We also define vector S, due to the space discretization
end

%  Boundary conditions: value of the the u function at the boundaries at any time
for j=1:Nt+1
        V(1,j) = 0; %When the space (S) is at position 1 ->  V(0,tau) = 0
        V(NS+1,j) = 1*exp(-r*(Tmax-t(j))); % When the space is beyond the max value  -> V(Smax,tau) = 1
        t(j) = (j-1)*Dt;    % We also define vector t, due to the time discretization (From 0 to num_Nt)
        tau_vec(j) = fTau(t(j));
end
 
%  Implementation of the Lax method
for j=1:Nt           %  Time loop
   for n=2:NS   %  Space loop
      V(n,j+1) = V(n,j)+alpha*(V(n+1,j)-V(n-1,j));
   end
end


% Graphical representation of the wave at different selected times
plot(S,V(:,1),'-b','linewidth',2)
hold on
plot(S,V(:,round(Nt/2)),':b','linewidth',2)
plot(S,V(:,end),'-.r','linewidth',2)
legend('V(S, Tau=T)','V(S, t=Tau=T/2)','V(S,Tau = 0)')
hold off
%C_string = sprintf('Square-wave test UpWind Method. The value of c is %i :',c);
%title(C_string)
xlabel('X')
ylabel('Amplitude(X)')