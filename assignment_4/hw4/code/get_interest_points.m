% Local Feature Stencil Code
% Written by James Hays for CS 143 @ Brown / CS 4476/6476 @ Georgia Tech

% Returns a set of interest points for the input image

% 'image' can be grayscale or color, your choice.
% 'descriptor_window_image_width', in pixels.
%   This is the local feature descriptor width. It might be useful in this function to 
%   (a) suppress boundary interest points (where a feature wouldn't fit entirely in the image, anyway), or
%   (b) scale the image filters being used. 
% Or you can ignore it.

% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
% 'confidence' is an nx1 vector indicating the strength of the interest
%   point. You might use this later or not.
% 'scale' and 'orientation' are nx1 vectors indicating the scale and
%   orientation of each interest point. These are OPTIONAL. By default you
%   do not need to make scale and orientation invariant local features.
function [x, y, confidence, scale_indices, orientation] = get_interest_points(image, descriptor_window_image_width, scales)

% Implement the Harris corner detector (See Szeliski 4.1.1) to start with.
% You can create additional interest point detector functions (e.g. MSER)
% for extra credit.

% If you're finding spurious interest point detections near the boundaries,
% it is safe to simply suppress the gradients / corners near the edges of
% the image.

% The lecture slides and textbook are a bit vague on how to do the
% non-maximum suppression once you've thresholded the cornerness score.
% You are free to experiment. Here are some helpful functions:
%  BWLABEL and the newer BWCONNCOMP will find connected components in 
% thresholded binary image. You could, for instance, take the maximum value
% within each component.
%  COLFILT can be used to run a max() operator on each sliding window. You
% could use this to ensure that every interest point is at a local maximum
% of cornerness.


% After computing interest points, here's roughly how many we return
% For each of the three image pairs
% - Notre Dame: ~1300 and ~1700
% - Mount Rushmore: ~3500 and ~4500
% - Episcopal Gaudi: ~1000 and ~9000
[img_h, img_w] = size(image);
Gdy = fspecial('sobel');
Gdx = Gdy';
Ix = imfilter(image, Gdx, 'conv', 'replicate');
Iy = imfilter(image, Gdy, 'conv', 'replicate');

img_c = size(scales, 2);

threshold = 0.0000045;
rad = 24;
circle_mask = get_circle_mask(rad);

HarrisAll = zeros([img_h, img_w, img_c]);
HarrisCorner = false([img_h, img_w, img_c]);
for s = 1 : img_c
    Harris = get_harris(Ix, Iy, scales(s));
    IsCorner = Harris > threshold & islocalmax(Harris) & islocalmax(Harris, 2);

    [y_found, x_found] = find(IsCorner);

    % Adaptive non-maximal suppression.
    for i = 1 : size(y_found, 1)
        cy = y_found(i);
        cx = x_found(i);
        if ~(cy-rad >= 1 && cx-rad >= 1 && cy+rad <= img_h && cx+rad <= img_w && ...
                all(all( ...
                Harris(cy-rad : cy+rad, cx-rad : cx+rad) .* circle_mask) < ...
                Harris(cy, cx) * 0.9))
            IsCorner(cy, cx) = false;
        end
    end
    HarrisAll(:, :, s) = Harris;
    HarrisCorner(:, :, s) = IsCorner;
end

Logs = zeros([img_h, img_w, img_c]);
for s = 1 : img_c
    Logs(:, :, s) = get_log(image, scales(s));
end
% HarrisCorner = HarrisCorner & islocalmax(Logs, 3);
i_found = find(HarrisCorner);
[y_found, x_found, c_found] = ind2sub(size(HarrisCorner), i_found);

HarrisVal = HarrisAll(HarrisCorner);
[HarrisVal, sorted_i_found] = sort(HarrisVal, 'descend');

% sorted_i = sorted_i_found(1:min(size(y_found, 1), 9000));
sorted_i = sorted_i_found(1:min(size(sorted_i_found, 1), 3000));
y = y_found(sorted_i);
x = x_found(sorted_i);
scale_indices = c_found(sorted_i);
confidence = HarrisVal(sorted_i);
end

function h = get_harris(Ix, Iy, sigma)

IxIx = imgaussfilt(Ix .^ 2, sigma, 'Padding', 'replicate');
IxIy = imgaussfilt(Ix .* Iy, sigma, 'Padding', 'replicate');
IyIy = imgaussfilt(Iy .^ 2, sigma, 'Padding', 'replicate');

alpha = 0.05;
h = (IxIx .* IyIy - IxIy .* IxIy) - alpha * (IxIx + IyIy) .^ 2;

end

function h = get_circle_mask(radius)

hsize = radius * 2 + 1;
h = zeros(hsize);
for i = 1 : hsize
    for j = 1 : hsize
        if hypot(i - (radius+1), j - (radius+1)) <= radius
            h(i, j) = 1;
        end
    end
end
h(radius+1, radius+1) = 0;

end

function h = get_log(img, sigma)

log_filt = fspecial('log', 2*ceil(2*sigma)+1, sigma);
h = sigma * sigma * abs(imfilter(img, log_filt, 'conv', 'replicate'));

end

