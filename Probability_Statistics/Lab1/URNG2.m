function [X, new_initial_value] = URNG2(initial_value, n)

m = 2^31-1;
a = 2^16+3;
c = 0;
[X, new_initial_value] = LinearCongruentialGenerator(m, a, c, initial_value, n);
