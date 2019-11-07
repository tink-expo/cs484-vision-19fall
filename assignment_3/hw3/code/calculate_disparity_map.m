%% HW3-d
% Generate the disparity map from two rectified images. Use NCC for the
% mathing cost function.
function [d, cv] = calculate_disparity_map(img_left, img_right, window_size, max_disparity)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Your code here
    if mod(window_size, 2) ~= 1
        d = "window_size must be an odd number.";
        return
    end
    
    window_rad = (window_size - 1) / 2;
    
    [img_h, img_w] = size(img_left);
    cost_vol = zeros(img_h, img_w, max_disparity+1);
    cost_vol(:,:,:) = -2; % -1 <= ncc <= 1
    
    for disparity = 0 : max_disparity-1
        disparity
        for r = 1 : img_h
            for c = 1 : img_w - disparity
                limit_r =...
                    [max(1, r - window_rad), min(img_h, r + window_rad)];
                limit_c =...
                    [max(1, c - window_rad), min(img_w - disparity, c + window_rad)];
                window_left = img_left(limit_r, limit_c);
                window_right = img_right(limit_r, limit_c + disparity);
                cost_vol(r, c, disparity + 1) =...
                    calculate_ncc(window_left, window_right);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % winner takes all
    [min_val, d] = max(cost_vol,[],3);
    
    d = d - 1;
    cv = cost_vol;
end

function ncc = calculate_ncc(A, B)
    vecA = reshape(A, [1, numel(A)]);
    vecB = reshape(B, [1, numel(B)]);
    if range(vecA) == 0 || range(vecB) == 0
        ncc = 0;
    else
        vecA = vecA - mean(vecA);
        vecB = vecB - mean(vecB);
        ncc = dot(vecA, vecB) / (norm(vecA) * norm(vecB));
    end
end

function [dev_img, dev_norms] = calculate_dev(img, window_size)
    [img_h, img_w] = size(img);
    img_c = window_size * window_size;
    
    dev_img = zeros(img_h, img_w, img_c);
    dev_norms = zeros(img_h, img_w);
    
    avg_filter = fspecial('average', window_size);
    mean_img = imfilter(img, avg_filter, 'symmetric');
    
    window_rad = (window_size - 1) / 2;
    padded_img = padarray(img, window_rad, 'symmetric');
    for i=1:img_h
        for j=1:img_w
            dev_img(i, j, :) =... 
                reshape(padded_img(i:i+window_size-1, j:j+window_size-1), [1, img_c])...
                - mean_img(i, j);
            dev_norms(i, j) = norm(dev_img(i, j, :));
        end
    end
end
