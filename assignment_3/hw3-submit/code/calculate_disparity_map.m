%% HW3-d
% Generate the disparity map from two rectified images. Use NCC for the
% mathing cost function.

% [NOTE 1] : Parameter window_size is deleted.
function d = calculate_disparity_map(img_left, img_right, max_disparity)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Your code here
    
    % [NOTE 2] : I defined local functions get_cost_vol and calculate_dev
    % outside of the 'Your code here' commented block.
    
    % Caculate costs with window_size 3 and window_size 9, and accumulate
    % them in a single cost volume with weight 0.5, 0.5 each.
    cost_vol_3 = get_cost_vol(img_left, img_right, 3, max_disparity);
    cost_vol_9 = get_cost_vol(img_left, img_right, 9, max_disparity);
    cost_vol = (cost_vol_3 + cost_vol_9) / 2;
    
    % For the positions corresponding to black margin region of the 
    % rectified images, set the cost volume value of disparity layer 1 to
    % a value larger then any value that can be caculated as a result of 
    % NCC, so that the region will result in disparity 1 in the disparity 
    % map. This was to avoid unexpected effect at the black margin region 
    % that can be caused by large kernels.
    % In order to avoid real picture's dark area to be recognized as black
    % margin region, first apply median filter to the image before
    % this procedure.
    img_black_area = (~medfilt2(img_left)) | (~medfilt2(img_right));
    cost_vol_slice = cost_vol(:, :, 1);
    cost_vol_slice(img_black_area) = 2;
    cost_vol(:, :, 1) = cost_vol_slice;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % winner takes all
    [min_val, d] = max(cost_vol,[],3);

end

function cost_vol = get_cost_vol(img_left, img_right, window_size, max_disparity)
    [img_h, img_w] = size(img_left);
    cost_vol = zeros(img_h, img_w, max_disparity);
    cost_vol(:,:,:) = -2; % -1 <= ncc <= 1
    
    [dev_img_l, dev_norms_l] = calculate_dev(img_left, window_size);
    [dev_img_r, dev_norms_r] = calculate_dev(img_right, window_size);
    
    for k = 1 : max_disparity
        for i = 1 : img_h
            for j = 1 : img_w - k
                norm_l = dev_norms_l(i, j+k);
                norm_r = dev_norms_r(i, j);
                if norm_l == 0 || norm_r == 0
                    cost_vol(i, j, k) = 0;
                else
                    cost_vol(i, j, k) = ...
                        dot(dev_img_l(i, j+k, :),dev_img_r(i, j, :))...
                        / (norm_l * norm_r);
                end
            end
        end
    end
    
    cost_vol = imgaussfilt(cost_vol, window_size / 2);
end

function [dev_img, dev_norms] = calculate_dev(img, window_size)
    [img_h, img_w] = size(img);
    img_c = window_size * window_size;
    
    dev_img = zeros(img_h, img_w, img_c);
    dev_norms = zeros(img_h, img_w);
    
    avg_filter = fspecial('average', window_size);
    mean_img = imfilter(img, avg_filter, 'symmetric');
    
    window_rad = (window_size - 1) / 2;
    padded_img = padarray(img, [window_rad, window_rad], 'both', 'symmetric');
    
    for i=1:img_h
        for j=1:img_w
            dev_vec =... 
                reshape(padded_img(i:i+window_size-1, j:j+window_size-1), [1, img_c])...
                - mean_img(i, j);
            dev_img(i, j, :) = dev_vec;
            dev_norms(i, j) = norm(dev_vec);
        end
    end
end
