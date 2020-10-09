function [label] = Spectral(X,k1,k2,sigma)
    [N,~]=size(X);
    %�������ƾ���
    W=zeros(N,N);
    for i=1:N
        for j=1:N
            W(i,j)= exp(-(norm(X(i,:)-X(j,:))).^2)/(2*sigma^2); 
        end
    end
    %����ԽǾ���
    D=eye(N);
    for i=1:N
        D(i,i) = sum(W(i,:));
    end
    %����������˹����
    L=D-W;
    L = D^(-.5)*L*D^(-.5);
    % %��������ֵ��������
    [eigVectors,~] = eigs(L,k1,'SM');
    % �����һ������U�ӻ�õ���������
    for i=1:N
        n = sqrt(sum(eigVectors(i,:).^2));    
        U(i,:) = eigVectors(i,:) ./ n; 
    end
    label=Kmeans(U,k2);
end

