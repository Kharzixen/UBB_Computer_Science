% -----------
% Description
% -----------
% The function performs a one-sample chi^2-test of the null hypothesis H_0 : sigma^2 = sigma_0^2 that the 
% data in the vector X={X_j}_{j=1}^n comes from an N(mu, sigma) distribution, where the theoretical 
% standard deviation sigma > 0 is an unknown parameter.
%
% The test is performed against the alternative hypothesis specified by the input  
% parameter tail.
%
% -----
% Input
% -----
% $X = {X_j}_{j=1}^n - an independent and identically distributed sample of the normal distribu- 
%                      tion N(mu, sigma), where the theoretical standard deviation sigma >0 is unknown
% sigma_0            - denotes the guess sigma_0 of the user for the unknown theoretical standard 
%                      deviation sigma
% alpha              - represents the significance level alpha in (0,1)
% tail               - a parameter that can be set either by one of the strings 'both', 'right', 
%                      'left', or by using one of the numbers 0, 1, -1 (it determines the type of 
%                      the alternative hypothesis)
%
% ------
% Output
% ------
% ci_chi2    - confidence interval for the random variable V_n
% ci_std     - confidence interval for standard deviation sigma
% chi2_value - value of the test, assuming that the null hypothesis H_0 : sigma^2 = sigma_0^2 is true
% p_value    - probability of observing the given result, or one more extreme, by chance 
%              if the null hypothesis H_0 : sigma^2 = sigma_0^2 is true (small p-values cast doubt on 
%              the validity of the null hypothesis)
% H          - the code of the accepted hypothesis (0 = null hypothesis, 1 = alternative 
%              hypothesis defined by the input parameter tail)
%
function [ci_chi2, ci_std, chi2_value, p_value, H] = Chi2Test(X, sigma_0, alpha, tail)

% check the validity of input parameters!
...

% get the size of the sample X
n = length(X);

% calculate the sample variance
sigma_2_ = var(X);

% calculate the chi2-value V_n^0
chi2_value = (n-1) * sigma_2_ / sigma_0^2;

% calculate the confidence intervals and p-values
switch (tail)
    case {'both', 0}
        ci_chi2(1) =  chi2inv(alpha/2, n-1);
        ci_chi2(2) =  chi2inv(1 - alpha/2, n-1);
        
        ci_std(1) = sqrt((n - 1) * sigma_2_ / ci_chi2(2));
        ci_std(2) = sqrt((n - 1) * sigma_2_ / ci_chi2(1));
        
        probability = chi2cdf(chi2_value, n-1);
        p_value = 2.0 * min(probability, 1 - probability);
        
    case {'right', 1}
       ci_chi2(1)=0 ; 
       ci_chi2(2)=chi2inv(1-alpha , n-1) ; 
       
       ci_std(1)=sqrt((n-1)*sigma_2_/ci_chi2(2)) ; 
       ci_std(2)=inf ; 
       
       probability=chi2cdf(chi2_value , n-1) ; 
       p_value=1-probability ; 
            
    case {'left', -1}
       ci_chi2(1)=chi2inv(alpha , n-1) ; 
       ci_chi2(2)=inf ; 
       
       ci_std(1)=0 ;  
       ci_std(2)=sqrt((n-1)*sigma_2_/ci_chi2(1)) ;
       
       probability=chi2cdf(chi2_value , n-1) ; 
       p_value=probability ; 
end

% make your decision based on confidence intervals, and note that, the 
% condition (sigma_0 > ci_std(1) && sigma_0 < ci_std(2)) would also be correct!
H = ~(chi2_value > ci_chi2(1) && chi2_value < ci_chi2(2));

% do you have any doubt? -- if yes, then apply the corresponding significance test!
if (p_value < alpha)
    disp('Warning: small p-value cast doubt on the validity of the null-hypothesis!');
end