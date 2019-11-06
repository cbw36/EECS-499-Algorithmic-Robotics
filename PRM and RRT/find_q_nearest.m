function q_near = find_q_nearest(nodes, q_goal)
    dist = zeros(1, length(nodes));
    for j = 1:length(nodes)
        new_coord=nodes(j).coord;
        dist(j)= sqrt( (new_coord(1) - q_goal(1)).^2 +  (new_coord(2) - q_goal(2)).^2 + (new_coord(3) - q_goal(3)).^2 + (new_coord(4) - q_goal(4)).^2) ;
    end
    [~, idx] = min(dist);
    q_near = nodes(idx);
end