clear;
%load('cornell/cornell.mat');  %打开数据总文件
load('texas/texas.mat');
% load('washington/washington.mat');
 %load('wisconsin/wisconsin.mat');
W=A;
[N,~]=size(W);
k1=10;k2=50;
%计算对角矩阵
D=eye(N);
for i=1:N
    D(i,i) = sum(W(i,:));
end
%计算拉普拉斯矩阵
L=D-W;L = D^(-.5)*L*D^(-.5);
% %计算特征值特征向量
[eigVectors,V] = eigs(L,k1,'SA');
% 构造归一化矩阵U从获得的特征向量
for i=1:N
    n = sqrt(sum(eigVectors(i,:).^2));    
    U(i,:) = eigVectors(i,:) ./ n; 
end
Label=Kmeans(U,k2);
%%%%%%%%%%%%%%%%%%%%%%%%
%合并
k=5;%目标社区数
it=1;
while(1)
    pre_label=Label;
    m_cl=unique(pre_label);%保存合并后还有簇的编号
    kNum=length(unique(pre_label));%当前还有几个类
    if(kNum==k)
        break;
    end
    ncut=zeros(N,3);
    for i=1:kNum %选取两个簇合并
        for j=i+1:kNum
            Ncutk=0;
            pre_label(find(pre_label==m_cl(j)))=m_cl(i);
            tmp=m_cl(j);%当前被选出来的簇
            m_cl(j)=[];
            %计算Ncutk值
            for v=1:kNum-1 
                in_v=find(pre_label==m_cl(v)); %在v里面的点
                assoc=0;
                for p=1:length(in_v)
                    for q=in_v(p)+1:N
                        assoc=assoc+W(in_v(p),q);
                    end
                end
                cut=0;
                in_t=[];
                for t=1:N
                    if(pre_label(t)~=m_cl(v))
                        in_t=[in_t;t];
                    end
                end
                for p=1:length(in_v)
                    for q=1:length(in_t)
                        cut=cut+W(in_v(p),in_t(q));
                    end
                end
                Ncutk=Ncutk+cut/assoc;           
            end
            m_cl=[m_cl(1:j-1);tmp;m_cl(j:kNum-1)];
            pre_label=Label;
            ncut(it,:)=[m_cl(i) m_cl(j) Ncutk];
        end
    end
    ncut=sortrows(ncut,3); %升序排列;
	[ib,jb,~]=ncut(1,:);
    Label(find(Label==jb))=ib;%合并类，更改标签
    it=it+1;
end
 ClusteringMeasure(Label,label)
