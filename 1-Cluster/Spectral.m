function [label] = Spectral(X,k1,k2,sigma)
    [N,~]=size(X);
    %计算相似矩阵
    W=zeros(N,N);
    for i=1:N
        for j=1:N
            W(i,j)= exp(-(norm(X(i,:)-X(j,:))).^2)/(2*sigma^2); 
        end
    end
    %计算对角矩阵
    D=eye(N);
    for i=1:N
        D(i,i) = sum(W(i,:));
    end
    %计算拉普拉斯矩阵
    L=D-W;
    L = D^(-.5)*L*D^(-.5);
    % %计算特征值特征向量
    [eigVectors,~] = eigs(L,k1,'SM');
    % 构造归一化矩阵U从获得的特征向量
    for i=1:N
        n = sqrt(sum(eigVectors(i,:).^2));    
        U(i,:) = eigVectors(i,:) ./ n; 
    end
    label=Kmeans(U,k2);
end

