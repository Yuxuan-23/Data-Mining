clear;
%load('cornell/cornell.mat');  %打开数据总文件
load('texas/texas.mat');
%load('washington/washington.mat');
%load('wisconsin/wisconsin.mat');
[n,~]=size(A);
d=100;
maxiter = 20;
batchNum=50;%边数
K=30;%负采样点数
rho=0.5;
%%
%生成采样度数线段
D=sum(A);%每个点的度数
Dlist=zeros(n,2);%每个点的起点终点
Dlist(1,:)=[0 D(1)];
for i=2:n
	Dlist(i,1)=Dlist(i-1,2) ;
	Dlist(i,2)=Dlist(i,1)+D(i);
end
len=Dlist(n,2);
%%
[X,Y,W]=find(A);
[EdgeNum,~]=size(X);
U2 = rand(n,d); U = rand(n,d);
for it=1:maxiter
	%负采样点
	sample=randperm(len,K);%产生K个随机负采样点
	NegSam=zeros(K,1);%获取采样点
	for i=1:K
		for j=1:n
			if sample(i)>=Dlist(j,1) && sample(i)<= Dlist(j,2)
				NegSam(i)=j;
				break;
			end
        end
    end
	%随机选取一定数量的边
	tem=randperm(EdgeNum,batchNum);
	for i=1:batchNum
		vi=X(tem(i)); vj=Y(tem(i));
		Sum=0;
		for j=1:K
			k=NegSam(j);
			delUk = A(vi,vj)*U2(vi,:)*sigmoid(U(k,:)'*U2(vi,:));
			Sum = Sum + U(k,:)*sigmoid(U(vj,:)'*U2(vi,:));
		end
		delUi=-A(vi,vj)*(U(vj,:)*(1-sigmoid(U(vj,:)'*U2(vi,:)))-Sum);
		delUj=-A(vi,vj)*U2(vi,:)*(1-sigmoid(U(vj,:)'*U2(vi,:)));
		U2(vi,:)=U2(vi,:)-rho*delUi;
		U(vj,:)=U(vj,:)-rho*delUj;
		for j=1:K%更新每一个负点
			k=NegSam(j);
			U(k,:)=U(k,:)-rho*delUk(:,j);
		end
    end		
end
%%
%划分数据集
tem=randperm(n);
trainNum=round(0.8*n);
testNum=n-trainNum;
train_M=zeros(trainNum,d);train_label=zeros(trainNum,1);
test_M=zeros(testNum,d);test_label=zeros(testNum,1);
for i=1:trainNum
    train_M(i,:)=U2(tem(i),:);
    train_label(i)=label(tem(i));
end
for i=1:testNum
    test_M(i,:)=U2(tem(i+trainNum),:);
    test_label(i)=label(tem(i+trainNum));
end
t=templateSVM('Standardize',true);
model=fitcecoc( train_M,train_label,'Learners',t);
predicted_label=predict(model,test_M);
classificationACC(test_label,predicted_label)


