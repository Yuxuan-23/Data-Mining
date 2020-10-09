function [label]=DBSCAN(X,Eps,MinPts)
    [N,~]=size(X);%�ܵ���
    Dis=zeros(N,N);%�����֮��ľ������
    for i=1:N
        for j=1:N
            Dis(i,j)=sqrt(sum((X(i,:)-X(j,:)).^2));%����������
        end
    end
    visited=false(N,1);%�Ƿ��Ѿ�����
    noise=false(N,1);%�Ƿ�Ϊ���
    NEps=zeros(N,N);%ÿ�����eps�뾶�ڵĵ�
    CNum=0;%�صĸ���
    label=zeros(N,1);%ÿ���ص�label
    for i=1:N
        tem=find(Dis(i,:)<=Eps);
        NEps(i,1:length(tem))=tem;%Ѱ��ÿ����EPS�뾶�ڵĵ���±�
    end

    for i=1:N
        if ~visited(i)
            visited(i)=true;
            Neighbors=NEps(i,:);
            Neighbors(Neighbors==0)=[];
            if numel(Neighbors)<MinPts
                noise(i)=true;
            else
                CNum=CNum+1;%�������
                label(i)=CNum;
                %��������
                j=1;
                while true%�Կɴ������ڵ�ÿһ����
                    t_vis=Neighbors(j);
                    if ~visited(t_vis)
                        visited(t_vis)=true;
                        tem=NEps(t_vis,:);tem(tem==0)=[];
                        if numel(tem)>=MinPts
                            Neighbors=[Neighbors tem];%��չ����
                        end
                    end
                    %Ϊ�������ǩ
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
