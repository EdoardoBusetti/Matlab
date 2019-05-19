close all
clear
clc

%% (I) Simulad 500 trayectorias del proceso Browniano Geometrico
%Number of simulations
nsimul=500; 

% Number of steps(nsteps)
nsteps=300; 

%Parameters of the simulation
mu = 0.15;
sigma = 0.1;
T = 14;
t0 = 2;
S0 = 100;

%Maturity
Maturity = T-t0;

% Time interval (dt) Vector of timesteps (timestep) 
dt=Maturity/nsteps; timestep=(t0:dt:T);

%Brownian motion increases
X = randn(nsimul,nsteps);
dB = exp((mu-0.5*sigma^2)*dt+sigma*sqrt(dt)*X);

%Set the starting value for all simulations as zero, then set the other
%steps as the cumulative sum of dB.

B=cumprod([S0*ones(nsimul,1) dB],2);

%% (II) Haced una gráfica de las primeras 50 trayectorias simuladas
%Plot simulated paths: 
figure(1)
plot(timestep, B(1:50,:)','HandleVisibility','off')
title('Simulated trajectories of a Brownian Motion');
xlabel('Time (Years)') 
ylabel('Asset Price')


%% (III) Adding the Mean
cumulate_dmean = cumsum([S0 ones(1,300)*exp(mu*dt)]);
hold on
plot(timestep,cumulate_dmean,'r','LineWidth',2.5)
legend('Mean')


%% (IV)  Normal Distribution Brownian Motion
%Changing the number of simulations so that the histogram is more precise
nsimul=5000; 
X = randn(nsimul,nsteps);
dB = exp((mu-0.5*sigma^2)*dt+sigma*sqrt(dt)*X);
B=cumprod([S0*ones(nsimul,1) dB],2);


%Parameters Istogram
t_ref = [2 6 10 14];
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
    str = sprintf('Distribution of a Geometric Brownian motion at time t = %d with t0 = 2', t_var);
    title(str)
    xlabel('B(t)')
    
    %Adding the theorical normal distribution obver the plot
    hold on
    center = (mu-0.5*sigma^2)*(t_ref(i)-t0);
    radius = 4.0*sigma*sqrt(t_ref(i)-t0);
    S_min = S0*exp(min(center - radius));
    S_max = S0*exp(max(center + radius));
    points = S_min:0.01:S_max;
    mean_B = log(S0) + (mu - 0.5*sigma^2)*(t_ref(i)-t0);
    std_B = sigma * sqrt(t_ref(i) - t0);
    modelPdf = @(x)lognpdf(x,mean_B,std_B);
    graphicalComparisonPdf(B(:,BValues_vec(i)),modelPdf,scale,S_min,S_max)
    legend('scaled histogram','pdf(x)')
end

%% (V) Distribution of B(t) when t --> t0
%When t tends to t0 the variance tens to zero and the normal distribution
%tends to a Dirac delta probability density function