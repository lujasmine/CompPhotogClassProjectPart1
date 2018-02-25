% 3D Reconstruction

% Load Sequence
disp('Loading Sequence...');
seq = load_sequence_color('resources/monkey_T1', '00', 0, 39, 2, 'png');

% Convert to grayscale
for n = 1:size(seq,4)
    seq(:,:,n) = rgb2gray(seq(:,:,:,n));
end

% Get (u,v) codes
disp('Getting (u,v) codes...');
[u_code, v_code] = get_uv_codes(seq);

% Determine unique depth for each pixel and compute depth-maps
disp('Computing depth maps...');
[u_depth_cam, u_depth_alt] = compute_depth_maps(u_code, v_code);