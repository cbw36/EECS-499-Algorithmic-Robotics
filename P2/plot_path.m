function plot_path(nodes1, nodes2)
q_goal1=nodes1(length(nodes1));
q_goal2=nodes2(length(nodes2));
q1=q_goal1;
q2=q_goal2;

figure(1)
title('RRT Path Large Map')

hold on

plot([q_goal1.coord(1), q_goal1.coord(1) - 0.5], [q_goal1.coord(2) - 0.5, q_goal1.coord(2) - 0.5], 'b', 'LineWidth',0.5);
plot([q_goal1.coord(3) - 1, q_goal1.coord(3)], [q_goal1.coord(4) - 0.5, q_goal1.coord(4) - 0.5], 'r', 'LineWidth', 0.5);

plot([q_goal2.coord(1)-1, q_goal2.coord(1)], [q_goal2.coord(2) - 0.5, q_goal2.coord(2) - 0.5], 'b', 'LineWidth',0.5);
plot([q_goal2.coord(3), q_goal2.coord(3)-0.5], [q_goal2.coord(4) - 0.5, q_goal2.coord(4) - 0.5], 'r', 'LineWidth', 0.5);
pause(0.1)

while q1.cost~=0 || q2.cost~=0
    if q1.cost~=0
        figure(1)
        plot([q1.coord(1) - 0.5, q1.parent.coord(1) - 0.5], [q1.coord(2) - 0.5, q1.parent.coord(2) - 0.5], 'b',  'LineWidth',0.5);
        plot([q1.coord(3) - 0.5, q1.parent.coord(3) - 0.5], [q1.coord(4) - 0.5, q1.parent.coord(4) - 0.5], 'r',  'LineWidth',0.5);
         pause(0.0001);
        hold on
        q1=q1.parent;
    end
    if q2.cost~=0;
        figure(1)
        plot([q2.coord(1) - 0.5, q2.parent.coord(1) - 0.5], [q2.coord(2) - 0.5, q2.parent.coord(2) - 0.5], 'b',  'LineWidth',0.5);
        plot([q2.coord(3) - 0.5, q2.parent.coord(3) - 0.5], [q2.coord(4) - 0.5, q2.parent.coord(4) - 0.5], 'r',  'LineWidth',0.5);
         pause(0.0001);
        hold on
        q2=q2.parent;
    end
end

% while q2.cost~=0
%     figure(1)
%     plot([q2.coord(1) - 0.5, q2.parent.coord(1) - 0.5], [q2.coord(2) - 0.5, q2.parent.coord(2) - 0.5], 'b',  'LineWidth',0.5);
%     plot([q2.coord(3) - 0.5, q2.parent.coord(3) - 0.5], [q2.coord(4) - 0.5, q2.parent.coord(4) - 0.5], 'r',  'LineWidth',0.5);
%      pause(0.0001);
%     hold on
%     q2=q2.parent;
% end

figure(1)
hold on
plot([q1.coord(1) - 1, q1.coord(1) - 0.5], [q1.coord(2) - 0.5, q1.coord(2) - 0.5], 'b', 'LineWidth',0.5);
plot([q1.coord(3), q1.coord(3) - 0.5], [q1.coord(4) - 0.5, q1.coord(4) - 0.5], 'r', 'LineWidth',0.5);

plot([q2.coord(1), q2.coord(1) - 0.5], [q2.coord(2) - 0.5, q2.coord(2) - 0.5], 'b', 'LineWidth',0.5);
plot([q2.coord(3)-1, q2.coord(3) - 0.5], [q2.coord(4) - 0.5, q2.coord(4) - 0.5], 'r', 'LineWidth',0.5);

end