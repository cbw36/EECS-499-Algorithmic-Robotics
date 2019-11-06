function plot_RRT_one_tree(map, q_goal, nodes)
%% FINAL PATHS START
q=q_goal;
figure(1)
title('Path from qstart to qgoal')

hold on
plot([q_goal.coord(1), q_goal.coord(1) - 0.5], [q_goal.coord(2) - 0.5, q_goal.coord(2) - 0.5], 'r', 'LineWidth',0.5);
plot([q_goal.coord(3) - 1, q_goal.coord(3)], [q_goal.coord(4) - 0.5, q_goal.coord(4) - 0.5], 'b', 'LineWidth', 0.5);
pause(0.5)

while q.cost~=0
    figure(1)
    plot([q.coord(1) - 0.5, q.parent.coord(1) - 0.5], [q.coord(2) - 0.5, q.parent.coord(2) - 0.5], 'r',  'LineWidth',0.5);
    plot([q.coord(3) - 0.5, q.parent.coord(3) - 0.5], [q.coord(4) - 0.5, q.parent.coord(4) - 0.5], 'b',  'LineWidth',0.5);
     pause(0.5);
    hold on
    q=q.parent;
end
figure(1)
hold on
plot([q.coord(1) - 1, q.coord(1) - 0.5], [q.coord(2) - 0.5, q.coord(2) - 0.5], 'r', 'LineWidth',0.5);
plot([q.coord(3), q.coord(3) - 0.5], [q.coord(4) - 0.5, q.coord(4) - 0.5], 'b', 'LineWidth',0.5);

%% FINAL PATHS GOAL

%% CSPACE
figure(3)
show(map)
title('CSpace')
plot([q.coord(1) - 1, q.coord(1) - 0.5], [q.coord(2) - 0.5, q.coord(2) - 0.5], 'r', 'LineWidth',0.5);
plot([q.coord(3), q.coord(3) - 0.5], [q.coord(4) - 0.5, q.coord(4) - 0.5], 'b', 'LineWidth',0.5);
hold on
for i=1:length(nodes)
    if nodes(i).cost>0
        plot([nodes(i).coord(1) - 0.5, nodes(i).parent.coord(1) - 0.5] , [nodes(i).coord(2) - 0.5, nodes(i).parent.coord(2) - 0.5 ], 'r','LineWidth', 2)
        plot([nodes(i).coord(3) - 0.5, nodes(i).parent.coord(3) - 0.5], [nodes(i).coord(4) - 0.5, nodes(i).parent.coord(4) - 0.5],'b','LineWidth', 1 )
        hold on
        pause(0.0001)
    end
end
hold on
plot([q_goal.coord(1), q_goal.coord(1) - 0.5], [q_goal.coord(2) - 0.5, q_goal.coord(2) - 0.5], 'r', 'LineWidth',2);
plot([q_goal.coord(3) - 1, q_goal.coord(3)], [q_goal.coord(4) - 0.5, q_goal.coord(4) - 0.5], 'b', 'LineWidth', 1);


