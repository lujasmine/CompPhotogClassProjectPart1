% Load calibration images
calib_imgs = load_sequence_color('real_data/real_calibration/', 'IMG_93', 21, 29, 2, 'JPG',1);

% Chequerboard position and width and projector resolution
cheq_pos = [518,120];
cheq_width = 299;
proj_res = [768 1024];

% Calculate corner positions of printed images (clockwise corners)
print_corners = [cheq_pos(1), cheq_pos(2);
                cheq_pos(1)+cheq_width, cheq_pos(2);
                cheq_pos(1)+cheq_width, cheq_pos(2)+cheq_width;
                cheq_pos(1), cheq_pos(2)+cheq_width];

% Loop through pairs of images
for i = 1:size(calib_imgs,3)
    % Calculate camera -> projector homography
    H = calc_homog(calib_imgs(:,:,i), print_corners);
    
    % Apply transformation to printed image to get virtual calibration pattern
    virtual_img = imwarp(calib_imgs(:,:,i), H, 'OutputView', imref2d(proj_res));
    
    % Save virtual calibration pattern
    filename = sprintf('real_data/virtual_%i.jpg', i);
    imwrite(virtual_img, filename);
end


