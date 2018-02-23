% Step 1: 3D Reconstruction

% Load Cube Sequence
fprintf("Loading Sequence...\n");
seq = load_sequence_color('resources/cube_T1', '00', 0, 39, 2, 'png');
fprintf("Done.\n");

[rows,cols,~,n_imgs] = size(seq);
bin_vals = [1,2,4,8,16,32,64,128,256,512];

% Convert to grayscale
for n = 1:size(seq,4)
    seq(:,:,n) = rgb2gray(seq(:,:,:,n));
end

img_index = 1;
diff = zeros(rows, cols, 20);

for k = 1 : n_imgs / 2
    diff(:,:,k) = seq(:,:,img_index) - seq(:,:,img_index + 1);
    img_index = img_index + 2;
end

% TODO filter unknown pixels

diff(diff >= 0) = 1;
diff(diff < 0) = 0;

u_code = zeros(rows,cols);
v_code = zeros(rows,cols);

for i = 1 : rows
    disp(i);
    for j = 1 : cols
        u_code(i,j) = sum(reshape(diff(i,j,1:10),1,10).*bin_vals);
        v_code(i,j) = sum(reshape(diff(i,j,11:20),1,10).*bin_vals);
    end
end
