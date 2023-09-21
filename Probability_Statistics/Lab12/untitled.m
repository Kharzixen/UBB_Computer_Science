
     X = [10.23, 10.07, 7.89, 14.38, 9.27, 7.65, 12.47, 7.26, 12.92, 13.05, 11.75, 13.85, 9.31, 12.24, 7.89, 13.41, 14.69, 11.01, 7.89, 14.56, 11.38, 9.27, 7.56, 14.92, 13.00, 11.66, 12.75, 13.85, 14.31, 8.64, 14.41, 10.31, 12.66, 13.92, 9.19, 10.12, 7.82, 9.30, 10.23, 9.87, 13.63, 7.35, 12.87, 11.92, 10.56, 9.01, 13.74, 11.34, 8.97, 8.12, 11.98, 13.55, 11.50, 13.00, 8.59, 12.65, 7.71, 8.69, 10.23, 11.02, 10.18, 8.90, 14.87, 11.54, 7.85, 9.92, 13.25, 8.46, 14.96, 10.74, 9.16, 11.63, 10.75, 8.92, 12.04];
    %X = [3.95 6.48 2.86 4.32 0.20 0.12 0.33 11.77 1.22 5.25 3.44 2.41 0.24 3.49 0.07 4.8 0.07 1.42 1.62 2.47 1.44 1.62 6.90 0.12 8.22 0.45 7.06 13.69 2.31 0.50 1.61 6.63 3.99 3.10 0.75 0.07 7.42 0.62 1.76 3.91 6.62 3.39 2.92 8.46 2.11 5.95 3.82 2.16 5.52 4.95 1.93 5.31 0.77 0.07 1.26 4.27 2.15 8.91 0.39 0.51 0.80 0.24 5.38 2.08 15.17 3.42 4.65 7.29 6.89 3.44 9.45 2.05 3.01 1.45 1.43 1.79 13.57 10.71 4.56 2.53];
    hist(X) ; 
    % EXP

        lambda_ = 1 / (mean(X));
        x_min = min(X);
        x_max = max(X);

        n = length(X);
        k = round(1 + log2(n));
        N = hist(X,k);

        tipp = linspace(x_min,x_max,k+1);
        index = 1:k;
        P0(index) = ContinuousCDF(X(index+1),'Exponential',lambda_) - ContinuousCDF(X(index),'Exponential',lambda_);

        n = sum(N);
        alpha = 0.01;

        chi2_value = sum( ( (N-n.*P0).^2 ) ./ (n.*P0) );
        ch2_quantile = chi2inv(1-alpha,k-1);

        if ~(chi2_value < ch2_quantile)
            disp('Exponencialis');
            lambda_
        else
            disp('Nem Exponencialis');
        end

    % Normal

        mu = mean(X);
        sigma = var(X);

        x = linspace(x_min,x_max,k+1);
        index = 1:k;
        P0 = ContinuousCDF(X(index+1),'Normal',[mu,sigma]) - ContinuousCDF(X(index),'Normal',[mu,sigma]);

        chi2_value = sum( ( (N-n.*P0).^2 ) ./ ( n.*P0 ) );
        chi2_quantile = chi2inv(1-alpha,k-1);

        if ~(chi2_value < chi2_quantile)
            disp('Normalis eloszlas');
            [mu,sigma]
        else
            disp('Nem normalis...');
        end

    % UNIFORM

        a = min(X);
        b = max(X);

        x = linspace(x_min,x_max,k+1);
        index = 1:k;
        P0 = ContinuousCDF(X(index+1),'Uniform',[a,b]) - ContinuousCDF(X(index),'Uniform',[a,b]);

        chi2_value = sum( ( (N-n.*P0).^2 ) ./ ( n.*P0 ) );
        chi2_quantile = chi2inv(1-alpha,k-1);

        if (chi2_value < chi2_quantile)
            disp('Uniform')
            [a,b]
        else
            disp('Not Uniform')
        end
