% -----------
% Description
% -----------
% The function performs a two-sample U-test of the null hypothesis H_0 : mu_1 = mu_2 that the 
% data in the two independent samples X={X_i}_{i=1}^m and Y={Y_j}_{j=1}^n}, of random variables 
% X ~ N(mu_1, sigma_1) and Y ~ N(mu_2, sigma_2), come from distributions with equal theoretical means.
% 
% The test is performed against the alternative hypothesis specified by the input  
% parameter tail.
%
% -----
% Input
% -----
% X={X_i}_{i=1}^m - an independent and identically distributed sample of the normal distribu-
%                   tion N(mu_1, sigma_1), where only the theoretical mean value mu_1 in R is unknown
% Y={Y_j}_{j=1}^n - an independent and identically distributed sample of the normal distribu-
%                   tion N(mu_2, sigma_2), where only the theoretical mean value mu_2 in R is unknown
% sigma_1         - corresponds the known value of theoretical standard deviation sigma_1 > 0 
% sigma_2         - denotes the known value of theoretical standard deviation sigma_2 > 0 
% alpha           - represents the significance level alpha in (0,1)
% tail            - a parameter that can be set either by one of the strings 'both', 'right', 
%                   'left', or by using one of the numbers 0, 1, -1 (it determines the type of 
%                   the alternative hypothesis)
%
% ------
% Output
% ------
% ci_u       - confidence interval for the random variable U_{m,n}
% ci_delta   - confidence interval for the difference delta = mu_1 - mu_2 of the theoretical mean values
% u_value    - value of the test, assuming that the null hypothesis H_0 : mu_1 = mu_2 is true
% p_value    - probability of observing the given result, or one more extreme, by chance 
%              if the null hypothesis H_0 : mu_1 = mu_2 is true (small p-values cast doubt on 
%              the validity of the null hypothesis)
% H          - the code of the accepted hypothesis (0 = null hypothesis, 1 = alternative 
%              hypothesis defined by the input parameter tail)
%
function [ci_u, ci_delta, u_value, p_value, H] = UTest2D(...
    X, Y, sigma_1, sigma_2, alpha, tail)

% check the validity of input parameters!
...

m = length(X);
n = length(Y);

s = sqrt(sigma_1^2 / m + sigma_2^2 / n);

X_Y_ = mean(X) - mean(Y);

% calculate the u-value
u_value = X_Y_ / s;

% calculate the confidence intervals and the p-value
switch (tail)
    case {'both', 0}
        u = norminv(1 - alpha / 2, 0, 1);
        
        ci_u(1) = -u;
        ci_u(2) =  u;
        
        ci_delta(1) = X_Y_ - s * u;
        ci_delta(2) = X_Y_ + s * u;
        
        p_value = 2.0 * normcdf(-abs(u_value), 0, 1);
        
    case {'right', 1}
        u=norminv(1-alpha , 0, 1) ; 
        ci_u(1)=-inf ; 
        ci_u(2)=u ; 
        
        ci_delta(1)=X_Y_-s*u ; 
        ci_delta(2)=inf ;
        p_value=1.0-normcdf(u_value , 0 , 1) ; 
    case {'left', -1}
        u=norminv(alpha , 0 , 1) ; 
        ci_u(1)=u ; 
        ci_u(2)=inf ; 
        
        ci_delta(1)=-inf ; 
        ci_delta(2)=X_Y_-s*u ; 
        
        p_value=normcdf(u_value , 0 , 1) ; 
end

% make your decision based on confidence intervals, and note that, the 
% condition (0 > ci_delta(1) && 0 < ci_delta(2)) would also be correct!
H = ~(u_value > ci_u(1) && u_value < ci_u(2));

% do you have any doubt? -- if yes, then apply the corresponding significance test!
if (p_value < alpha)
    disp('Warning: small p-value cast doubt on the validity of the null-hypothesis!');
end