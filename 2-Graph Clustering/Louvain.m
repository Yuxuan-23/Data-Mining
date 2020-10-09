clear;
load('cornell/cornell.mat');
%load('texas/texas.mat');%80
%load('washington/washington.mat');%80
%load('wisconsin/wisconsin.mat');%80
W=A;
N=size(W,1);%点数
m=sum(sum(W))/2;%边权重之和
IDX=1:N;

Ok=5;
Q_max=-10000000;
while 1
    num_c=length(unique(IDX))%当前社区数
    if(num_c==Ok)
        break;
    end
    PRE_IDX=IDX;
    for i=1:N
        bestj=0;
        N=size(W,1);%点数
        for j=1:N
            sumin=0;kiin=0;tot=0;ki=0;
            if(sum(sum(W(find(PRE_IDX==PRE_IDX(i)),find(PRE_IDX==PRE_IDX(j)))))~=0&&PRE_IDX(i)~=PRE_IDX(j))%i和j是邻居
                in_c=find(PRE_IDX==PRE_IDX(j));%当前所有在社区C的点
                in_i=find(PRE_IDX==PRE_IDX(i));%当前所有在社区i的点(将社区i的所有点看成一个节点计算)
                %计算delQ
                for k=1:length(in_c)
                    for t=k+1:length(in_c)
                        sumin=sumin+W(in_c(k),in_c(t));
                    end
                end             
                for k=1:length(in_i)
                    for t=1:length(in_c)
                        kiin=kiin+W(in_i(k),in_c(t));
                    end
                end
                kiin=kiin*2;
                
                for k=1:length(in_c)
                    for t=1:N
                        if(isempty(find(in_c==t)))
                            tot=tot+W(in_c(k),t);
                        end
                    end
                end
                tot=tot+sumin;
                for k=1:length(in_i)
                    for t=1:N
                        if(isempty(find(in_i==t)))
                            ki=ki+W(in_i(k),t);
                        end
                    end
                end
                for k=1:length(in_i)
                    for t=k+1:length(in_i)
                        ki=ki+W(in_i(k),in_i(t));
                    end
                end 
                delQ=(kiin/(2*m))-(tot*ki/(2*m^2));
                if(delQ>Q_max)
                    Q_max=delQ;
                    bestj=j;
                end
            end
        end
        if(Q_max>0)%合并
            IDX(find(PRE_IDX==PRE_IDX(i)))=IDX(bestj);
            break;
        end
    end
    if(IDX==PRE_IDX)
        break;
    end
end
ClusteringMeasure(IDX,label)