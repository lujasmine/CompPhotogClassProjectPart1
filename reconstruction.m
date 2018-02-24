% 3D Reconstruction

% Load Sequence
disp('Loading Sequence...');
seq = load_sequence_color('resources/tablet_T1', '00', 0, 39, 2, 'png');

% Convert to grayscale
for n = 1:size(seq,4)
    seq(:,:,n) = rgb2gray(seq(:,:,:,n));
end

% Get (u,v) codes
disp('Getting (u,v) codes...');
[u_code, v_code] = get_uv_codes(seq);

% Load calibration matrices
synth_calib_matrices()

% Compute depth map
