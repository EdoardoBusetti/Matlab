close
clear
clc

%Loading the data into matlab
load Momentum.txt
load Fattori4.txt
load Average_Value_Weighted_Returns

%Defining the variables:

%MOM = Momentum(:,2);
Mkt_RF = Fattori4(:,2);
%SMB = Fattori4(:,3);
%HML = Fattori4(:,4);
Timestamps = Fattori4(:,1);
RF = Fattori4(:,5);

%Defining the matrix X_all of all the factors in the order (Mkt-RF  SMB  HML MOM)
X_all = [Mkt_RF];


%Removing the timestamp from the Returns
Average_Value_Weighted_Returns = Average_Value_Weighted_Returns(:,2:26);

%Number of portfolios
Np = size(Average_Value_Weighted_Returns,2);

%Number of periods
T = size(Average_Value_Weighted_Returns,1);

%Total number of Factors
Nf = size(X_all,2);


%Defining the variable "Y" as the variable containing the returns from all the portfolios

Y = zeros(T,Np);

for i=1:Np
    Y(:,i) = Average_Value_Weighted_Returns(:,i) -RF ;
end;

%===================================================================================
%===================================================================================
%===================================================================================

%Estimating an OLS model for each factor

%The size of each window will be 60 periods
WindowSize = 60;

%The total number of windows
NumWindows = T- WindowSize;

%Reformatting the timestamp into Dates
for i=1:NumWindows
    Dates(i) = datetime(num2str(Timestamps(i+WindowSize)),'InputFormat','yyyyMM','Format','MM/yyyy');
end


%We will have as the result a 3-Dimensional matrix
%The first dimension is for the number of windows that will be considered
%The second dimension is for the number of portfolios considered 
%The third dimension is for the number of factors considered
%The elements in the matrix will be the betas of the regression, we will
%not save the constant term(alpha) since we don't need it.
Theta = zeros(NumWindows,Np);

% j will be the variable that loops trough each factor

    %We define the matrix X as a matrix with a column of ones and a column
    %with the factor "j"
    X = [ones(T,1),X_all(:,1)];
    
    % i is the variable that loops through time to build the windows
    for i=1:NumWindows
        %Building the windows taking all the colums but only the rows from
        %i to i+59 (That is only 60 months)
        Xwindow = X(i:i+(WindowSize-1),:);
        Ywindow = Y(i:i+(WindowSize-1),:);
        
        % k is the variable that loops thourgh the 25 different portfolios
        for k=1:Np
            
            %This estimates the coefficients (Alpha and Beta) for the
            %factor j,the window i and the portfolio k
            coefficients = (Xwindow'*Xwindow)^(-1)*(Xwindow'*Ywindow(:,k));
            Theta(i,k) = coefficients(2);
            %This saves only the Beta coefficient to the slot (i,k,j) of
            %the Theta matrix
            %{
            Example:
            If I'm at the time t=80 (that is the window number 20 (80-60)) of the third portfolio and the second
            factor(SMB) then:
            
            j = 2 (Second Factor -> SMB)
            i = 20 (The window number 20)
            k = 3 (Third portfolio)
            
            The variable coeffients will contain [Alpha_jik   Beta_jik]
            
            Theta(i,k,j) will save only the Bete_jik in the slot (i,k,j) of
            the 3-Dimensional matrix Theta.
            
            %}
        end
    end


%Cleaning Up some useless variables
clearvars Average_Value_Weighted_Returns HML MOM Mkt_RF Momentum RF SMB Timestamps X X3_fattori Xwindow Ywindow coefficients i j k

%===================================================================================
%===================================================================================
%===================================================================================
                                %Part 2
                                
%Doing OLS to regress NumWindows linear models where in each we use the
%extra-returns from the 25 portfolios as the dependent variable and we use
% all the betas from the 4 considered factors as regressors

%Deleting the first 60 observations for Y, that is because we don't have
%parameters(Beta) for them.

Y = Y((WindowSize+1):T,:);
%Transposing Y so that we have 25 rows and NumWindows colums
Y = Y';

Gamma = zeros(NumWindows,(Nf+1));

for i=1:NumWindows
    %the new dependent variable will be a vector (25x1) with the 25 extra-returns
    %for the window i
    Y_new = Y(:,i);
    
    %The new indipendent variables wil be a (25x4) matrix with all the factors
    % for each porfolio considered 

    %adding a column of ones to X_new for the constant term
    X_new = [ones(Np,1) squeeze(Theta(i,:))'];
    
    %Estimating the parameters and setting each row in the matrix Gamma as
    %the estimated parameters for the model excluding the constant term.
    
    coefficients = (X_new'*X_new)^(-1)*X_new'*Y_new;
    Gamma(i,:) = coefficients;
end




%Calculating the average of the Gammas
GammaMeans = mean(Gamma);

%Calculating the standard deviation of the Gammas
GammaStd = zeros(size(GammaMeans));
for i=1:Nf+1
    GammaStd(i)=(std(Gamma(:,i)))/sqrt(NumWindows-1);
end
%Calculating the t_test to test that each variable gamma is significative
%Null Hypotesis: Gamma==0
t_test = GammaMeans./GammaStd;

%Checking if we reject the Null Hypotesis -> with confidence interval 95%
%The test isdistributed as a N(0,1) and it's an asyntotic test
results = abs(t_test)>=1.645;

Names = ["constant","Mkt_RF"];

for i=1:size(Names,2)
    if results(i)==1
        X = ["The variable ",Names(i), "is significative at a 95% confidence level",newline];
        disp(join(X))
    else
        X = ['The variable ',Names(i), ' is NOT significative at a 95% confidence level',newline];
        disp(join(X))
    end
end

%===================================================================================
%===================================================================================
%===================================================================================
      %DIBUJANDO
      