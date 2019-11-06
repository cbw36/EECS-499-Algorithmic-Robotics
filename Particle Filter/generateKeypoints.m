function allKeypoints = generateKeypoints(position, frame, keypoints) 
    %Take in 4x4 position matrix of particle in camera frame, generate
    %keypoints in 3D space 
    %"frame" command indicates whether to return coordinates in cube or
    %camera frame; "keypoints" command indicates which set of keypoints to
    %generate
    %origin=position(1:3, 4); %translation vector in camera frame
    switch(keypoints)
        case('corners')
            cubeFrameKeypoints=22*[0 0 0; 0 0 1; 0 1 0; 0 1 1; 1 0 0; 1 0 1; 1 1 0; 1 1 1];
        case('edges')
            %TODO: change points
            cubeFrameKeypoints=22*[0 0 0; 0 0 1; 0 1 0; 0 1 1; 1 0 0; 1 0 1; 1 1 0; 1 1 1];
        case('faces') %finds the center of each blob of color
            %TODO: change points
            cubeFrameKeypoints=22*[0 0 0; 0 0 1; 0 1 0; 0 1 1; 1 0 0; 1 0 1; 1 1 0; 1 1 1];
        case('centers')
            cubeFrameKeypoints=22*[.5 .5 0; .5 0 .5; 0 .5 0; .5 .5 1; 1 .5 .5; .5 1 .5];
    end
    
    cameraFrameKeypoints=cubeFrameKeypoints; %preallocation
    for i=1:size(cubeFrameKeypoints,1)
         cameraFrameKeypoints(i, :) = (cubeFrameKeypoints(i,:)*position(1:3,1:3) + position(1:3, 4)')';
    end
    %Return 3D points of all corners
    switch(frame)
        case ('cube')
            allKeypoints=cubeFrameKeypoints;
        case('camera')
            allKeypoints=cameraFrameKeypoints;
        otherwise
            allKeypoints=cameraFrameKeypoints;
    end
end