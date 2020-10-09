function [ label ] = Kmeans(X,k)
    [N,dim]=size(X);%总点数
    c=zeros(N,k);%第i个样本是否属于第k类
    u1=zeros(k,dim);%上一个的中心点
    u2=zeros(k,dim);%新计算的中心点
    %随机初始化中心点u
%     for i=1:dim %对于每一个维度
%         t_h=max(X(:,i));%该维度范围上限
%         t_l=min(X(:,i));%该维度范围下限
%         u1(:,i)=(t_h-t_l)*rand(k,1);
%     end
    for i=1:k
      u1(i,:)=X(int32(N+(1-N)*rand()),:);
    end
    while true
        c=zeros(N,k);
        t_d=zeros(k,1);
        for i=1:N
            %计算样本点和每个聚类中心的距离
            for j=1:k;
                t_d(j)=norm(X(i,:)-u1(j,:),2).^2;
            end
            [~,t_k]=min(t_d);
            c(i,t_k)=1;%将样本点划分到最小距离的位置
        end
        for j=1:k
            u2(j,:)=zeros(1,dim);
            %求属于第K类的点的坐标和
            for i=1:N
                u2(j,:)=u2(j,:)+X(i,:).*c(i,j);
            end
            if sum(c(:,j))~=0 
                u2(j,:)=u2(j,:)./sum(c(:,j));
                %除以点数
            end
        end
        if norm(u1-u2)<0.1
            break;
        else
            u1=u2;
        end
    end
    label=zeros(N,1);
    for i=1:N
        label(i)=find(c(i,:));
    end
end