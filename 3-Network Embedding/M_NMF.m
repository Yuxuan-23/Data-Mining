clear;
load('cornell/cornell.mat');  %打开数据总文件
%load('texas/texas.mat');
%load('washington/washington.mat');
%load('wisconsin/wisconsin.mat');
%%
%求相似度矩阵
[n,~]=size(A);
S=zeros(n,n);
for i=1:n
    for j=1:n
        S(i,j)=A(i,:)*A(j,:)'/(norm(A(i,:)).*norm(A(j,:)));
    end
end
S=A+5*S;%相似度矩阵
%%
%求B1,B
k=sum(A);%每个点的度数
Enum=sum(k);B1=zeros(n,n);
for i=1:n
    for j=1:n
        B1(i,j)=k(i)*k(j)/Enum;
    end
end
B=A-B1;
%%
k=5;%社区数
m=100;%每个点表示的维数
U=rand(n,m);%表示矩阵
M=rand(n,m);%基矩阵
C=rand(k,m);%社区表示矩阵
H=rand(n,k);%对第i行，若第j列为1则属于该社区，其他列为0
maxiter=30; %最大迭代次数
a=1;b=5;la=10.^9;
for i=1:maxiter
    M=M.*((S*U)./(M*(U'*U)));
    U=U.*((S'*M+a*H*C)./(U*(M'*M+a.*C'*C)));
    C=C.*((H'*U)./(C*(U'*U)));
    Del=2*b*(B1*H).*(2*b*(B1*H))+16*la*((H*H')*H).*(2*b*A*H+2*a*U*C'+(4*la-2*a)*H);
    H=H.*sqrt((-2*b*B1*H+sqrt(Del))./(8*la*(H*H')*H));
    Obj(i)=norm(S-M*U','fro').^2+a*norm(H-U*C','fro').^2-b*trace(H'*B*H);
end
%%
%划分数据集
tem=randperm(n);
trainNum=round(0.8*n);
testNum=n-trainNum;
train_M=zeros(trainNum,m);train_label=zeros(trainNum,1);
test_M=zeros(testNum,m);test_label=zeros(testNum,1);
for i=1:trainNum
    train_M(i,:)=U(tem(i),:);
    train_label(i)=label(tem(i));
end
for i=1:testNum
    test_M(i,:)=U(tem(i+trainNum),:);
    test_label(i)=label(tem(i+trainNum));
end
t=templateSVM('Standardize',true);
model=fitcecoc( train_M,train_label,'Learners',t);
predicted_label=predict(model,test_M);
classificationACC(test_label,predicted_label)
% model = libsvmtrain(train_label,train_M, '-c 1 -g 0.07');
% [predict_label, accuracy, dec_values] = libsvmpredict(test_label,test_M, model);

