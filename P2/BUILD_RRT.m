%% INIT 
% numNodes=100;
% x_max = 5;
% y_max = 6;
% 
% q_start.coord = [1, 4, 5,4];
% q_start.cost = 0;
% q_start.parent = -1;
% q_goal.coord = [5 4, 1, 4];
% q_goal.cost = 0;
% q_goal.parent=-1;
% 
% nodes_i= [q_start];
% nodes_f=[q_goal];
% figure(1)
% clf
% Cuyahoga=[0 0 0 0 0; 0 0 0 0 0; 1 1 1 1 1; 0 0 1 1 0; 0 0 1 1 0; 0 0 0 0 0];
% Cuyahoga=ones(size(Cuyahoga))-(Cuyahoga);
% map=robotics.OccupancyGrid(Cuyahoga, 1);
% Cuyahoga=flip(Cuyahoga)';
% show(map)

step_size=1; 
 
figure(1)
clf
x_max=99;
y_max=99;
q_start.coord=[1,1,99,99];
q_start.cost = 0;
q_start.parent = -1;
q_goal.coord = [99,99,1,1];
q_goal.cost = 0;
q_goal.parent=-1;

nodes_i= [q_start];
nodes_f=[q_goal];

Cuyahoga=ones(100,100);
Cuyahoga(30:70, 30:70)=0;
Cuyahoga(20:40, 15:35)=0;
Cuyahoga(60:80, 40:60)=0;
Cuyahoga=ones(size(Cuyahoga))-(Cuyahoga);
map=robotics.OccupancyGrid(Cuyahoga, 1);
Cuyahoga=flip(Cuyahoga)';
show(map)
%% BUILD ROADMAP
for n=1:10000
    if mod(n,2)==1
        [merged nodes_i nodes_f]=add_point(nodes_i, nodes_f, Cuyahoga, step_size, q_goal, x_max, y_max);
    else
        [merged nodes_f nodes_i]=add_point(nodes_f, nodes_i, Cuyahoga, step_size, q_start, x_max, y_max);
    end
    if merged==1
        plot_path(nodes_i, nodes_f);
        plot_RRT(map, nodes_i, nodes_f);
        break
    end
end

if merged==0
    disp('NO SOLUTION');
    plot_RRT(map, nodes_i, nodes_f);
    figure(1)
    show(map)
    hold on
end


