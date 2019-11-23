% Local Feature Stencil Code
% Written by James Hays for CS 143 @ Brown / CS 4476/6476 @ Georgia Tech

% Please implement the "nearest neighbor distance ratio test", 
% Equation 4.18 in Section 4.1.3 of Szeliski. 
% For extra credit you can implement spatial verification of matches.

%
% Please assign a confidence, else the evaluation function will not work.
%

% This function does not need to be symmetric (e.g., it can produce
% different numbers of matches depending on the order of the arguments).

% Input:
% 'features1' and 'features2' are the n x feature dimensionality matrices.
%
% Output:
% 'matches' is a k x 2 matrix, where k is the number of matches. The first
%   column is an index in features1, the second column is an index in features2. 
%
% 'confidences' is a k x 1 matrix with a real valued confidence for every match.

function [matches, confidences] = match_features(features1, features2)

k = min(size(features1, 1), size(features2,1));
matches = zeros(k, 2);
confidences = zeros(k, 1);

for i = 1:k
    diff = features2 - features1(i, :);
    dist = vecnorm(diff');
    [min_dist, min_idx] = mink(dist, 2);
    matches(i, :) = [i, min_idx(1)];
    if min_dist(2) == 0
        confidences(i) = 0;
    else
        confidences(i) = 1 - min_dist(1) / min_dist(2);
    end
end

[~, sorted_i] = sort(confidences, 'descend');
sorted_i = sorted_i(1:100);
matches = matches(sorted_i, :);
confidences = confidences(sorted_i);

end


% Remember that the NNDR test will return a number close to 1 for 
% feature points with similar distances.
% Think about how confidence relates to NNDR.