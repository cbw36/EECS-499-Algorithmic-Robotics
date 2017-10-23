function q_rand=random_configuration(q, step_size, q_goal, x_max, y_max)
x1= randi([ceil(normrnd(q.coord(1),step_size)) q.coord(1)+5*step_size],1);
y1 =randi([ceil(normrnd(q.coord(2),step_size)) q.coord(2)+5*step_size],1);
x2= randi([q.coord(3)-5*step_size floor(normrnd(q.coord(3),step_size)) ],1);
y2= randi([q.coord(4)-5*step_size floor(normrnd(q.coord(4),step_size)) ],1);
q_rand_close=[x1 y1 x2 y2];
q_rand=[ randi([1 x_max],1), randi([1, y_max],1),  randi([1,x_max],1), randi([1, y_max]) ];

% q_rand=[ ceil(normrnd(q.coord(1),step_size)) ceil(normrnd(q.coord(2),step_size)) floor(normrnd(q.coord(3),step_size)) floor(normrnd(q.coord(4),step_size)) ];
q_samples=[q_goal.coord; q_rand;];
rand_idx= randsample([1 2], 1, true, [0.05 0.9]);  %%SET WEIGHT HERE
q_rand=q_samples(rand_idx,:);
end

