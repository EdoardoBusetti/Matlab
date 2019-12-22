function graphicalComparisonPdf(X,modelPdf,nBins,scale,xMin,xMax)
%% graphicalComparisonPdf: Compare histogram and modelPdf
%
%% SYNTAX:
%        graphicalComparisonPdf(X,modelPdf,scale,xMin,xMax)
%
%% INPUT:
%             X : Sample
%      modelPdf : model pdf
%         scale : scale histogram (scale = 1) / scale pdf (scale = 0)
%  [xMin, xMax] : range for plot 
%
%% EXAMPLE 1:
%           mu = 1; sigma = 3;
%           M = 1e3;  % sample size
%           X = mu + sigma*randn(M,1);
%           modelPdf = @(x)(normpdf(x,mu,sigma));
%           figure(1); graphicalComparisonPdf(X,modelPdf)
%           title('X ~ N(mu,sigma)')
%
%           scale = 0;
%           figure(2); graphicalComparisonPdf(X,modelPdf,scale)
%           title('X ~ N(mu,sigma)')
%
%% EXAMPLE 2:
%           mu = 1; sigma = 0.3;
%           M = 1e3;  % sample size
%           Y = exp(mu + sigma*randn(M,1));
%           modelPdf = @(y)(lognpdf(y,mu,sigma));
%           figure(1); graphicalComparisonPdf(Y,modelPdf)
%           title('Y ~ LN(mu,sigma)')
%           
%           scale = 0;
%           figure(2); graphicalComparisonPdf(Y,modelPdf,scale)
%           title('Y ~ LN(mu,sigma)')
%

%% Sample as a column vector
X = X(:); 
M = length(X); % Sample size

if (nargin < 6)
    %% Sample max
    xMax = max(X);

    if (nargin < 5)
        %% Sample min
        xMin = min(X);

        if (nargin < 4)
            scale = 1; % default
                if (nargin < 3)
                    nBins = min(sqrt(M),40);     

                end
        end
    end
end


%% Prepare plot of the pdf
nPlot = 1000; 
xPlot = linspace(xMin,xMax,nPlot);
yPlot = modelPdf(xPlot);

%% Area of the histogram

widthHistogram          = max(X)-min(X);  
averageHeightHistogram  = M/nBins;
areaHistogram           = widthHistogram*averageHeightHistogram; 

%% Plots
if scale 
    %% Plot pdf vs scaled histogram
    [barHeight,barCenter] = hist(X,nBins);
    
    %% plot scaled histogram
    bar(barCenter,barHeight/areaHistogram,1); 
    
    %% plot pdf
    hold on
    plot(xPlot,yPlot,'r','LineWidth',1.5);
    hold off
    
    %% Add labels to the plot
    xlabel('x'); ylabel('pdf(x)');
    legend('scaled histogram','pdf(x)')
    axis('tight')
else
    %% Plot histogram vs scaled pdf
    
    % generate the histogram
    hist(X,nBins); 
    
    % plot the scaled pdf
    hold on
    plot(xPlot,yPlot*areaHistogram,'r','LineWidth',1.5); % scale pdf
    hold off;
    
    % add labels to the plot
    xlabel('x'); ylabel('count');
    legend('histogram','scaled pdf(x)')
    axis('tight')
end
