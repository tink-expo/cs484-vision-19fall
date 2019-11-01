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
    
    tVertices1 = get_t_vertices(img1, tform1);
    tVertices2 = get_t_vertices(img2, tform2);
    tVerticesX = sort([tVertices1(:, 1)' tVertices2(:, 1)']);
    tVerticesY = sort([tVertices1(:, 2)' tVertices2(:, 2)']);
    
    rectX = [round(tVerticesX(1)), round(tVerticesX(8))];
    rectY = [round(tVerticesY(1)), round(tVerticesY(8))];
    rectW   = rectX(2) - rectX(1) - 1;
    rectH  = rectY(2) - rectY(1) - 1;
    ref = imref2d([rectH, rectW], rectX, rectY);

    rectified1 = imwarp(img1, tform1, 'OutputView', ref);
    rectified2 = imwarp(img2, tform2, 'OutputView', ref);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
end

function tVertices = get_t_vertices(img, tform)
    [h, w, ~] = size(img);
    orgVertices = [1, 1; 1, h; w, h; w, 1];
    tVertices = transformPointsForward(tform, orgVertices);
end
