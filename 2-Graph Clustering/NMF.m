clear;
load('cornell/cornell.mat');  %打开数据总文件---80
%load('texas/texas.mat');%80
%load('washington/washington.mat');%80
%load('wisconsin/wisconsin.mat');%80
%[W,H]=NMF_EuclideanD(F',5);
%ClusteringMeasure(label_pre,label)
V=A;r=5;
[F_num,N_num]=size(V);%获取特征数以及样例数
V=double(V);
W=abs(rand(F_num,r));%随机初始化矩阵             
H=abs(rand(r,N_num));
maxiter=100;      %最大迭代次数
lse=10000;%保存上一次迭代的损失
for i=1:maxiter
    H=H.*((W'*V)./((W'*W)*H));%更新W,H
    W=W.*((V*H')./(W*(H*H')));
    X=W*H;
    n_lse(i)=(norm(V-X)).^2;
    if n_lse(i)>=lse%停止条件
        break;
    end
    lse=n_lse(i);
end
[~,index]=max(H);

k=10;
label_pre=Kmeans(H',k);

ClusteringMeasure(label_pre,label)
ClusteringMeasure(index,label)
