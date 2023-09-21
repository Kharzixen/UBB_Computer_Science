% -----------
% Description
% -----------
% The function evaluates the values of different discrete cumulative distribution 
% functions.
%
% -----
% Input
% -----
% \mathbf{x} = \left[x_i\right]_{i=1}^n - an increasing sequence of positive integers
%
% distribution_type                     - a string that identifies the distribution (e.g., 'Bernoulli', 
%                                         'binomial', 'Poisson', 'geometric', etc.)
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
% Since the input sequence \mathbf{x} = \left[x_i\right]_{i=1}^n\subset \mathbb{N} is increasing it is sufficient to calculate 
% the values
%
% F_1 = \sum_{i=i_{min}}^{x_1} f(i),
% F_2 = F_1 + \sum_{i = x_1 + 1}^{x_2} f(i), 
% ...
% F_n = F_{n-1}+\sum_{i = x_{n-1}+1}^{x_n} f(i),
%
% where f denotes the probability density function that corresponds to F and i_{min}
% represents the minimal integer value of the distribution (e.g., in case of the  
% geometric distribution i_{min} = 1, while in the case of the Poisson distribution i_{min} = 0}).
%
function F = DiscreteCDF(x, distribution_type, parameters)
    f=@(x) DiscretePDF(x , distribution_type , parameters) ; 
    x_min=0 ; 
    switch (distribution_type)
        case 'Bernuolli'
            x_min=0 ; 
        case 'Hypergeometric'
            x_min = max(0,parameters(3)-parameters(1)+parameters(2));
        case 'Pascal'
            x_min=0 ; 
        case 'Poisson'
            x_min=0 ; 
        case 'Sajat'
            x_min=0 ; 
        case 'Binomial'
            x_min = 0;
    end
    n=length(x) ; 
    F=zeros(1,n) ; 
    F(1)=sum(f(x_min:x(1))) ; 
    for i=2:n 
        F(i)=F(i-1)+sum(f(x(i-1)+1:x(i))) ; 
    end
end
