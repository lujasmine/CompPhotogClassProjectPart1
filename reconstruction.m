% 3D Reconstruction

% Load Sequence
disp('Loading Sequence...');
seq = load_sequence_color('resources/cube_T1', '00', 0, 39, 2, 'png');
% seq = load_sequence('resources/real_hat', 'IMG_95', 46, 85, 2, 'JPG');

% Convert to grayscale
for n = 1:size(seq,4)
    seq(:,:,n) = rgb2gray(im2double(seq(:,:,:,n)));
end

% Get (u,v) codes
disp('Getting (u,v) codes...');
[u_code, v_code] = get_uv_codes(seq);

% Determine unique depth for each pixel and compute depth-maps
disp('Computing depth map...');
depth = compute_depth_map(u_code, v_code);

imshow(depth);

% Visualise point cloud

% scatter3(point_cloud(:,1),point_cloud(:,2),point_cloud(:,3),'.');