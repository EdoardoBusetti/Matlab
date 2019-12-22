clear
close all
clc

%% Loading and handling data
% Data structure: Entity,Code,Year,Mean male height (cm) (centimeters)
Men_Table = readtable('average-height-of-men.csv');

% Data structure: Entity,Code,Year,Mean female height (cm) (centimeters)
Women_Table = readtable('average-height-of-women.csv');


Men_height   = sort(table2array(Men_Table(:,4)));   % cm
Women_height = sort(table2array(Women_Table(:,4))); % cm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting height for men and women
figure(1)
subplot(3,2,1:2);
histogram(Men_height);
hold on 
histogram(Women_height);
title('Height Empirical Distribution')
legend('Men height','Women height')
set(gca,'ytick',[])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Fitting normal distribution
men_parameters = fitdist(Men_height,'normal');
women_parameters = fitdist(Women_height,'normal');

mu_men    = men_parameters.mu;
sigma_men = men_parameters.sigma;

mu_women    = women_parameters.mu;
sigma_women = women_parameters.sigma;


men_modelPdf = @(x)(normpdf(x,mu_men,sigma_men));
women_modelPdf = @(x)(normpdf(x,mu_women,sigma_women));

plot1 = subplot(3,2,3);
graphicalComparisonPdf(Men_height,men_modelPdf)   
title('Men')
legend(plot1,'off')
xlabel('')
ylabel('Height')

plot2 = subplot(3,2,4);
graphicalComparisonPdf(Women_height,women_modelPdf) 
title('Women')
legend(plot2,'off')
xlabel('')
ylabel('Height')



% Calculating correlation
Rho = corr(Men_height,Women_height);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Visualizing the multivariate normal
All_Height = sort([Men_height; Women_height]);
figure(1);
plot3 = subplot(3,2,5:6);
nBins = 200;
%histogram(All_Height,nBins)

%% Fitting a normal distribution for comparison
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
All_parameters = fitdist(All_Height,'normal');

mu_all       = All_parameters.mu;
sigma_all    = All_parameters.sigma;
All_modelPdf = @(x)(normpdf(x,mu_all,sigma_all));
figure(1);
graphicalComparisonPdf(All_Height,All_modelPdf,nBins) 

title('Height distribution men and women together')
legend(plot3,'off')
xlabel('')
ylabel('Height')

%% Plotting the multivariate with the marginals
figure(2)
scatterhist(Men_height,Women_height)
%{
All_Matrix = [Men_height Women_height];
Mu    = mean(All_Matrix);
Sigma = cov(All_Matrix);
N     = length(All_Height);
figure(2)
Plot_Marg_Bivariate(Mu,Sigma,N)
%}