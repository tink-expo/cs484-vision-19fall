%This feature representation is described in the handout, lecture
%materials, and Szeliski chapter 14.

function image_feats = get_bags_of_words(image_paths)
% image_paths is an N x 1 cell array of strings where each string is an
% image path on the file system.

% This function assumes that 'vocab.mat' exists and contains an N x feature vector length
% matrix 'vocab' where each row is a kmeans centroid or visual word. This
% matrix is saved to disk rather than passed in a parameter to avoid
% recomputing the vocabulary every run.

% image_feats is an N x d matrix, where d is the dimensionality of the
% feature representation. In this case, d will equal the number of clusters
% or equivalently the number of entries in each image's histogram
% ('vocab_size') below.

% You will want to construct feature descriptors here in the same way you
% did in build_vocabulary.m (except for possibly changing the sampling
% rate) and then assign each local feature to its nearest cluster center
% and build a histogram indicating how many times each cluster was used.
% Don't forget to normalize the histogram, or else a larger image with more
% feature descriptors will look very different from a smaller version of the same
% image.

load('vocab.mat', 'vocab');
vocab_size = size(vocab, 1);
num_images = size(image_paths, 1);

image_feats = zeros(num_images, vocab_size);
for i = 1 : num_images
    img = im2double(imread(image_paths{i}));
    interest_points = detectSURFFeatures(img, 'MetricThreshold', 100);
    interest_points = selectStrongest(interest_points, 200);
    [features, ~] = extractHOGFeatures(img, interest_points, 'CellSize', [16 16]);
    
    histogram = zeros(1, vocab_size);
    for j = 1 : size(features, 1)
%         dist = vocab - features(j, :);
%         dist = (vecnorm(dist'))';
        
        diff = vocab - features(j, :);
        dist = zeros(vocab_size, 1);
        for k = 1 : vocab_size
            dist(k) = norm(diff(k, :));
        end
        [~, vocab_ind] = min(dist);
        histogram(vocab_ind) = histogram(vocab_ind) + 1;
    end
    histogram = histogram / norm(histogram);
    image_feats(i, :) = histogram; 
end




