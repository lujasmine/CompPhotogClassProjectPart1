function H = calc_homog(proj_img, p_corners)    
    % Get 4 corners of the chequerboard
    % Select the 4 corners in a clockwise order - press Enter when done
    imshow(proj_img);
    [x, y] = getpts;
    close all;
    
    % Get the geometric transformation using the corners 
    H = fitgeotrans([x y], p_corners,'projective');
end