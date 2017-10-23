function matrix=rt2dof(R,t) %Combines rotation matrix and translation vector into a 6DOF matrix
    top=[R, transpose(t)];
    matrix=[top; [0 0 0 1]];
end