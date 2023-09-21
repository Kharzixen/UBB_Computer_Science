% -----------
% Description
% -----------
% The function evaluates the values of different continuous cumulative distribution 
% functions.
%
% -----
% Input
% -----
% \mathbf{x} = \left[x_i\right]_{i=1}^n - an increasing sequence of real numbers
%
% distribution_type                     - a string that identifies the distribution (e.g., 'exponential', 
%                                         'normal', 'chi2', 'gamma', 'beta', 'Student', etc.)
%
% parameters                            - an array of parameters which characterize the distribution 
%                                         specified by distribution_type
%
% ------
% Output
% ------
% \mathbf{F} = \left[F_i\right]_{i=1}^n = \left[F(x_i)\right]_{i=1}^n - values of the given cumulative distribution function
%
% ----
% Hint
% ----
% Since the input sequence \mathbf{x} = \left[x_i\right]_{i=1}^n \subset \mathbb{R} is increasing it is sufficient to calculate 
% the values
%
% F_1 = \int_{x_{\min}}^{x_1}  f(t) dt,
% F_2 = F_1 + \int_{x_1}^{x_2} f(t) dt, 
% ...,
% F_n = F_{n-1} + \int_{x_{n-1}}^{x_n} f(t) dt,
%
% where f denotes the probability density function that corresponds to F and x_{min}
% represents the minimal value of the random variable (e.g., in case of the gamma  
% distribution x_{min} = 0, while in the case of the normal distribution x_{min} = -inf).
%
function F = ContinuousCDF(x, distribution_type, parameters)
    f=@(x) ContinuousPDF(x , distribution_type , parameters) ; 
    x_min=0 ; 
    switch (distribution_type)
        case 'Normal'
            x_min=-inf ; 
        case 'Gamma'
            x_min=0 ; 
        case 'Exponential'
            x_min = 0 ; 
        case 'Student'
            x_min=x(1)-10^5 ; %x eleme R , végtelen .  
        case 'Uniform'
            x_min=-inf ; 
        case 'Pearson'
            x_min = -inf;
    end
    n=length(x) ; 
    F=zeros(1,n) ; 
    F(1)=integral(f , x_min , x(1)) ; 
    for i=2:n 
        F(i)=F(i-1)+integral(f , x(i-1) , x(i)) ; 
    end
end
