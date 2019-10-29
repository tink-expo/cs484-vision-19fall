function output = my_imfilter(img, filter)
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
% output = imfilter(img, filter, 'conv');

%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%

[fh, fw] = size(filter);
if mod(fh, 2) ~= 1 || mod(fw, 2) ~= 1
    output = "Error Message";
    return
end

ph = (fh - 1) / 2;
pw = (fw - 1) / 2;
fft_img = padarray(img, [ph, pw], 'both', 'symmetric');

[h, w, c] = size(fft_img);

fft_filter = zeros(h, w);
fft_filter(1 : ph+1, 1 : pw+1) = filter(fh-ph : fh, fw-pw : fw);
fft_filter(h+1-ph : h, 1 : pw+1) = filter(1 : ph, fw-pw : fw);
fft_filter(1 : ph+1, w+1-pw : w) = filter(fh-ph : fh, 1 : pw);
fft_filter(h+1-ph : h, w+1-pw : w) = filter(1 : ph, 1 : pw);

output = zeros(h, w, c);
for z = 1 : c
    output(:, :, z) = ifft2(fft2(fft_img(:, :, z)) .* fft2(fft_filter));
end

output = output(ph+1 : h-ph, pw+1 : w-pw, :);
output = cast(output, 'like', img);
        
        



