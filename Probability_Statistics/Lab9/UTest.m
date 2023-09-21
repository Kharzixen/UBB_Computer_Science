% -----------
% Description
% -----------
% The function performs a one-sample U-test of the null hypothesis H_0 : mu = mu_0 that the
% data in the vector {X_j}_{j=1}^n comes from an N(mu,sigma) distribution, where the theoretical 
% mean value mu is unknown and the theoretical standard deviation sigma > 0 is a known
% parameter.
%
% The test is performed against the alternative hypothesis specified by the input  
% parameter tail.
%
% -----
% Input
% -----
% {X_j}_{j=1}^n - an independent and identically distributed sample of the normal distribu- 
%                 tion N(mu,sigma), where the theoretical mean value mu is unknown
% mu_0          - denotes the guess mu_0 of the user for the unknown theoretical mean value mu
% sigma         - stores the known value of theoretical standard deviation sigma > 0
% alpha         - represents the significance level alpha in (0,1)
% tail          - a parameter that can be set either by one of the strings 'both', 'right', 
%                 'left', or by using one of the numbers 0, 1, -1 (it determines the type of 
%                 the alternative hypothesis)
%
% ------
% Output
% ------
% ci_u       - confidence interval for the random variable U_n ~ N(0,1)
% ci_mu      - confidence interval for theoretical mean value mu
% u_value    - value of the test, assuming that the null hypothesis H_0 : mu = mu_0 is true
% p_value    - probability of observing the given result, or one more extreme, by chance 
%              if the null hypothesis H_0 : mu = mu_0 is true (small p-values cast doubt on 
%              the validity of the null hypothesis)
% H          - the code of the accepted hypothesis (0 = null hypothesis, 1 = alternative 
%              hypothesis defined by the input parameter tail)
%
function [ci_u, ci_mu, u_value, p_value, H] = UTest(X, mu_0, sigma, alpha, tail)

% check the validity of input parameters!
...

n = length(X);

s = sigma / sqrt(n);

X_ = mean(X); % or, equivalently, X_ = sum(X) / n;

% calculate the u-value
u_value = (X_ - mu_0) / s;

% determine the confidence intervals and the p-value
switch (tail)
    case {'both', 0}
        u = norminv(1 - alpha / 2, 0, 1);
        
        ci_u(1) = -u;
        ci_u(2) =  u;
        
        ci_mu(1) = X_ - s * u;
        ci_mu(2) = X_ + s * u;
        
        p_value = 2.0 * normcdf(-abs(u_value), 0, 1);
        
    case {'right', 1}
        u = norminv(1 - alpha, 0, 1);
        
        ci_u(1) = -inf;
        ci_u(2) =  u;
        
        ci_mu(1) = X_ - s * u;
        ci_mu(2) = inf;
        
        p_value = 1.0 - normcdf(u_value, 0, 1);
            
    case {'left', -1}
        u = norminv(alpha, 0, 1);
        
        ci_u(1) = u;
        ci_u(2) = inf;
        
        ci_mu(1) = -inf;
        ci_mu(2) = X_ - s * u;
        
        p_value = normcdf(u_value, 0, 1);        
end

% make your decision based on confidence intervals, and note that, the 
% condition (mu_0 > ci_mu(1) && mu_0 < ci_mu(2)) would also be correct!
H = ~(u_value > ci_u(1) && u_value < ci_u(2));

% do you have any doubt? -- if yes, then apply the corresponding significance test!
if (p_value < alpha)
    disp('Warning: small p-value cast doubt on the validity of the null-hypothesis!');
end