%% HW3-b
% Calculate the fundamental matrix using the normalized eight-point
% algorithm.
function f = calculate_fundamental_matrix(pts1, pts2)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Your code here
    
    num_corrs = size(pts1, 1);
    [npts1_t, T1] = normalize_points(pts1', 2);
    [npts2_t, T2] = normalize_points(pts2', 2);
     hpts1 = [npts1_t' ones(num_corrs, 1)];
     hpts2 = [npts2_t' ones(num_corrs, 1)];
    
    A = zeros(num_corrs, 9);
    for r = 1:num_corrs
        a_row_mat = (hpts2(r, :))' * hpts1(r, :);
        A(r, :) = reshape(a_row_mat, [1, 9]);
    end
    
    [Veig, Deig] = eig(A' * A);
    [~, ind] = sort(diag(Deig));
    F = reshape(Veig(:, ind(1)), [3, 3]);

    [U, S, V] = svd(F);
    [sing, ~] = sort(diag(S), 'descend');
    Ss = zeros(3, 3);
    Ss(1:3+1:9-1) = sing(1:2);
    
    f = T2' * (U * Ss * V') * T1;
    
    % Normalize the fundamental matrix and enforce the last element to be
    % positive.
    f = f / norm(f);
    if f(3, 3) < 0
      f = -f;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
