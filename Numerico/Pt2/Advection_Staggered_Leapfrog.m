

%% Staggered Leapfrog Method
clear;
close all
clc

% Parameters to define the advection equation and the range in space and time

Smax = 20;  	% Maximum length -> Lmax
E = 10;         % Strike Price
Tmax = 1.;    	% Maximum time -> T
fTau = @(t)(Tmax-t);

%  Parameters needed to implement the method
r = 0.4;           %Intrest rate
Nt = 1000;          % Number of time steps
dt = Tmax/Nt;		% Time step
NS = 2000;			% Number of space steps
dS = Smax/NS;		% Space step	
alpha = r*dt/dS;      % alpha parameter in the finite-difference implementation

fprintf('Stability condition: %f < 1 \n',alpha)

%  Initial condition: the initial value of the u function (amplitude of the wave initially)

Nfront=round(NS/2); % The wave-front: intermediate point from which u = 0
V = zeros(NS+2,Nt+1);
S = zeros(1,NS +1);
for n = 1:(NS+2)
   if n > Nfront
      V(n,1)=10;
   else
      V(n,1)=0.;
   end 
end
S = 0:dS:Smax;

% figure(1)
% plot(S,V(:,1),'LineWidth',2);

tau_vec = 0:dt:Tmax;

%  Boundary conditions: value of the the u function at the boundaries at any time 
for j=1:Nt+2
        V(1,j) = 0; %When the space (S) is at position 1 ->  V(0,tau) = 0
        V(NS+1,j) = 10; % When the space is beyond the max value  -> V(Smax,tau) = 1
end
V(:,2) = V(:,1);
%  Implementation of the Staggered Leapfrog method
for j=2:Nt+1         %  Time loop
   for n=2:NS	%  Space loop
      V(n,j+1) = alpha*(V(n+1,j)-V(n-1,j)) + V(n,j-1);
   end
end

V = V(1:end-1,:);
% Graphical representation of the wave at different selected times
plot(S,V(:,1),'-b','linewidth',2)
hold on
plot(S,V(:,round(Nt/2)),':b','linewidth',2)
plot(S,V(:,end),'-.r','linewidth',2)
legend('V(S, t=T)','V(S, t=Tau=T/2)','V(S,t = 0)','Location','southeast')
str = sprintf('The methods behaves strangely near S = 10 because there it is not differenciable');
annotation('textbox','String',str,'Position',[0.13,0.8464,0.6804,0.0536])

hold off
xlabel('X')
ylabel('Amplitude(X)')
