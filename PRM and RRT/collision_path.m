function valid = collision_path(q1,q2, step_size, map)
    dx1=q2(1)-q1(1);
    dy1=q2(2)-q1(2);
    dx2=q2(3)-q1(3);
    dy2=q2(4)-q1(4); 
    d=[dx1 dy1 dx2 dy2];
    valid=1;
    q_t=q1;
    if sum(abs(d))>10
        valid=0;
    else
        while sum(abs(d))>0
            for i=1:4
                if d(i)>step_size
                    q_t(i)=q_t(i)+step_size;
                    d(i)=d(i)-step_size;
                elseif d(i)< -1*step_size
                    q_t(i)=q_t(i)-step_size;
                    d(i)=d(i)+step_size;
                else
                    q_t(i)=q_t(i);
                    d(i)=0;
                end
            end

            if ((q1(1)+q_t(1))/2==(q1(3)+q_t(3))/2) && ((q1(2)+q_t(2))/2==(q1(4)+q_t(4))/2)
                valid=0;
                break
            elseif (q1(1)==q_t(3) && q1(2)==q_t(4)) || (q1(3)==q_t(1) && q1(4)==q_t(2))
                valid=0;
                break
                
            elseif valid_config(map, q_t)==0
                valid=0;
                break
            else
                valid=1;
            end
            q1=q_t;
        end
    end
end
    
