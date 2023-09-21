figure(1);
hold on;
seed = 2907;

[X,new_seed1] = URealRNG(seed, 'URNG1', 0,100,10000);
subplot(1,2,1)
hist(X);

[X,new_seed2] = URealRNG(seed, 'URNG2', 0,100,10000);
subplot(1,2,2)
hist(X);

figure(2)
hold on;
[X,new_seed3] = URealRNG(seed, 3, 0,100,10000);
subplot(2,2,1)
hist(X);

[X,new_seed4] = URealRNG(seed, 4 , 0,100,10000);
subplot(2,2,2)
hist(X);