%% HW3-c
% Given two homography matrices for two images, generate the rectified
% image pair.
function [rectified1, rectified2] = rectify_stereo_images(img1, img2, h1, h2)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Your code here

    % Hint: Note that you should care about alignment of two images.
    % In order to superpose two rectified images, you need to create
    % certain amount of margin.
    
    tform1 = projective2d(h1);
    tform2 = projective2d(h2);
    
    t_vertices_1 = get_t_vertices(img1, tform1);
    t_vertices_2 = get_t_vertices(img2, tform2);
    t_vertices_x = sort([t_vertices_1(:, 1)' t_vertices_2(:, 1)']);
    t_vertices_y = sort([t_vertices_1(:, 2)' t_vertices_2(:, 2)']);
    
    rect_x = [round(t_vertices_x(1)), round(t_vertices_x(8))];
    rect_y = [round(t_vertices_y(1)), round(t_vertices_y(8))];
    rect_w   = rect_x(2) - rect_x(1) - 1;
    rect_h  = rect_y(2) - rect_y(1) - 1;
    ref = imref2d([rect_h, rect_w], rect_x, rect_y);

    rectified1 = imwarp(img1, tform1, 'OutputView', ref);
    rectified2 = imwarp(img2, tform2, 'OutputView', ref);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
end

function t_vertices = get_t_vertices(img, tform)
    [h, w, ~] = size(img);
    orig_vertices = [1, 1; 1, h; w, h; w, 1];
    t_vertices = transformPointsForward(tform, orig_vertices);
end
