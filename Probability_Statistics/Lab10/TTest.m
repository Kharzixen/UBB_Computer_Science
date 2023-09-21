% -----------
% Description
% -----------
% The function performs a one-sample T-test of the null hypothesis H_0 : mu = mu_0 that the data
% in the vector X = {X_j}_{j=1}^n} comes from an N(mu, sigma) distribution, where the theoretical mean 
% value mu in R and the theoretical standard deviation sigma > 0 are unknown parameters.
%
% The test is performed against the alternative hypothesis specified by the input  
% parameter tail.
%
% -----
% Input
% -----
% X = {X_j}_{j=1}^n} - an independent and identically distributed sample of the normal distribu- 
%                      tion N(mu, sigma), where the theoretical mean value mu in R and the theoretical 
%                      standard deviation sigma > 0 are unknown parameters
% mu_0               - denotes the guess mu_0 of the user for the unknown theoretical mean value mu
% alpha              - represents the significance level alpha in (0,1)
% tail               - a parameter that can be set either by one of the strings 'both', 'right', 
%                      'left', or by using one of the numbers 0, 1, -1 (it determines the type of 
%                      the alternative hypothesis)
%
% ------
% Output
% ------
% ci_t       - confidence interval for the random variable T_n
% ci_mu      - confidence interval for theoretical mean value mu
% t_value    - value of the test, assuming that the null hypothesis H_0 : mu = mu_0 is true
% p_value    - probability of observing the given result, or one more extreme, by chance 
%              if the null hypothesis H_0 : mu = mu_0 is true (small p-values cast doubt on 
%              the validity of the null hypothesis)
% H          - the code of the accepted hypothesis (0 = null hypothesis, 1 = alternative 
%              hypothesis defined by the input parameter tail)
%
function [ci_t, ci_mu, t_value, p_value, H] = TTest(X, mu_0, alpha, tail)

% check the validity of input parameters!
...

n = length(X);

% calculate the sample mean
X_ = sum(X) / n; % or, equivalently, X_ = mean(X);

% calculate the sample standard deviation
sigma_ = sqrt(sum((X - X_).^2) / (n-1)); % or, equivalently, sigma_ = sqrt(var(X));

s = sigma_ / sqrt(n);

% calculate the t-value T_n^0
t_value = (X_ - mu_0) / s;

% calculate the confidence intervals and the p-value
switch (tail)
    case {'both', 0}
        t = tinv(1 - alpha/2, n-1);
        
        ci_t(1) = -t;
        ci_t(2) =  t;
        
        ci_mu(1) = X_ - s * t;
        ci_mu(2) = X_ + s * t;
        
        p_value = 2.0 * tcdf(-abs(t_value), n-1);
        
    case {'right', 1}
        t = tinv(1 - alpha, n-1);
        
        ci_t(1) = -inf;
        ci_t(2) =  t;
        
        ci_mu(1) = X_ - s * t;
        ci_mu(2) = inf;
        
        p_value = 1 - tcdf(t_value, n-1);
			            
    case {'left', -1}
        t = tinv(alpha, n-1);
        
        ci_t(1) = t;
        ci_t(2) =  inf;
        
        ci_mu(1) = -inf;
        ci_mu(2) = X_ - s * t;
        
        p_value = tcdf(t_value, n-1);
end

% make your decision based on confidence intervals, and note that, the 
% condition (mu_0 > ci_mu(1) && mu_0 < ci_mu(2)) would also be correct!
H = ~(t_value > ci_t(1) && t_value < ci_t(2));

% do you have any doubt? -- if yes, then apply the corresponding significance test!
if (p_value < alpha)
    disp('Warning: small p-value cast doubt on the validity of the null-hypothesis!');
end