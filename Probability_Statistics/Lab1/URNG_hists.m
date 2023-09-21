n = 10000;

figure(1);
hold on;

[X,new_initial_value1] = URNG1(2907,n);

subplot(1,2,1)

hist(X);

[X,new_initial_value2] = URNG2(2907,n);

subplot(1,2,2)

hist(X);
