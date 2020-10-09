function [H] = LANE(G,A,Y,d,a1,a2)
%求相似度矩阵
[n,m]=size(A);
S_A=zeros(n,n);S_G=zeros(n,n);
YY=Y*Y';
for i=1:n
    for j=1:n
        S_A(i,j)=A(i,:)*A(j,:)'/(norm(A(i,:)).*norm(A(j,:)));
        S_G(i,j)=G(i,:)*G(j,:)'/(norm(G(i,:)).*norm(G(j,:)));
        S_YY(i,j)=YY(i,:)*YY(j,:)'/(norm(YY(i,:)).*norm(YY(j,:)));
        S_G(isnan(S_G)) = 0.000001;
    end
end
%计算对角矩阵
D_A=eye(n);D_G=eye(n);D_Y=eye(n);
for i=1:n
    D_A(i,i) = sum(S_A(i,:));
    D_G(i,i) = sum(S_G(i,:));
    D_Y(i,i) = sum(S_YY(i,:));
end
%计算拉普拉斯矩阵
L_A = D_A^(-.5)*S_A*D_A^(-.5);
L_G = D_G^(-.5)*S_G*D_G^(-.5);
L_YY= D_Y^(-.5)*S_YY*D_Y^(-.5);
U_A=zeros(n,d);U_Y=zeros(n,d);H=zeros(n,d);
maxiter=10;
J_last=0;
for t=1:maxiter
    M_G=L_G+a1*U_A*U_A'+a2*U_Y*U_Y'+H*H';
    [U_G,~]=eigs(M_G,d);
    M_A=a1*L_A+a1*U_G*U_G'+H*H';
    [U_A,~]=eigs(M_A,d);
    M_Y=a2*L_YY+a2*U_G*U_G'+H*H';
    [U_Y,~]=eigs(M_Y,d);
    M_H=U_G*U_G'+U_A*U_A'+U_Y*U_Y';
    [H,~]=eigs(M_H,d);
    J_A=trace(U_A'*L_A*U_A);
    J_G=trace(U_G'*L_G*U_G);
    J_Y=trace(U_Y'*(L_YY+U_G*U_G')*U_Y);
    J_corr=trace(U_G'*H*H'*U_G)+trace(U_A'*H*H'*U_A)+trace(U_Y'*H*H'*U_Y);
    p1=trace(U_A'*U_G*U_G'*U_A);
    J(t)=(J_G+a1*J_A+a1*p1)+a2*J_Y+J_corr;
end
% t=1:maxiter;
% plot(t,J);



