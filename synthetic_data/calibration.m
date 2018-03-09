% Load calibration images
calib_imgs = load_sequence_color('resources/calibration', '00', 0, 5, 2, 'png');

% Convert to grayscale
for n = 1:size(calib_imgs,4)
    calib_imgs(:,:,n) = rgb2gray(im2double(calib_imgs(:,:,:,n)));
end

% Chequerboard position and width
cheq_pos = [378,277];
cheq_width = 270;

% Calculate corner positions of printed images (clockwise corners)
print_corners = [cheq_pos(1), cheq_pos(2);
                cheq_pos(1)+cheq_width, cheq_pos(2);
                cheq_pos(1)+cheq_width, cheq_pos(2)+cheq_width;
                cheq_pos(1), cheq_pos(2)+cheq_width];

% Loop through pairs of images
for i = 1:2:5
    % Calculate camera -> projector homography
    H = calc_homog(calib_imgs(:,:,i), print_corners);
    
    % Apply transformation to printed image to get virtual calibration pattern
    virtual_img = imwarp(calib_imgs(:,:,i+1), H);
    
    % Save virtual pattern
    filename = sprintf('virtual_%i.jpg', i);
    imwrite(virtual_img, filename);
end


