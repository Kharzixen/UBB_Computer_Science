function Y = QuickSortRandomVariable(X)
    if isempty(X)
        Y = [];
        return
    end
    
    if length(X(2,:))<2
        Y = X;
        return
    end
    
    n = length(X(2,:));
    
    x_l = [];
    x_r = [];
    for i = 1:n-1
       if X(2,i)<X(2,n) 
           x_l = [x_l X(:,i)];
       else
           x_r = [x_r X(:,i)];
       end
    end
    Y = [QuickSortRandomVariable(x_l) X(:,n) QuickSortRandomVariable(x_r)];
end

