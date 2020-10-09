clear;
load('cornell/cornell.mat');  %���������ļ�---80
%load('texas/texas.mat');%80
%load('washington/washington.mat');%80
%load('wisconsin/wisconsin.mat');%80
%[W,H]=NMF_EuclideanD(F',5);
%ClusteringMeasure(label_pre,label)
V=A;r=5;
[F_num,N_num]=size(V);%��ȡ�������Լ�������
V=double(V);
W=abs(rand(F_num,r));%�����ʼ������             
H=abs(rand(r,N_num));
maxiter=100;      %����������
lse=10000;%������һ�ε�������ʧ
for i=1:maxiter
    H=H.*((W'*V)./((W'*W)*H));%����W,H
    W=W.*((V*H')./(W*(H*H')));
    X=W*H;
    n_lse(i)=(norm(V-X)).^2;
    if n_lse(i)>=lse%ֹͣ����
        break;
    end
    lse=n_lse(i);
end
[~,index]=max(H);

k=10;
label_pre=Kmeans(H',k);

ClusteringMeasure(label_pre,label)
ClusteringMeasure(index,label)
