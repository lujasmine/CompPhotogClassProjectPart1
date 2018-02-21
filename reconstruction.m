% Step 1: 3D Reconstruction

% Load Cube Sequence
fprintf("Loading Sequence...\n");
seq = load_sequence_color('resources/cube_T1', '00', 0, 39, 2, 'png');
fprintf("Done.\n");

[rows,cols,~,n_imgs] = size(seq);

% Convert to grayscale
for n = 1:size(seq,4)
    seq(:,:,n) = rgb2gray(seq(:,:,:,n));
end

u_code = zeros(rows,cols);
v_code = zeros(rows,cols);

img_index = 1;
diff = zeros(rows, cols, 10);

for k = 1 : n_imgs / 2
    diff(:,:,k) = seq(:,:,img_index) - seq(:,:,img_index + 1);
    img_index = img_index + 2;
end

% TODO filter unknown picels

diff(diff >= 0) = 1;
diff(diff < 0) = 0;

for i = 1 : rows
    disp(i);
    for j = 1 : cols
        u_str = num2str(diff(i,j,1:10));
        u_code(i,j) = bin2dec(u_str) + 1;
        
        v_str = num2str(diff(i,j,11:20));
        v_code(i,j) = bin2dec(v_str) + 1;
    end
end
