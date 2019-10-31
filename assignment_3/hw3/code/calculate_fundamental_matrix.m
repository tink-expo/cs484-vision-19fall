%% HW3-b
% Calculate the fundamental matrix using the normalized eight-point
% algorithm.

function f = calculate_fundamental_matrix(pts1, pts2)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Your code here
    T1 = getNormalizationMatrix(pts1);
    T2 = getNormalizationMatrix(pts2);
    
    num_corrs = size(pts1, 1);
    hpts1 = (T1 * [pts1 ones(num_corrs, 1)]')';
    hpts2 = (T2 * [pts2 ones(num_corrs, 1)]')';
    
    A = zeros(num_corrs, 9);
    for r = 1:num_corrs
        A(r, :) = genRow(hpts1(r, :), hpts2(r, :));
    end
    
    [Veig, Deig] = eig(A' * A);
    [~, ind] = sort(diag(Deig));
    F = reshape(Veig(:, ind(1)), [3, 3]);

    [U, S, V] = svd(F);
    [sing, ~] = sort(diag(S), 'descend');
    Ss = zeros(3, 3);
    Ss(1:3+1:9-1) = sing(1:2);
    
    f = T2' * (U * Ss * V') * T1;
    
    f = f / norm(f);
    if f(end) < 0
      f = -f;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

function a_row = genRow(hpt1, hpt2)
    a_row_mat = hpt2' * hpt1;
    a_row = reshape(a_row_mat, [1, 9]);
end

function T = getNormalizationMatrix(pts)
    pts = pts';
    pts = pts(1:2, :);
    cent = mean(pts, 2);
    mean_dist_cent = mean(sqrt(sum((pts - cent).^2)));
    if mean_dist_cent > 0
        scale = sqrt(2) / mean_dist_cent;
    else
        scale = 1;
    end
    T = diag(ones(1, 3) * scale);
    T(1:end-1, end) = -scale * cent;
    T(end) = 1;
end