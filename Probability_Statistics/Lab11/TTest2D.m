% -----------
% Description
% -----------
% The function performs a two-sample T-test of the null hypothesis H_0 : mu_1 = mu_2 that the 
% data in the two independent samples X = {X_i}_{i=1}^m and Y = {Y_j}_{j=1}^n, of random variables 
% X ~ N(mu_1, sigma_1) and Y ~ N(mu_2, sigma_2), come from distributions with equal theoretical means
% with unknown (and not necessarily equal) theoretical standard deviations.
%
% The test is performed against the alternative hypothesis specified by the input  
% parameter tail.
%
% -----
% Input
% -----
% X = {X_i}_{i=1}^m - an independent and identically distributed sample of the normal distribu- 
%                     tion N(mu_1, sigma_1), where both parameters mu_1 in R and sigma_1 > 0 are unknown
% Y = {Y_j}_{j=1}^n - an independent and identically distributed sample of the normal distribu- 
%                     tion  N(mu_2, sigma_2), where both parameters mu_2 in R and sigma_2 > 0 are unknown
% equal_std         - a boolean variable which specifies whether the unknown standard deviations 
%                     sigma_1 and sigma_2 are equal
% alpha             - represents the significance level alpha in (0,1)
% tail              - a parameter that can be set either by one of the strings 'both', 'right', 
%                     'left', or by using one of the numbers 0, 1, -1 (it determines the type of 
%                     the alternative hypothesis)
%
% ------
% Output
% ------
% ci_t       - confidence interval for the random variable T_{m,n}
%
% ci_delta   - confidence interval for the difference delta = mu_1 - mu_2 of the theoretical mean values
% t_value    - value of the test, assuming that the null hypothesis H_0 : mu_1 = mu_2 is true
% p_value    - probability of observing the given result, or one more extreme, by chance 
%              if the null hypothesis H_0 : mu_1 = mu_2 is true (small p-values cast doubt on
%              the validity of the null hypothesis)
% H          - the code of the accepted hypothesis (0 = null hypothesis, 1 = alternative 
%              hypothesis defined by the input parameter tail)
%
function [ci_t, ci_delta, t_value, p_value, H] = TTest2D(X, Y, equal_std, alpha, tail)

% check the validity of input parameters!
...

% get the size of the given samples 
m = length(X);
n = length(Y);

sigma_1_2_ = var(X);
sigma_2_2_ = var(Y);

if (equal_std)
    s = sqrt(((m-1) * sigma_1_2_ + (n-1) * sigma_2_2_) * (m + n) / m / n / (m + n - 2));
else
    s = sqrt(sigma_1_2_ / m + sigma_2_2_ / n);
end

% determine the degree of freedom eta
if (equal_std)
    eta = m + n - 2;
else
    w = n * sigma_1_2_ / (n * sigma_1_2_ + m * sigma_2_2_);
    eta = (m - 1) * (n - 1) / ((m - 1) * (1 - w)^2 + (n - 1) * w^2);
end

X_Y_ = mean(X) - mean(Y);

% calculate the t-value T_{m,n}^0
t_value = X_Y_ / s;

% calculate the confidence intervals
switch (tail)
    case {'both', 0}
        t = tinv(1 - alpha / 2, eta);
        
        ci_t(1) = -t;
        ci_t(2) =  t;
        
        ci_delta(1) = X_Y_ - s * t;
        ci_delta(2) = X_Y_ + s * t;
        
        p_value = 2.0 * tcdf(-abs(t_value), eta);
        
    case {'right', 1}
         t = tinv(1 - alpha, eta);
        
        ci_t(1) = -inf;
        ci_t(2) =  t;
        
        ci_delta(1) = X_Y_ - s * t;
        ci_delta(2) = inf;
        
        p_value = 1 - tcdf(t_value, eta);
    case {'left', -1}
         t = tinv(alpha, eta);
        
        ci_t(1) = t;
        ci_t(2) = inf;
        
        ci_delta(1) = -inf;
        ci_delta(2) = X_Y_ - s * t;
        
        p_value = tcdf(t_value, eta);
end

% make your decision based on confidence intervals, and note that, the 
% condition (0 > ci_delta(1) && 0 < ci_delta(2)) would also be correct!
H = ~(t_value > ci_t(1) && t_value < ci_t(2));

% do you have any doubt? -- if yes, then apply the corresponding significance test!
if (p_value < alpha)
    disp('Warning: small p-value cast doubt on the validity of the null-hypothesis!');
end