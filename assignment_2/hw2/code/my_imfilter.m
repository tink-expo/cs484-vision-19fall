function output = my_imfilter(image, filter)
% This function is intended to behave like the built in function imfilter()
% when operating in convolution mode. See 'help imfilter'. 
% While "correlation" and "convolution" are both called filtering, 
% there is a difference. From 'help filter2':
%    2-D correlation is related to 2-D convolution by a 180 degree rotation
%    of the filter matrix.

% Your function should meet the requirements laid out on the project webpage.

% Boundary handling can be tricky as the filter can't be centered on pixels
% at the image boundary without parts of the filter being out of bounds. If
% we look at 'help imfilter', we see that there are several options to deal 
% with boundaries. 
% Please recreate the default behavior of imfilter:
% to pad the input image with zeros, and return a filtered image which matches 
% the input image resolution. 
% A better approach is to mirror or reflect the image content in the padding.

% Uncomment to call imfilter to see the desired behavior.
% output = imfilter(image, filter, 'conv');

%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%

[filter_h, filter_w] = size(filter);
[img_h, img_w, img_c] = size(img);
if mod(filter_h, 2) ~= 1 || mod(filter_w, 2) ~= 1
    output = "Error Message";
    return
end

pad_h = (filter_h - 1) / 2;
pad_w = (filter_w - 1) / 2;
target_img = padarray(img, [pad_h, pad_w], 'both');
output = zeros(img_h, img_w, img_c);

% for conv
filter = rot90(filter);
filter = rot90(filter);

for target_center_i = pad_h + 1 : pad_h + img_h
    for target_center_j = pad_w + 1 : pad_w + img_w
        for c = 1 : img_c
            target = target_img(...
                target_center_i - pad_h : target_center_i + pad_h,...
                target_center_j - pad_w : target_center_j + pad_w,...
                c);
            output(...
                target_center_i - pad_h,...
                target_center_j - pad_w,...
                c) = sum(sum(filter .* double(target)));
        end
    end
end

if isinteger(img)
    output = round(output);
end
output = cast(output, 'like', img);
            
        
        



