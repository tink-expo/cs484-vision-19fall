function [normPoints, T] = normalize_points(p, numDims)

% strip off the homogeneous coordinate
points = p(1:numDims, :);

% compute centroid
cent = mean(points, 2);

% translate points so that the centroid is at [0,0]
translatedPoints = points - cent;

% compute the scale to make mean distance from centroid sqrt(2)
meanDistanceFromCenter = mean(sqrt(sum(translatedPoints.^2)));
if meanDistanceFromCenter > 0 % protect against division by 0
    scale = sqrt(numDims) / meanDistanceFromCenter;
else
    scale = 1;
end

% compute the matrix to scale and translate the points
% the matrix is of the size numDims+1-by-numDims+1 of the form
% [scale   0     ... -scale*center(1)]
% [  0   scale   ... -scale*center(2)]
%           ...
% [  0     0     ...       1         ]    
T = diag(ones(1, numDims + 1) * scale);
T(1:end-1, end) = -scale * cent;
T(end) = 1;

if size(p, 1) > numDims
    normPoints = T * p;
else
    normPoints = translatedPoints * scale;
end
% the following must be true: mean(sqrt(sum(normPoints(1:2,:).^2, 1))) == sqrt(2)