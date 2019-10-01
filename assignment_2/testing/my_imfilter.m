function output = my_imfilter(img, filter)

[filter_h, filter_w] = size(filter);
[img_h, img_w, img_c] = size(img);
if mod(filter_h, 2) ~= 1 || mod(filter_w, 2) ~= 1
    output = "Error Message";
    return
end

pad_h = (filter_h - 1) / 2;
pad_w = (filter_w - 1) / 2;
target_img = padarray(img, [pad_h, pad_w], 'both', 'symmetric');
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