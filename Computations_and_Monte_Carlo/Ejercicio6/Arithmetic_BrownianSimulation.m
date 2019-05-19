close all
clear
clc

%% (I) Simulad 500 trayectorias del proceso Browniano
%Number of simulations
nsimul=500; 

% Number of steps(nsteps)
nsteps=300; 

%Parameters of the simulation
mu = 5;
sigma = 0.7;
T = 5;
t0 = 2;
B0 = 100;

%Maturity
Maturity = T-t0;

% Time interval (dt) Vector of timesteps (timestep) 
dt=Maturity/nsteps; timestep=(t0:dt:T);

%Brownian motion increases
X = randn(nsimul,nsteps);
dB = mu * dt + sigma * sqrt(dt) * X;
%Set the starting value for all simulations as zero, then set the other
%steps as the cumulative sum of dB.
B=cumsum([B0*ones(nsimul,1) (dB)],2);

%% (II) Haced una gráfica de las primeras 50 trayectorias simuladas
%Plot simulated paths: 
figure(1)
plot(timestep, B(1:50,:)','HandleVisibility','off')
title('Simulated trajectories of a Brownian Motion');
xlabel('Time (Years)') 
ylabel('Asset Price')

%% (III) Adding the Mean
cumulate_dmean = cumsum([B0 ones(1,300)*mu*dt]);
hold on
plot(timestep,cumulate_dmean,'r','LineWidth',2.5)
legend('Mean')

%% (IV) Plotting the standard deviation
figure(2)
Std_vec = sigma*(timestep-2).^0.5;
plot(timestep, Std_vec +B0,'LineWidth',2 )
title('Variance of the brownian motion through time')
xlabel('Timestamp')
ylabel('Variance')
hold on
std_B = var(B).^0.5 + B0;
plot(timestep,std_B,'LineWidth',2)
legend('Theoric Std','Sample Standard Deviation')

%% (V) Plotting the Autocovariance
t1 = 3;
cov = (sigma.^2)*min(timestep-t0,t1-t0);
figure(3)
plot(timestep,cov,'LineWidth',2)
title('Covariance of a Brownian Motion')
xlabel('Timesteps')
ylabel('Cov')
hold on

%Covariance formula for t1 = 3
B_t1 = B(:,101); %the value of B where t = 3
% Covariance Formula: Sum((X_i - E(X)(Y_i - E(Y))/N
Cov_vec = ((B - mean(B,1))'*(B_t1 - mean(B_t1)))/nsimul; 

plot(timestep,Cov_vec,'LineWidth',2)
legend('Theoric Cov','Sample Cov')


%% (Extra) Alternative method for the covariance
% Cov(Bt,Bt1) = V(Bt)  if t < t1 else = V(Bt1)
%{
%Logical array where t < t1
timelogic = timestep < t1;
not_timelogic = ~timelogic;
var_Bt = (sigma.^2).*(timestep-t0);
var_Bt1 = (sigma.^2).*(t1-t0);

Cov_vec_Bt = timelogic.*var_Bt;
Cov_vec_Bt1 = not_timelogic.*var_Bt1;
Covariance_Vector = Cov_vec_Bt+ Cov_vec_Bt1;
figure(4)
plot(timestep,Covariance_Vector,'LineWidth',2)
title('Covariance of a Brownian Motion')
xlabel('Timesteps')
ylabel('Cov')
%}

%% (VI)  Normal Distribution Brownian Motion

%Changing the number of simulations so that the histogram is more precise
nsimul=5000; 
X = randn(nsimul,nsteps);
dB = mu * dt + sigma * sqrt(dt) * X;
B=cumsum([B0*ones(nsimul,1) (dB)],2);

%Parameters Istogram
t_ref = 2:5;
bins = 100;
BValues_vec = 1:100:301;

% Parameters Grafical comparison
scale = 0;

figure(4)
for i=1:length(t_ref)
    t_var = t_ref(i);
    BrownianValues =  B(:,BValues_vec(i));
    subplot(2,2,i)
    hist(BrownianValues,bins);
    str = sprintf('Histogram of the distribution of a Brownian motion at time t = %d with t0 = 2', t_var);
    title(str)
    xlabel('B(t)')
    
    %Adding the theorical normal distribution obver the plot
    hold on
    center = mu*(t_ref(i)-t0);
    radius = 4*sigma*sqrt(t_ref(i)-t0);
    B_min = B0 + min(center - radius) ;
    B_max = B0 + max(center + radius);
    mean_B = B0 + mu*(t_ref(i)-t0);
    std_B = sigma * sqrt(t_ref(i) - t0);
    
    modelPdf = @(x)normpdf(x,mean_B,std_B);
    
    graphicalComparisonPdf(B(:,BValues_vec(i)),modelPdf,scale,B_min,B_max)
    
    legend('scaled histogram','pdf(x)')
end

%% (VII) Distribution of B((t) when t --> t0
%When t tends to t0 the variance tens to zero and the normal distribution
%tends to a Dirac delta probability density function with mean = B0
