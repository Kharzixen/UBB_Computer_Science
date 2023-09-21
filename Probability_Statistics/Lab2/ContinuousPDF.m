% -----------
% Description
% -----------
% The function evaluates different continuous probability density functions.
%
% -----
% Input
% -----
% \mathbf{x} = \left[x_i\right]_{i=1}^n - an increasing sequence of real numbers
% distribution_type                     - a string that identifies the distribution (e.g., 'exponential', 
%                                         'normal', 'chi2', 'gamma', 'beta', 'Student', etc.)
% parameters                            - an array of parameters which characterize the distribution 
%                                         specified by distribution_type
%
% ------
% Output
% ------
% \mathbf{f} = \left[f_i\right]_{i=1}^n  = \left[f(x_i)\right]_{i=1}^n} - values of the given probability density function
%
function f = ContinuousPDF(x, distribution_type, parameters)
% for safety reasons
x = sort(x);

% get the size of the input array
n = length(x);
% select the corresponding distribution
switch (distribution_type)
    
    case 'Normal'
        % the N(mu,sigma)-distribution has two parameters, where mu in \mathbb{R} and sigma > 0
        mu    = parameters(1);
        sigma = parameters(2);
        
        % check the validity of the distribution parameters 
        if (sigma <= 0)
            error('The standard deviation must be a strictly positive number!');
        end

        % Allocate memory and evaluate the probability density function f_{N(mu,sigma) 
        % for each element of the input array \mathbf{x} = \left[x_i\right]_{i=1}^n.
        %
        % Note that, in this special case, this can be done in a single line of code,
        % provided that one uses the dotted arithmetical operators of MATLAB.
        
        f = (1.0 / sqrt(2.0 * pi) / sigma) * exp(-(x - mu).^ 2 / 2.0 / sigma^2); 
        
    case 'Gamma'
      a = parameters(1);
      b = parameters(2);
      if(a<=0 || b<=0)
        error('Wrong parameters');
      end
      for i=1:n
        if(x(i)>0)
          f(i)= (1.0/((b^a) * gamma(a))) * x(i)^(a-1) * exp(1)^(- x(i)/b);
        else
          f(i)=0;
        end
      end
      
  case 'Exponential'
      lamda = parameters(1);
      if(lamda<0)
        error('Wrong parameters');
      end
      for i=1:n
        if(x(i)>0)
          f(i)= lamda * (exp(1) ^ (-lamda*x(i)));
        else
          f(i)=0;
        end
      end
      
    case 'Student'
      nn = parameters(1);
      if(nn<1)
        error('Wrong parameters');
      end
      for i=1:n
        f(i)=(gamma((nn+1)/2)/ (sqrt(nn*pi) * gamma(nn/2))) * ((1 + ((x(i)^2)/nn))^(-(nn+1)/2)) ; 
      end
      
    case 'Uniform'
        a=parameters(1) ;
        b=parameters(2) ;
        if(a>b)
            error('Wrong parameters') ; 
        end
        for i=1:n
            if(x(i)>=a && x(i)<=b)
                f(i)=1/(b-a) ;
            else 
                f(i)=0 ; 
            end
        end
        
    case 'Fisher'
      m = parameters(1);
      nn = parameters(2);
      if(nn<=0 || m<=0)
        error('Wrong parameters');
      end
      for i=1:n
        if(x(i)>=0)
          B= gamma(m/2) * gamma(nn/2) / gamma((m+nn)/2);
          f(i)= (1.0/B) * ((m/nn)^(m/2)) * ((x(i)^(m/2 - 1)) / ((1+ (m/nn)*x(i))^((m+nn)/2)));
        else
          f(i)=0;
        end
      end
        
      case 'Pearson'
        nn = parameters(1);
        sigma = parameters(2);
        if(sigma <= 0 || nn < 1)
            error('Wrong parameter! ');
        end
        for i=1:n
           if(x(i) > 0)
               f(i) = (x(i)^((nn/2) - 1)) * exp(1)^(-(x(i)/(2 * (sigma^2)))) / (2^(nn/2) * (sigma^nn) * gamma(nn/2));
           else 
               f(i) = 0;
           end
        end
end