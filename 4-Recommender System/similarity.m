function [sim] = similarity(R,para)
%similarity��������CF�����ƶȶ���
%[sim] = similarity(R,para)
%RΪuser-item��rate����
%para=1��ʾ�������ƶȣ�para=2��ʾƤ��ѷ���ƶȣ�para=1��ʾ������Ӧ�����ƶȣ�
[userNum,itemNum]=size(R);
sim=zeros(itemNum,itemNum);%item-item���ƶȾ���
if para==1%�������ƶ�
    for i=1:itemNum
        for j=1:itemNum
            tem_i=[];tem_j=[];tem_num=0;
            for k=1:userNum
                if (R(k,i)>0&&R(k,j)>0)
                    tem_i=[tem_i,R(k,i)];
                    tem_j=[tem_j,R(k,j)];
                    tem_num=tem_num+1;
                end
            end
            if tem_num~=0
                sim(i,j)=(tem_i*tem_j')/(norm(tem_i)*norm(tem_j));
            else
                sim(i,j)=0;
            end
        end
    end
elseif para==2%Ƥ��ѷ���ϵ��
    avgR_item=zeros(itemNum,1);
    for i=1:itemNum
        %��ÿ��item��ƽ���÷�
        avgR_item(i)=sum(R(:,i))/sum(R(:,i)~=0);
    end
    for i=1:itemNum
        for j=1:itemNum
            tem1=0;tem2=0;tem3=0;
            for u=1:userNum
                if (R(u,i)>0&&R(u,j)>0)
                    tem1=tem1+(R(u,i)-avgR_item(i))*(R(u,j)-avgR_item(j));
                    tem2=tem2+(R(u,i)-avgR_item(i)).^2;
                    tem3=tem3+(R(u,j)-avgR_item(j)).^2;
                end
            end
            if tem2==0||tem3==0
                sim(i,j)=0;
            else
                sim(i,j)=tem1/(sqrt(tem2)*sqrt(tem3));
            end
        end
    end
elseif para==3%������Ӧ�����ƶ�
    avgR_user=zeros(userNum,1);
    for i=1:userNum
        avgR_user(i)=sum(R(i,:))/sum(R(i,:)~=0);
    end
    for i=1:itemNum
        for j=1:itemNum
            tem1=0;tem2=0;tem3=0;
            for u=1:userNum
                if (R(u,i)>0&&R(u,j)>0)
                    tem1=tem1+(R(u,i)-avgR_user(u))*(R(u,j)-avgR_user(u));
                    tem2=tem2+(R(u,i)-avgR_user(u)).^2;
                    tem3=tem3+(R(u,j)-avgR_user(u)).^2;
                end
            end
            if tem2==0||tem3==0
                sim(i,j)=0;
            else
                sim(i,j)=tem1/(sqrt(tem2)*sqrt(tem3));
            end
        end
    end
end

