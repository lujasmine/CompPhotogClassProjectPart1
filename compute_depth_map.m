% options:
% 1 = synthetic data with given matrices
% 2 = synthetic data with own calibration
% 3 = real data
% 4 = own data

function [u_depth, point_cloud] = compute_depth_map(u_code, v_code, option)
   
    [rows,cols] = size(u_code);
    u_depth = zeros(rows,cols,3);
    
    % Load calibration matrices
    if (option == 1)
        synth_calib_matrices();
    elseif (option == 2)
        synth_calib_matrices_2();
    elseif (option == 3)
        real_calib_matrices();
    elseif (option == 4)
        synth_calib_matrices_own();
    else
        err('Option number error. Please try again!');
    end
    
    index = 1;
    point_cloud = zeros(rows * cols, 3);
    
    for i = 1 : rows
        disp(i);
        for j = 1 : cols
            if (u_code(i,j,1) ~= 1023)
                % Convert pixels to normalized camera/projector coordinates
                x_cam = cam_int\[j;i;1];
                x_proj = proj_int\[v_code(i,j); u_code(i,j);1];

                % Compute linear constraints for the camera
                [a11, a21, b1] = compute_lin_constr(cam_ext(1:3,1:3), cam_ext(1:3,4),x_cam);

                % Compute linear constraints for the projector
                [a12, a22, b2] = compute_lin_constr(proj_ext(1:3,1:3), proj_ext(1:3,4),x_proj);

                % Stack linear constraints
                A = [a11;a21;a12;a22];
                b = [b1;b2];

                % Least squares solution
                w = A\b;

                % Unique depth for each pixel --> depth map
                u_depth(i,j,:) = cam_ext*[w;1];
                
                % Add 3D point to point cloud
                point_cloud(index,:) = w;
                index = index + 1;
            end
        end
    end
end

function [a1,a2,b] = compute_lin_constr(R,T,p)
    a1 = [R(3,1)*p(1)-R(1,1), R(3,2)*p(1)-R(1,2), R(3,3)*p(1)-R(1,3)];
    a2 = [R(3,1)*p(2)-R(2,1), R(3,2)*p(2)-R(2,2), R(3,3)*p(2)-R(2,3)];
    b = [T(1)-T(3)*p(1); T(2)-T(3)*p(2)];
end