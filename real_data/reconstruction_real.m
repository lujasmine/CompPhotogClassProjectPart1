% 3D Reconstruction

% Load Sequence
disp('Loading Sequence...');
seq = load_sequence_color('resources/real_crayon_dalek', 'IMG_94', 18, 57, 2, 'JPG', 1);
% seq = load_sequence_color('resources/real_tea', 'IMG_', 9377, 9416, 4, 'JPG', 1);

% Get (u,v) codes
disp('Getting (u,v) codes...');
[u_code, v_code] = get_uv_codes(seq, 1);

% Determine unique depth for each pixel and compute depth-maps
disp('Computing depth map...');
[depth, point_cloud] = compute_depth_map(u_code, v_code, 3);

% Visualise point cloud
% scatter3(point_cloud(:,1),point_cloud(:,2),point_cloud(:,3),'.');