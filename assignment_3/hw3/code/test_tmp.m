% imgl = imread('left_gray.jpg');
% imgr = imread('right_gray.jpg');
% imgl = imresize(imgl, 0.5);
% imgr = imresize(imgr, 0.5);
% 
% gimgl = gray_img1; medianfiltering?
% gimgr = gray_img2;
% 
% max_disparity = 60;
% 
% sigmas = [2, 6, 12];
% [~, cv5] = calculate_disparity_map(gimgl, gimgr, 5, max_disparity);
% [~, cv15] = calculate_disparity_map(gimgl, gimgr, 15, max_disparity);
% [~, cv11] = calculate_disparity_map(gimgl, gimgr, 11, max_disparity);
% [~, cv3] = calculate_disparity_map(gimgl, gimgr, 3, max_disparity);
% [~, cv9] = calculate_disparity_map(gimgl, gimgr, 9, max_disparity);

cv3_g = imgaussfilt(cv3, 1.5);
cv5_g = imgaussfilt(cv5, 2.5);
% cv15_g = imgaussfilt(cv15, 7.5);
% cv21_g = imgaussfilt(cv21, 10.5);
% cv11_g = imgaussfilt(cv11, 5.5);
cv9_g = imgaussfilt(cv9, 4.5);

% cv15_a = (cv21_g + cv15_g) / 2;
% cv9_a = (cv15_g + cv9_g) / 2;


% [~, dm21] = max(cv21_g, [], 3);
% [~, dm15] = max(cv15_a, [], 3);
% [~, dm9] = max(cv9_a, [], 3);
% [~, dm3] = max(modify_cv(cv3_a, medfilt2(gray_img2)), [], 3);
% [~, dm3] = max(modify_cv(cv3_a, medfilt2(gray_img2)), [], 3);
% [~, dm3] = max(modify_cv(cv3_a, medfilt2(gray_img2)), [], 3);

% figure;imagesc(dm21);colorbar;
% figure;imagesc(dm15);colorbar;
% figure;imagesc(dm9);colorbar;
% figure;imagesc(get_dm(imboxfilt(cv5, 5), 1, gray_img2));colorbar;
figure;imagesc(get_dm(cv3_g(:,:,1:50), 1, gray_img1, gray_img2));colorbar;
figure;imagesc(get_dm(cv5_g(:,:,1:50), 1, gray_img1, gray_img2));colorbar;
figure;imagesc(get_dm(cv9_g(:,:,1:50), 1, gray_img1, gray_img2));colorbar;


% cv5_a_or = imgaussfilt(cv5, sigmas(1));
% [~, dm5_or] = max(cv5_a_or, [], 3);
% figure;imagesc(dm5_or);colorbar;
% cv3_a_or = imgaussfilt(cv5, 1.5);
% [~, dm3_or] = max(cv3_a_or, [], 3);
% figure;imagesc(dm3_or);colorbar;

function dm = get_dm(cv_a, ss, gray_img1, gray_img2)
    cv_a = cv_a / ss;
    % [~, dm] = max(cv_a, [], 3);
    [~, dm] = max(modify_cv(cv_a, gray_img1, gray_img2), [], 3);
end

function mod_cv = modify_cv(cv, gray_img1, gray_img2)
    mod_cv = cv;
    black_area = (~medfilt2(gray_img1)) | (~medfilt2(gray_img2));
    mod_cv(black_area) = 2;
end
