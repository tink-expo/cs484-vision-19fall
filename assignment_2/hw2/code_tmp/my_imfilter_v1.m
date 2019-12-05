function output = my_imfilter_v1(img, filter)

[filter_h, filter_w] = size(filter);
[img_h, img_w, img_c] = size(img);
if mod(filter_h, 2) ~= 1 || mod(filter_w, 2) ~= 1
    output = "Error Message";
    return
end

pad_h = (filter_h - 1) / 2;
pad_w = (filter_w - 1) / 2;
target_img =... 
    padarray(img, [pad_h, pad_w], 'both', 'symmetric');
output = zeros(img_h, img_w, img_c);

% for conv
filter = rot90(filter, 2);

for i = pad_h + 1 : pad_h + img_h
    for j = pad_w + 1 : pad_w + img_w
        for c = 1 : img_c
            target = target_img(...
                i - pad_h : i + pad_h,...
                j - pad_w : j + pad_w,...
                c);
            output(i - pad_h, j - pad_w, c) = ...
                sum(sum(filter .* double(target)));
        end
    end
end
output = cast(output, 'like', img);