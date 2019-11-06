function [merged nodes1 nodes2] = add_point(nodes1, nodes2, map, step_size, q_goal, x_max, y_max)
    merged=0;
    cur_node=nodes1(length(nodes1));

    valid=0;
    while valid==0
        q_rand=random_configuration(cur_node, step_size, q_goal, x_max, y_max);
        valid=valid_config(map, q_rand);
    end
    
    q_near1=find_q_nearest(nodes1, q_rand);
     
    [nodes1, q_new1]=extend_T1(q_near1, q_rand, map, nodes1, step_size);
    
    q_near2=find_q_nearest(nodes2, q_new1.coord);
    
    [nodes2, q_new2]=extend_T1(q_near2, q_new1.coord, map, nodes2, step_size);
    
    if q_new2.coord==q_new1.coord
        merged=1;
    end
    

end

