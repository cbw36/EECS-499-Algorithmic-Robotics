function [nodes, q_new] = extend_T1(q_i, q_f, map, nodes, step)

dx1=q_f(1)-q_i.coord(1);
dy1=q_f(2)-q_i.coord(2);
dx2=q_f(3)-q_i.coord(3);
dy2=q_f(4)-q_i.coord(4); 
d=[dx1 dy1 dx2 dy2];

if sum(abs(d))>15
    q_new=q_i; 
    nodes=nodes;
elseif collision_path(q_i.coord,q_f, step, map)==1
    q_new=struct;
    q_new.coord=q_f;
    q_new.parent=q_i;
    q_new.cost=q_i.cost+1;
    nodes=[nodes q_new];
else
    q_new=q_i;
    q_old=q_i;
    while sum(abs(d))>0
        q_old=q_new;
        for i=1:4
            if d(i)>step
                q_new.coord(i)= q_old.coord(i) + step;
                d(i)=d(i)-step;

            elseif d(i)<-1*step
                q_new.coord(i)=q_old.coord(i) - step;
                d(i)=d(i)+step;                
            else
                q_new.coord(i)=q_f(i);
                d(i)=0;
            end
        end

        if valid_config(map, q_new.coord)==0 || collision_path(q_new.coord, q_old.coord, step, map)==0
            q_new=nodes(size(nodes,2));
            break
        else
            q_new.parent=q_old;
            q_new.cost=q_old.cost+1;
            nodes=[nodes q_new];
            q_old=q_new;   

        end
    end
end
end



