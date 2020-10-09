clear;
%load('cornell/cornell.mat');  %���������ļ�
load('texas/texas.mat');
% load('washington/washington.mat');
 %load('wisconsin/wisconsin.mat');
W=A;
[N,~]=size(W);
k1=10;k2=50;
%����ԽǾ���
D=eye(N);
for i=1:N
    D(i,i) = sum(W(i,:));
end
%����������˹����
L=D-W;L = D^(-.5)*L*D^(-.5);
% %��������ֵ��������
[eigVectors,V] = eigs(L,k1,'SA');
% �����һ������U�ӻ�õ���������
for i=1:N
    n = sqrt(sum(eigVectors(i,:).^2));    
    U(i,:) = eigVectors(i,:) ./ n; 
end
Label=Kmeans(U,k2);
%%%%%%%%%%%%%%%%%%%%%%%%
%�ϲ�
k=5;%Ŀ��������
it=1;
while(1)
    pre_label=Label;
    m_cl=unique(pre_label);%����ϲ����дصı��
    kNum=length(unique(pre_label));%��ǰ���м�����
    if(kNum==k)
        break;
    end
    ncut=zeros(N,3);
    for i=1:kNum %ѡȡ�����غϲ�
        for j=i+1:kNum
            Ncutk=0;
            pre_label(find(pre_label==m_cl(j)))=m_cl(i);
            tmp=m_cl(j);%��ǰ��ѡ�����Ĵ�
            m_cl(j)=[];
            %����Ncutkֵ
            for v=1:kNum-1 
                in_v=find(pre_label==m_cl(v)); %��v����ĵ�
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
    ncut=sortrows(ncut,3); %��������;
	[ib,jb,~]=ncut(1,:);
    Label(find(Label==jb))=ib;%�ϲ��࣬���ı�ǩ
    it=it+1;
end
 ClusteringMeasure(Label,label)
