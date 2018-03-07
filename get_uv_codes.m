function [u_code, v_code] = get_uv_codes(seq)
    
    [rows,cols,n_imgs] = size(seq);
    
    img_index = 1;
    diff = zeros(rows, cols, 20);
    
    % Calculate differences between each image and it's inverse
    disp(' - Calculating differences between image/inverse')
    for k = 1 : n_imgs / 2
        diff(:,:,k) = seq(:,:,img_index) - seq(:,:,img_index + 1);
        img_index = img_index + 2;
    end
    
    % Label pixels with 1 or 0 depending if image/inverse is brighter
    bin_label = diff;
    bin_label(bin_label >= 0) = 1;
    bin_label(bin_label < 0) = 0;

    u_code = zeros(rows,cols);
    v_code = zeros(rows,cols);
    threshold = 0.01;
    
    disp(' - Computing (u,v) codes')
    for i = 1 : rows
        disp(i);
        for j = 1 : cols
            
            sum_code_u = 0;
            sum_code_v = 0;
            
            for l = 1:10   
                % Convert gray code to decimal get a unique label
                sum_code_u = sum_code_u + (bin_label(i,j,l) * 2^(l-1));
                sum_code_v = sum_code_v + (bin_label(i,j,l+10) * 2^(l-1));

            end
            
            u_code(i,j) = sum_code_u;
            v_code(i,j) = sum_code_v;
            
            % Eliminate unreliable pixels
%             if (abs(sum(diff(i,j,:))) >= threshold)
%                 u_code(i,j) = sum_code_u;
%             end
            
%             if (abs(sum(diff(i,j,:))) >= threshold)
%                 v_code(i,j) = 0;
%             end
        end
    end
end