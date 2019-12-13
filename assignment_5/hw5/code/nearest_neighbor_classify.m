%This function will predict the category for every test image by finding
%the training image with most similar features. Instead of 1 nearest
%neighbor, you can vote based on k nearest neighbors which will increase
%performance (although you need to pick a reasonable value for k).

function predicted_categories = nearest_neighbor_classify(train_image_feats, train_labels, test_image_feats)
% image_feats is an N x d matrix, where d is the dimensionality of the
%  feature representation.
% train_labels is an N x 1 cell array, where each entry is a string
%  indicating the ground truth category for each training image.
% test_image_feats is an M x d matrix, where d is the dimensionality of the
%  feature representation. You can assume M = N unless you've modified the
%  starter code.
% predicted_categories is an M x 1 cell array, where each entry is a string
%  indicating the predicted category for each test image.

% Useful functions:
%  matching_indices = strcmp(string, cell_array_of_strings)
%    This can tell you which indices in train_labels match a particular
%    category. Not necessary for simple one nearest neighbor classifier.
 
%   [Y,I] = MIN(X) if you're only doing 1 nearest neighbor, or
%   [Y,I] = SORT(X) if you're going to be reasoning about many nearest
%   neighbors 

m = size(test_image_feats, 1);
predicted_categories = cell(m, 1);

k = 5;
for i = 1 : m
%     diffs = train_image_feats - test_image_feats(i, :);
%     diffs = vecnorm(diffs');
%     [~, inds] = mink(diffs, k, 2);
    
    diff = train_image_feats - test_image_feats(i, :);
    dist = zeros(size(train_image_feats, 1), 1);
    for j = 1 : size(train_image_feats, 1)
        dist(j) = norm(diff(j, :));
    end
%    [~, inds] = mink(dist, k, 2);
    [~, inds] = sort(dist');
    inds = inds(:, 1:k);
    predicted_categories{i} = get_voted_label(inds, train_labels);
end

end

function max_label = get_voted_label(inds, train_labels)

k = size(inds, 2);
found_labels = cell(k, 1);
for i = 1 : k
    found_labels{i} = train_labels{inds(i)};
end
votes = zeros(k, 1);
for i = 1 : k
    votes(i) = nnz(strcmp(found_labels{i}, found_labels));
end
[~, vote_ind] = max(votes);
max_label = found_labels{vote_ind};

end












