clear;
file=load('datasets/Spiral_cluster=3.txt');  %打开数据总文件

%Kmeans
%k=10;label=Kmeans(file,k);
%DBSCAN
% Eps=2;
% MinPts=4;
% label=DBSCAN(file,Eps,MinPts);
k=3;
sigma=1;
label=Spectral(file,2,k,sigma);

x=file(:,1);y=file(:,2);      %赋值
scatter(x,y,[],label);