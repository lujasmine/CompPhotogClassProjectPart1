% Load calibration images
calib_imgs = load_sequence_color('synthetic_data/calibration/', '00', 0, 5, 2, 'png',0);

% Chequerboard position and width and projector resolution
cheq_pos = [378,277];
cheq_width = 270;
proj_res = [768 1024];

% Calculate corner positions of printed images (clockwise corners)
print_corners = [cheq_pos(1), cheq_pos(2);
                cheq_pos(1)+cheq_width, cheq_pos(2);
                cheq_pos(1)+cheq_width, cheq_pos(2)+cheq_width;
                cheq_pos(1), cheq_pos(2)+cheq_width];

% Loop through pairs of images
img_pair = 1;
for i = 1:2:5
    % Calculate camera -> projector homography
    H = calc_homog(calib_imgs(:,:,i), print_corners);
    
    % Apply transformation to printed image to get virtual calibration pattern
    virtual_img = imwarp(calib_imgs(:,:,i+1), H, 'OutputView', imref2d(proj_res));
    
    % Save virtual calibration pattern
    filename = sprintf('synthetic_data/virtual_%i.jpg', img_pair);
    imwrite(virtual_img, filename);
    
    img_pair = img_pair + 1;
end


