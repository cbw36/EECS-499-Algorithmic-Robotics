% MATLAB Script for Monocular Vision
% Connor Wolfe and Kristina Collins, EECS 499, Spring 2017

%% SECTION I: CAMERA AND OBJECT ORIENTATION
N=100; %Number of particles

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
particles_t2=cell(1,N);
particles_t1=cell(1,N);
A=cell(1,N);
for n=1:N
    state_t1=zeros(4,4); state_t1(4,4)=1;
    state_t2=zeros(4,4); state_t2(4,4)=1;
    for i=1:3
        for j=1:4
            state_t1(i,j)=normrnd(objP(i,j),20);
%             state_t2(i,j)=normrnd(state_t1(i,j),0.1);
            state_t2(i,j)=state_t1(i,j);
        end
    end
    particles_t1{n}=state_t1;
    particles_t2{n}=state_t2;
    A{n}=zeros(4,4);
end

%% Step 2: Generate keypoints of initial particles
keypoints_3D=cell(1,N);
keypoints_2D=cell(1,N);
for n=1:N
    keypoints_3D{n}=generateKeypoints(particles_t1{n}, 'camera', 'corners');
    keypoints_2D{n}=worldToImage(cameraParams,camR, camT,keypoints_3D{n});
end

%% Step 3: Weight particles based on distance to image
lambda_e=-0.001;
pi=zeros(1,N);
for n=1:N
    err=0;
    for i=1:num_keypoints
        err=err + sqrt((obj_2D_keypoints(i,1)-keypoints_2D{n}(i,1))^2 + (obj_2D_keypoints(i,2)-keypoints_2D{n}(i,2))^2);
    end
        pi(n)=(1/err).^5;
end
%Normalize P
denom=sum(pi);
pi(:)=pi(:)/denom;


%% Step 4: Resample particles based on weights and Plot

ind=1:N;
ind=randsample(ind, N, true, pi);

%Iterate particles_t2 to particles_t1 and particles_t1 to particles_t and A based on the indices found above
A_uf=A;
particles_t1_uf=particles_t1;
particles_t2_uf=particles_t2;
keypoints_2D_uf=keypoints_2D;
for n=1:N
    particles_t1{n}=particles_t1_uf{ind(n)};
    particles_t2{n}=particles_t2_uf{ind(n)};
    A{n}=A_uf{ind(n)};
    keypoints_2D{n}=keypoints_2D_uf{ind(n)};

end

%And Plot
for n=1:N
    figure(1);
    hold on
    scatter(obj_2D_keypoints(:,1),obj_2D_keypoints(:,2), 40, 'r.');
    scatter(keypoints_2D{n}(:,1),keypoints_2D{n}(:,2), 40, 'b.');
    title(['pi = ' pi(n)]);
    hold off
end



%% SECTION III: PARTICLE FILTER
% Step 0: Initialize variables
particles_t=cell(1,N);
a=0.1;
lambda_e=-0.001;

for t=1:1000
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
        %First define E(6x4x4) such that each Ei is the ith basis element of se(3).
        E=zeros(4,4,6);
        E(1,4,1)=1; E(2,4,2)=1; E(3,4,3)=1; E(2,3,4)=-1;E(3,2,4)=1; 
        E(1,3,5)=1; E(3,1,5)=-1; E(1,2,6)=-1; E(2,1,6)=1;

        %Next, define e=epsilon_i as a gaussian with mean=0 and covariance=Ew
        e=[normrnd(0,1), normrnd(0,1), normrnd(0,1), normrnd(0,1), normrnd(0,1), normrnd(0,1)];
        dW=zeros(4,4);
        for i=1:6
            dW=dW+ e(i)*E(:,:,i);
        end    
        %Calculate particles_t from particles_t1, A_old, and dW
        particles_t{n}=particles_t1{n} * expm(A{n} + dW);

        %Calculate A_new from particles_t1 and particles_t2
        A{n}=real(a*logm(particles_t2{n}\particles_t1{n}));
    end

    % Step 3: Measurement Model
    % Step 3.a: Get keypoints of each particle
    for n=1:N
        keypoints_3D{n}=generateKeypoints(particles_t{n}, 'camera', 'corners');
        keypoints_2D{n}=worldToImage(cameraParams,camR, camT,keypoints_3D{n});
    end

    % Step 3.b: Calculate weights pi via error of image KP to particle KP
    for n=1:N
        err=0;
        for i=1:num_keypoints
            err=err + sqrt((obj_2D_keypoints(i,1)-keypoints_2D{n}(i,1))^2 + (obj_2D_keypoints(i,2)-keypoints_2D{n}(i,2))^2);
        end
        pi(n)=(1/err).^5;
        if isinf(pi(n))
            pi(n) = 10.^100
        end
        if isnan(pi(n))
            pi(n) = 10.^-100
        end
           
            
    end
    
     % Step 3.c: Normalize pi
    denom=sum(pi);
    pi(:)=pi(:)/denom;

    % Step 4: Resampling 
    %Get indices of which weighted selection of X's w replacement we send to next iteration
    ind=1:N;
    ind=randsample(ind, N, true, pi);

    %Iterate particles_t2 to particles_t1 and particles_t1 to particles_t and A based on the indices found above
    A_uf=A;
    particles_t2=particles_t1;
    keypoints_2D_uf=keypoints_2D;
    for n=1:N
        particles_t1{n}=particles_t{ind(n)};
        A{n}=A_uf{ind(n)};
        keypoints_2D{n}=keypoints_2D_uf{ind(n)};
    end

    % Step 5: Calculate mean of particles as the guess 
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
    
    % Step 6: Plot
    if mod(t,100)==0 
    %for n=1:N
        figure(t);
        hold on
        scatter(obj_2D_keypoints(:,1),obj_2D_keypoints(:,2), 40, 'r.');
        scatter(keypoint_avg(:,1),keypoint_avg(:,2), 40, 'b.');
        title(['pi = ' pi(n)]);
        hold off
    end    
end