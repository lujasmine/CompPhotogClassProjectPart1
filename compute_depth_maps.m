function [u_depth, u_depth_2] = compute_depth_maps(u_code, v_code)
   
    [rows,cols] = size(u_code);
    u_depth = zeros(rows,cols,3);
    u_depth_2 = zeros(rows,cols,3);
    
    % Load calibration matrices
    synth_calib_matrices()
    
    K_cam = cam_int;
    R_cam = cam_ext(1:3,1:3);
    T_cam = cam_ext(1:3,4);
    
    K_proj = proj_int;
    R_proj = proj_ext(1:3,1:3);
    T_proj = proj_ext(1:3,4);
    
    % Generate extrinsics for alternate camera view
    cam_2_ext = cam_ext;
    rot = [cosd(40), -sind(40), 0;
        sind(40), cosd(40), 0 ;
        0 , 0, 1,] ;
    R_cam_2 = cam_ext(1:3,1:3)*rot;
    cam_2_ext(1:3,1:3) = R_cam_2;
    
    for i = 1 : rows
        for j = 1 : cols
            if (u_code(i,j,1) ~= 1023)
                % Convert pixels to normalized camera/projector coordinates
                p_cam = K_cam\[j;i;1];
                p_proj = K_proj\[v_code(i,j); u_code(i,j);1];

                % Compute linear constraints for the camera
                [a11, a21, b1] = compute_lin_constr(R_cam, T_cam,p_cam);

                % Compute linear constraints for the projector
                [a12, a22, b2] = compute_lin_constr(R_proj, T_proj,p_proj);

                % Stack linear constraints
                A = [a11;a21;a12;a22];
                b = [b1;b2];

                % Least squares solution
                w = A\b;

                % Depth-map
                u_depth(i,j,:) = cam_ext(1:3,1:4)*[w;1];
                u_depth_2(i,j,:) = cam_2_ext(1:3,1:4)*[w;1];
            end
        end
    end
end

function [a1,a2,b] = compute_lin_constr(R,T,p)
    a1 = [R(3,1)*p(1)-R(1,1), R(3,2)*p(1)-R(1,2), R(3,3)*p(1)-R(1,3)];
    a2 = [R(3,1)*p(2)-R(2,1), R(3,2)*p(2)-R(2,2), R(3,3)*p(2)-R(2,3)];
    b = [T(1)-T(3)*p(1); T(2)-T(3)*p(2)];
end