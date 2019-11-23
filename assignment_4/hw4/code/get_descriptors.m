% Local Feature Stencil Code
% Written by James Hays for CS 143 @ Brown / CS 4476/6476 @ Georgia Tech

% Returns a set of feature descriptors for a given set of interest points. 

% 'image' can be grayscale or color, your choice.
% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
%   The local features should be centered at x and y.
% 'descriptor_window_image_width', in pixels, is the local feature descriptor width. 
%   You can assume that descriptor_window_image_width will be a multiple of 4 
%   (i.e., every cell of your local SIFT-like feature will have an integer width and height).
% If you want to detect and describe features at multiple scales or
% particular orientations, then you can add input arguments.

% 'features' is the array of computed features. It should have the
%   following size: [length(x) x feature dimensionality] (e.g. 128 for
%   standard SIFT)

function [features] = get_features(image, x, y, descriptor_window_image_width)

% To start with, you might want to simply use normalized patches as your
% local feature. This is very simple to code and works OK. However, to get
% full credit you will need to implement the more effective SIFT descriptor
% (See Szeliski 4.1.2 or the original publications at
% http://www.cs.ubc.ca/~lowe/keypoints/)

% Your implementation does not need to exactly match the SIFT reference.
% Here are the key properties your (baseline) descriptor should have:
%  (1) a 4x4 grid of cells, each descriptor_window_image_width/4. 'cell' in this context
%    nothing to do with the Matlab data structue of cell(). It is simply
%    the terminology used in the feature literature to describe the spatial
%    bins where gradient distributions will be described.
%  (2) each cell should have a histogram of the local distribution of
%    gradients in 8 orientations. Appending these histograms together will
%    give you 4x4 x 8 = 128 dimensions.
%  (3) Each feature should be normalized to unit length
%
% You do not need to perform the interpolation in which each gradient
% measurement contributes to multiple orientation bins in multiple cells
% As described in Szeliski, a single gradient measurement creates a
% weighted contribution to the 4 nearest cells and the 2 nearest
% orientation bins within each cell, for 8 total contributions. This type
% of interpolation probably will help, though.

% You do not have to explicitly compute the gradient orientation at each
% pixel (although you are free to do so). You can instead filter with
% oriented filters (e.g. a filter that responds to edges with a specific
% orientation). All of your SIFT-like feature can be constructed entirely
% from filtering fairly quickly in this way.

% You do not need to do the normalize -> threshold -> normalize again
% operation as detailed in Szeliski and the SIFT paper. It can help, though.

% Another simple trick which can help is to raise each element of the final
% feature vector to some power that is less than one.

% Placeholder that you can delete. Empty features.
% features = zeros(size(x,1), 128, 'single');

if mod(descriptor_window_image_width, 4) ~= 0
    return
end

[img_h, img_w] = size(image);

k = size(x, 1);
features = zeros(k, 128);

cell_width = descriptor_window_image_width / 4;
gauss_window = fspecial( ...
    'gaussian', descriptor_window_image_width, ...
    descriptor_window_image_width / 2);

for pt_idx = 1 : k
    pt_pos = [y(pt_idx), x(pt_idx)];
    for cell_y = 1 : 4
        for cell_x = 1 : 4
            % It is guaranteed that [1, 1] <= cell_top and 
            % cell_bottom <= [img_h, img_w].
            cell_top = pt_pos + cell_width * [cell_y - 3, cell_x - 3];
            cell_bottom = cell_top + cell_width - 1;
            
            [grad_dirs, grad_mags] = get_gradient(image( ...
                cell_top(1):cell_bottom(1), ...
                cell_top(2):cell_bottom(2)));

            grad_dirs = reshape( ...
                min(max(ceil((grad_dirs + 180) / 45), 1), 8), ...
                1, numel(grad_dirs));

            gauss_trans = -pt_pos + descriptor_window_image_width / 2 + 1;
            gauss_top = cell_top + gauss_trans;
            gauss_bottom = cell_bottom + gauss_trans;

            grad_mags = grad_mags .* gauss_window( ...
                gauss_top(1):gauss_bottom(1), ...
                gauss_top(2):gauss_bottom(2));
            grad_mags = reshape(grad_mags, 1, numel(grad_mags));

            cell_idx = 4 * (cell_y - 1) + cell_x;
            feature_cell_start = (cell_idx - 1) * 8;
            for i = 1 : numel(grad_dirs)
                features(pt_idx, feature_cell_start + grad_dirs(i)) = ...
                    features(pt_idx, feature_cell_start + grad_dirs(i)) ...
                    + grad_mags(i);
            end
        end
        
        % Rotation estimation:
        % Normalize rotation so that the most dominent rotation is always 
        % histogram 1.
%         [~, i_dominent] = max(feature_stacked);
%         if i_dominent ~= 1
%             for cell_idx = 1 : 16
%                 s_idx = (cell_idx - 1) * 8 + 1;
%                 e_idx = s_idx + 8 - 1;
%                 feature_cell = features(pt_idx, s_idx : e_idx);
%                 feature_cell = ...
%                     [feature_cell(i_dominent:end) feature_cell(1:i_dominent-1)];
%                 features(pt_idx, s_idx : e_idx) = feature_cell;
%             end
%         end
    end
    
%     % Rotation estimation:
%     % Normalize rotation so that the most dominent rotation is always histogram
%     % 1.
%     feature = features(pt_idx, :);
%     [~, i_dominent] = max(feature);
%     if i_dominent ~= 1
%         feature = [feature(i_dominent:end) feature(1:i_dominent-1)];
%     end
%     features(pt_idx, :) = feature;
end
features = features .^ 0.7;
features = normalize(features', 'norm', 1)';
features = min(features, 0.2);
features = normalize(features', 'norm', 1)';

end

function [direction, magnitude] = get_gradient(img)

h = -fspecial('prewitt');
grad_x = imfilter(img, h', 'replicate');
grad_y = imfilter(img, h, 'replicate');

magnitude = hypot(grad_x, grad_y);
direction = atan2(-grad_y, grad_x) * 180 / pi;

end
