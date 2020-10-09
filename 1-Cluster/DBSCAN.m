function [label]=DBSCAN(X,Eps,MinPts)
    [N,~]=size(X);%总点数
    Dis=zeros(N,N);%点与点之间的距离矩阵
    for i=1:N
        for j=1:N
            Dis(i,j)=sqrt(sum((X(i,:)-X(j,:)).^2));%计算距离矩阵
        end
    end
    visited=false(N,1);%是否已经访问
    noise=false(N,1);%是否为噪点
    NEps=zeros(N,N);%每个点的eps半径内的点
    CNum=0;%簇的个数
    label=zeros(N,1);%每个簇的label
    for i=1:N
        tem=find(Dis(i,:)<=Eps);
        NEps(i,1:length(tem))=tem;%寻找每个点EPS半径内的点的下标
    end

    for i=1:N
        if ~visited(i)
            visited(i)=true;
            Neighbors=NEps(i,:);
            Neighbors(Neighbors==0)=[];
            if numel(Neighbors)<MinPts
                noise(i)=true;
            else
                CNum=CNum+1;%添加新类
                label(i)=CNum;
                %访问邻域
                j=1;
                while true%对可达区域内的每一个点
                    t_vis=Neighbors(j);
                    if ~visited(t_vis)
                        visited(t_vis)=true;
                        tem=NEps(t_vis,:);tem(tem==0)=[];
                        if numel(tem)>=MinPts
                            Neighbors=[Neighbors tem];%拓展邻域
                        end
                    end
                    %为样本打标签
                    if label(t_vis)==0
                        label(t_vis)=CNum;
                    end
                    j = j + 1;
                    if j > numel(Neighbors)
                        break;
                    end
                end
            end
        end
    end
end
