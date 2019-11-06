numNodes=100;
x_max = 5;
y_max = 6;

q_start.coord = [1, 4, 5,4];
q_start.cost = 0;
q_start.parent = -1;
q_goal.coord = [5 4, 1, 4];
q_goal.cost = 0;

nodes= [q_start];
figure(1)
clf
Cuyahoga=[0 0 0 0 0; 0 0 0 0 0; 1 1 1 1 1; 0 0 1 1 0; 0 0 1 1 0; 0 0 0 0 0];
Cuyahoga=ones(size(Cuyahoga))-(Cuyahoga);
map=robotics.OccupancyGrid(Cuyahoga, 1);
Cuyahoga=flip(Cuyahoga)';
show(map)

step_size=1; 


for n=1:1000
    cur_node=nodes(length(nodes));
    % sample new node 95%random, 5% to goal
    valid=0;
    while valid==0
        q_rand=random_configuration(cur_node, step_size, q_goal, x_max, y_max);
        valid=valid_config(Cuyahoga, q_rand);
    end
    
    %Find nearest node to q_rand
    q_near=find_q_nearest(nodes, q_rand);
    
    %extend q_near to q_rand to yield q_new
    [nodes, q_new]=extend_T1(q_near, q_rand, Cuyahoga, nodes, step_size);

    %Check if reached goal
    if sum(q_new.coord==q_goal.coord)==4
        q_goal=q_new;
        q_goal.parent=q_new.parent;
        break
    end
end

% TRY TO CONNECT TO GOAL
q_near_goal=find_q_nearest(nodes, q_goal.coord);
[nodes q_connect_goal]=extend_T1(q_near_goal, q_goal.coord, Cuyahoga, nodes, step_size);
if sum(q_connect_goal.coord==q_goal.coord)~=4
    disp('NO SOLUTION POSSIBLE')
    
else
    q_connect_goal.parent = q_near_goal;
    q_connect_goal.cost=q_near_goal.cost+1;

    q_goal=q_connect_goal;
    q_goal.parent=q_connect_goal.parent;
    plot_RRT_one_tree(map, q_goal, nodes)
    
end