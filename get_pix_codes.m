function pix_codes = get_pix_codes(seq)
    
    [rows,cols,n_imgs] = size(seq);
    
    img_index = 1;
    diff = zeros(rows, cols, 10);
    
    % Calculate differences between each image and it's inverse
    for k = 1 : n_imgs / 2
        diff(:,:,k) = seq(:,:,img_index) - seq(:,:,img_index + 1);
        img_index = img_index + 2;
    end
    
    % Threshold pixels into on/off
    thresh = diff;
    thresh(thresh >= 0) = 1;
    thresh(thresh < 0) = 0;
    
    pix_codes = zeros(rows,cols);
    
    for i = 1 : rows
        disp(i);
        for j = 1 : cols
            
            sum_code = 0;
            sum_diff = 0;
            
            for l = 1:10  
                % comment here
                sum_code = sum_code + (thresh(i,j,l) * 2^(l-1));
                
                % Sum the differences between each image and it's inverse
                sum_diff = sum_diff + diff(i,j,l);
            end
            
            pix_codes(i,j) = sum_code;
            
%             if (sum_diff < 0.02)
%                 pix_codes(i,j) = -1;
%             else
%                 pix_codes(i,j) = sum_code;
%             end
        end
    end
end