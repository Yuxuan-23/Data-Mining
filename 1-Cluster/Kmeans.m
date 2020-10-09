function [ label ] = Kmeans(X,k)
    [N,dim]=size(X);%�ܵ���
    c=zeros(N,k);%��i�������Ƿ����ڵ�k��
    u1=zeros(k,dim);%��һ�������ĵ�
    u2=zeros(k,dim);%�¼�������ĵ�
    %�����ʼ�����ĵ�u
%     for i=1:dim %����ÿһ��ά��
%         t_h=max(X(:,i));%��ά�ȷ�Χ����
%         t_l=min(X(:,i));%��ά�ȷ�Χ����
%         u1(:,i)=(t_h-t_l)*rand(k,1);
%     end
    for i=1:k
      u1(i,:)=X(int32(N+(1-N)*rand()),:);
    end
    while true
        c=zeros(N,k);
        t_d=zeros(k,1);
        for i=1:N
            %�����������ÿ���������ĵľ���
            for j=1:k;
                t_d(j)=norm(X(i,:)-u1(j,:),2).^2;
            end
            [~,t_k]=min(t_d);
            c(i,t_k)=1;%�������㻮�ֵ���С�����λ��
        end
        for j=1:k
            u2(j,:)=zeros(1,dim);
            %�����ڵ�K��ĵ�������
            for i=1:N
                u2(j,:)=u2(j,:)+X(i,:).*c(i,j);
            end
            if sum(c(:,j))~=0 
                u2(j,:)=u2(j,:)./sum(c(:,j));
                %���Ե���
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