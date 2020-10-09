clear;
%All=load('很小的数据集/train_small.txt');  %打开数据总文件
%All=load('很小的数据集/train_small_2.txt');
%%%%%%%%%%movielens数据集/ml-1m%%%%%%%%%%%%%%%%%
fid = fopen('movielens数据集/ml-1m/ratings.dat');
FormatString='%f::%f::%f::%*[^\n]';
All=textscan(fid,FormatString,'HeaderLines',1); %跳过第一行
All=cell2mat(All);%cell型数组转换为普通数组
fclose(fid);
%%%%%%%%%%movielens数据集/ml-100k%%%%%%%%%%%%%%%%%
% All=importdata('movielens数据集/ml-100k/ml-100k/u.data');
% All(:,4)=[];
%%
%划分数据集
userNum=max(All(:,1));itemNum=max(All(:,2));
[n,~]=size(All);%n为三元组的个数
tem=randperm(n);All=All(tem,:);
trainNum=round(0.8*n);
testNum=n-trainNum;
train_R=zeros(userNum,itemNum);%训练Rating矩阵
train_M=zeros(trainNum,3);%训练三元组
test_M=zeros(testNum,3);%测试三元组
for i=1:trainNum
    train_R(All(i,1),All(i,2))=All(i,3);
    train_M(i,:)=All(tem(i),:);
end
for i=1:testNum
    test_M(i,:)=All(i+trainNum,:);
end
%%
K=10;
P=rand(userNum,K);Q=rand(K,itemNum);
a=0.00005;%步长
maxiter=200;loss=zeros(1,maxiter);
err_last=2000000000000000000000000;
for t=1:maxiter%迭代更新
    R2=P*Q;
    E=train_R-R2;
    for i=1:userNum
        for j=1:itemNum
            if(train_R(i,j)>0)
                loss(t)=loss(t)+E(i,j).^2;%计算loss
            end
        end
    end
    if(loss(t)>err_last)%若loss开始增加则停止迭代
        break;
    else
        err_last=loss(t);
    end
    %fprintf('loss\t%f\n',loss(t));
    for i=1:userNum
        for j=1:itemNum
            if(train_R(i,j)>0)
                for k=1:K
                    delP=-2*E(i,j)*Q(k,j);
                    delQ=-2*E(i,j)*P(i,k);
                    P(i,k)=P(i,k)-a*delP;
                    Q(k,j)=Q(k,j)-a*delQ;
                end
            end
        end
    end
end
% t=1:maxiter;
% plot(t,loss);
%%
for i=1:testNum
    user=test_M(i,1);
    item=test_M(i,2);
    predict(i)=round(R2(user,item));
    if predict(i)>5 
        predict(i)=5;
    end
end
%%
tem_3=0;tem_4=0;tem_5=0;
for i=1:testNum
    tem_4=tem_4+(predict(i)-test_M(i,3)).^2;
    tem_5=tem_5+abs(predict(i)-test_M(i,3));
    if predict(i)>=3 
        predict(i)=1;
    else
        predict(i)=0;
    end
    if test_M(i,3)>=3 
        test_M(i,3)=1;
    else
        test_M(i,3)=0;
    end
    if(predict(i)==test_M(i,3))
        tem_3=tem_3+predict(i);
    end
end
RMSE=sqrt(tem_4/testNum);
MAE=tem_5/testNum;
precision=tem_3/sum(predict);
recall=tem_3/sum(test_M(:,3));
F1=2*precision*recall/(precision+recall);
fprintf('RMSE\t%f\nMAE\t%f\nprecision\t%f\nrecall\t%f\nF1\t%f\n',RMSE,MAE,precision,recall,F1);