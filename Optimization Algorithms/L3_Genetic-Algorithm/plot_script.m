T=readtable('Lab3/output2.txt'); %see attached file
datas=table2array(T);
x=datas(:,1);
y=datas(:,2);
figure(1);
%axis([0 5 0 5]);
hold on;
plot(x,y,'r*');