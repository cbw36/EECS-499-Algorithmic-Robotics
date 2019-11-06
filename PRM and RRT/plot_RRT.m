function plot_RRT(map, nodes1, nodes2)
%% FINAL PATHS START
q_goal1=nodes1(length(nodes1));
q_goal2=nodes2(length(nodes2));
q1=q_goal1;
q2=q_goal2;

%% CSPACE
figure(3)
title('RRT CSpace Large Map')
show(map)
hold on
plot([q1.coord(1) - 1, q1.coord(1) - 0.5], [q1.coord(2) - 0.5, q1.coord(2) - 0.5], 'r');
plot([q1.coord(3), q1.coord(3) - 0.5], [q1.coord(4) - 0.5, q1.coord(4) - 0.5], 'b');
hold on
for i=1:length(nodes1)
    if nodes1(i).cost>0
        plot([nodes1(i).coord(1) - 0.5, nodes1(i).parent.coord(1) - 0.5] , [nodes1(i).coord(2) - 0.5, nodes1(i).parent.coord(2) - 0.5 ], 'r')
        plot([nodes1(i).coord(3) - 0.5, nodes1(i).parent.coord(3) - 0.5], [nodes1(i).coord(4) - 0.5, nodes1(i).parent.coord(4) - 0.5],'b' )
        hold on
        pause(0.0001)
    end
end
hold on

plot([q_goal1.coord(1), q_goal1.coord(1) - 0.5], [q_goal1.coord(2) - 0.5, q_goal1.coord(2) - 0.5], 'r', 'LineWidth',2);
plot([q_goal1.coord(3) - 1, q_goal1.coord(3)], [q_goal1.coord(4) - 0.5, q_goal1.coord(4) - 0.5], 'b', 'LineWidth', 1);
hold on

plot([q2.coord(1), q2.coord(1) - 0.5], [q2.coord(2) - 0.5, q2.coord(2) - 0.5], 'r');
plot([q2.coord(3)-1, q2.coord(3) - 0.5], [q2.coord(4) - 0.5, q2.coord(4) - 0.5], 'b');
hold on
for i=1:length(nodes2)
    if nodes2(i).cost>0
        plot([nodes2(i).coord(1) - 0.5, nodes2(i).parent.coord(1) - 0.5] , [nodes2(i).coord(2) - 0.5, nodes2(i).parent.coord(2) - 0.5 ], 'r')
        plot([nodes2(i).coord(3) - 0.5, nodes2(i).parent.coord(3) - 0.5], [nodes2(i).coord(4) - 0.5, nodes2(i).parent.coord(4) - 0.5],'b')
        hold on
        pause(0.0001)
    end
end
hold on
plot([q_goal2.coord(1), q_goal2.coord(1) - 1], [q_goal2.coord(2) - 0.5, q_goal2.coord(2) - 0.5], 'r');
plot([q_goal2.coord(3), q_goal2.coord(3)], [q_goal2.coord(4) - 0.5, q_goal2.coord(4) - 0.5], 'b');

