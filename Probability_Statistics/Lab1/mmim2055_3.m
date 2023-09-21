n = 100000;
ke_1 = 0;
ke_2 = 0;

gpuDevice(1);
figure(1)
clf(1)
hold on;
xL1 = [6 0];
yL1 = [0 5];
xL2 = [-6 0];
yL2 = [0 -5];
line([0 0], yL1);  
line(xL1, [0 0]);
line([0 0], yL2);  
line(xL2, [0 0]);

Xj=zeros(1,n);
Yj=zeros(1,n);
Xr=zeros(1,n);
Yr=zeros(1,n);
j=1;
k=1;
for i = 1:n
    x = URealRNG(1,3,-5.5,5.5,1);
    y = URealRNG(1,3,-4.5,4.5,1);
    
    % ellipszisben levo pontot generalunk
    while x^2/25 + y^2/16-1 > 0
        x = URealRNG(1,3,-5.5,5.5,1);
        y = URealRNG(1,3,-4.5,4.5,1);
    end
    
    if x+y+3>0 && 3*x+2*y-15< 0 && 3*x-5*y-15<0 && x-y >0 
        ke_1 = ke_1+1;
        Xj(j) = x;
        Yj(j) = y;
        j = j+1;
    else 
        Xr(k)=x;
        Yr(k)=y;
        k=k+1;
    end

end
plot(Xj,Yj,'g.');
plot(Xr,Yr,'r.');

figure(2)
clf(2)
hold on;
xL1 = [6 0];
yL1 = [0 5];
xL2 = [-6 0];
yL2 = [0 -5];
line([0 0], yL1);  
line(xL1, [0 0]);
line([0 0], yL2);  
line(xL2, [0 0]);

Xj=zeros(1,n);
Yj=zeros(1,n);
Xr=zeros(1,n);
Yr=zeros(1,n);
j=1;
k=1;
for i = 1:n
    x = URealRNG(1,3,-5.5,5.5,1);
    y = URealRNG(1,3,-4.5,4.5,1);
    
    % ellipszisben levo pontot generalunk
    while x^2/25 + y^2/16-1 > 0
        x = URealRNG(1,3,-5.5,5.5,1);
        y = URealRNG(1,3,-4.5,4.5,1);
    end
    
    if ((x+3)^2 + y^2 -4 <= 0 || (x-3)^2 + y^2 -4 <= 0) && (x+y+3<0 || x-y+3<0 || x+y-3>0 || x-y-3>0)
        ke_2 = ke_2 + 1;
        Xj(j) = x;
        Yj(j) = y;
        j = j+1;
    else 
        Xr(k) = x;
        Yr(k) = y;
        k = k+1;
    end

end
plot(Xj,Yj,'g.');
plot(Xr,Yr,'r.');

fprintf('\nElso szogfelezo alatt es BCF(1)E-ben: %f%%;\n\n', ke_1/n*100);
fprintf('Valamely kor belsejeben, de a CF(1)DF(2)-n kivul: %f%%;\n\n', ke_2/n*100);