clear;
All=load('��С�����ݼ�/train_small.txt');  %���������ļ�
%All=load('��С�����ݼ�/train_small_2.txt');
%%%%%%%%%%movielens���ݼ�/ml-1m%%%%%%%%%%%%%%%%%
% fid = fopen('movielens���ݼ�/ml-1m/ratings.dat');
% FormatString='%f::%f::%f::%*[^\n]';
% All=textscan(fid,FormatString,'HeaderLines',1); %������һ��
% All=cell2mat(All);%cell������ת��Ϊ��ͨ����
% fclose(fid);
%%%%%%%%%%movielens���ݼ�/ml-100k%%%%%%%%%%%%%%%%%
% All=importdata('movielens���ݼ�/ml-100k/ml-100k/u.data');
% All(:,4)=[];
%%
%�������ݼ�
userNum=max(All(:,1));itemNum=max(All(:,2));
[n,~]=size(All);%nΪ��Ԫ��ĸ���
tem=randperm(n);All=All(tem,:);
trainNum=round(0.8*n);
testNum=n-trainNum;
train_R=zeros(userNum,itemNum);%ѵ��Rating����
test_M=zeros(testNum,3);%������Ԫ��
for i=1:trainNum
    train_R(All(i,1),All(i,2))=All(i,3);
end
for i=1:testNum
    test_M(i,:)=All(i+trainNum,:);
end
%%
para=1;
sim=similarity(train_R,para);
%��ʼԤ��
for i=1:testNum
    user=test_M(i,1);
    item=test_M(i,2);
    tem_1=0;tem_2=0;
    for j=1:itemNum
        if sim(item,j)>0&&train_R(user,j)>0
            tem_1=tem_1+sim(item,j)*train_R(user,j);
            tem_2=tem_2+sim(item,j);
        end
    end
    if tem_2~=0
        predict(i)=round(tem_1/tem_2);
    else
        predict(i)=0;
    end
end
%%
tem_3=0;tem_4=0;tem_5=0;
for i=1:testNum
    tem_4=tem_4+(predict(i)-test_M(i,3)).^2;
    tem_5=tem_5+abs(predict(i)-test_M(i,3));
%     if predict(i)>=3 
%         predict(i)=1;
%     else
%         predict(i)=0;
%     end
%     if test_M(i,3)>=3 
%         test_M(i,3)=1;
%     else
%         test_M(i,3)=0;
%     end
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