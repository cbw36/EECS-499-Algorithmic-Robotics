% MATLAB Script for Monocular Vision
% Connor Wolfe and Kristina Collins, EECS 499, Spring 2017

%% SECTION I: CAMERA AND OBJECT ORIENTATION
N=50; %Number of particles


%% Step 1: Set webcam calibration parameters
load('webcamParams.mat'); %loads calibration data for HP webcam as the variable cameraParams
camR=[1 0 0; 0 1 0; 0 0 1]; %no rotation from camera to, well, camera
camT=[0;0;0]; %no translation from camera to camera

%% Step 2: Initializa Artificial State of Cube
% First, input artificial state of cube as 4x4 position matrix at t=0
objR=[1 0 0; 0 1 0; 0 0 1]; %Simulated cube rotation at t=0, in mm with camera facing
objT=[-22 -22 300]; % Simulated translation at t=0
objP=rt2dof(objR, objT); %converts to 4x4 position matrix

%Then, initialize keypoints of cube at t=0
obj_3D_keypoints=generateKeypoints(objP, 'camera', 'corners');
obj_2D_keypoints = worldToImage(cameraParams,camR, camT,obj_3D_keypoints);
num_keypoints=size(obj_2D_keypoints, 1);

%% SECTION II: INITIALIZE PARTICLES
%% Step 1: Initializa N=5 Particles
%Initialize at a normal distribution away from input object state
particles=cell(1,N);
for n=1:N
    state_t=zeros(4,4); state_t(4,4)=1;
    for i=1:3
        for j=1:4
            state_t(i,j)=normrnd(objP(i,j),20);
        end
    end
    particles{n}=state_t;
end

%% Step 2: Generate keypoints of initial particles
keypoints_3D=cell(1,N);
keypoints_2D=cell(1,N);
for n=1:N
    keypoints_3D{n}=generateKeypoints(particles{n}, 'camera', 'corners');
    keypoints_2D{n}=worldToImage(cameraParams,camR, camT,keypoints_3D{n});
end

%% Step 3: Weight particles based on distance to image
pi=zeros(1,N);
for n=1:N
    err=0;
    for i=1:num_keypoints
        err=err + sqrt((obj_2D_keypoints(i,1)-keypoints_2D{n}(i,1))^2 + (obj_2D_keypoints(i,2)-keypoints_2D{n}(i,2))^2);
    end
    %pi(n)=exp(err*lambda_e* -1);
    pi(n)=(1/err).^5;
end
%Normalize P
denom=sum(pi);
pi(:)=pi(:)/denom;


%% Step 4: Resample particles based on weights and Plot

ind=1:N;
ind=randsample(ind, N, true, pi);

%Resample following indices above
particles_uf=particles;
keypoints_2D_uf=keypoints_2D;
for n=1:N
    particles{n}=particles_uf{ind(n)};
    keypoints_2D{n}=keypoints_2D_uf{ind(n)};
end

keypoint_avg=zeros(4,4);
for i=1:8
    for j=1:2
        cur_point=0;
        for n=1:N
            cur_point=cur_point+keypoints_2D{n}(i,j);
        end
        keypoint_avg(i,j)=(1/N)*cur_point;
    end
end
%And Plot
for n=1:N
    figure(1)
    hold on
    scatter(obj_2D_keypoints(:,1),obj_2D_keypoints(:,2), 60, 'r.');
    scatter(keypoint_avg(:,1),keypoint_avg(:,2), 60, 'b.');
    title('Weighted Guess After Initialization and Resampling');
    legend('Object', 'Particle Guess');
    hold off
end

%% SECTION III: PARTICLE FILTER
for t=2:1000
    % Step 1: Move the artificial object via normal distribution and get KP
    for i=1:3
        for j=1:4
            objP(i,j)=normrnd(objP(i,j),0.1);
        end
    end
    obj_3D_keypoints=generateKeypoints(objP, 'camera', 'corners');
    obj_2D_keypoints = worldToImage(cameraParams,camR, camT,obj_3D_keypoints);

    
    % Step 2: Motion model
    for n=1:N
        for i=1:3
            for j=1:4
                 particles{n}(i,j)=normrnd( particles{n}(i,j),20);
            end
        end
    end

    % Step 3: Measurement Model
    % Step 3.a: Get keypoints of each particle
    for n=1:N
        keypoints_3D{n}=generateKeypoints(particles{n}, 'camera', 'corners');
        keypoints_2D{n}=worldToImage(cameraParams,camR, camT,keypoints_3D{n});
    end

    % Step 3.b: Calculate weights pi via error of image KP to particle KP
    for n=1:N
        err=0;
        for i=1:num_keypoints
            err=err + sqrt((obj_2D_keypoints(i,1)-keypoints_2D{n}(i,1))^2 + (obj_2D_keypoints(i,2)-keypoints_2D{n}(i,2))^2);
        end
        pi(n)=(1/err).^5;
    end
    
     % Step 3.c: Normalize pi
    denom=sum(pi);
    pi(:)=pi(:)/denom;

    % Step 4: Resampling 
    %Get indices of which weighted selection of X's w replacement we send to next iteration
    ind=1:N;
    ind=randsample(ind, N, true, pi);

    %Redraw particles and keypoints based on indices above
    keypoints_2D_uf=keypoints_2D;
    particles_uf=particles;
    for n=1:N
        particles{n}=particles_uf{ind(n)};
        keypoints_2D{n}=keypoints_2D_uf{ind(n)};
    end
    
    % Step 5: Calculate mean of the particles to guess from this iteration
    keypoint_avg=zeros(4,4);
    for i=1:8
        for j=1:2
            cur_point=0;
            for n=1:N
                cur_point=cur_point+keypoints_2D{n}(i,j);
            end
            keypoint_avg(i,j)=(1/N)*cur_point;
        end
    end

    % Step 6: Plot the guess (plot using particles{1:N} for all particles
    %for n=1:N
    if mod(t,100)==0
        figure(t)
        hold on
        scatter(obj_2D_keypoints(:,1),obj_2D_keypoints(:,2), 60, 'r.');
        scatter(keypoint_avg(:,1),keypoint_avg(:,2), 60, 'b.');
        title(['pi = ' pi(n)]);
        hold off
    %end
    end
   
end