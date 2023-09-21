a1=0 ; 
b1=1 ; 
a2=-1/2 ; 
b2=1 ; 
X=ElutasitasModszere(a1 , b1 , a2 , b2 , 10000) ; 

figure(1);
subplot(1,2,1) ; 
hist3(X) ; 
hold on
subplot(1,2,2) ;
f = @(x,y) (4/9).*(x.^3 + 2.*x.*y.^2 + 1);
plot3(X(:,1),X(:,2),f(X(:,1),X(:,2)),'.');

figure(2) ; 
subplot(1,2,1) ; 
X1=linspace(0 , 1 , 30) ; 
Y1=linspace(-1/2,1 , 30) ; 
[x , y]=meshgrid(X1,Y1) ; 
mesh(x , y ,(4/9).*(x.^3 + 2.*x.*y.^2 + 1)) ;
subplot(1,2,2) ; 
surf(x , y ,(4/9).*(x.^3 + 2.*x.*y.^2 + 1)) ;
