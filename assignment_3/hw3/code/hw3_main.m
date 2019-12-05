%% MATLAB version R2019b

% Read bayer pattern images
data_path = '../data/scene/';
img_path_1 = [data_path,'bayer_cam1.png'];
img_path_2 = [data_path,'bayer_cam2.png'];
bayer_img1 = imread(img_path_1);
bayer_img2 = imread(img_path_2);

%% HW3-a
% Bayer pattern bicubic interpolation
img1 = bayer_to_rgb_bicubic(bayer_img1);
figure;
imshow(img1);
img2 = bayer_to_rgb_bicubic(bayer_img2);

% Read matched feature points (n by 2 array)
feature_point = importdata([data_path, 'feature_points.txt']);
pts1 = feature_point(1:8,1:2);
pts2 = feature_point(1:8,3:4);

% Visualize matching points on images
figure;
subplot(1,2,1);
imshow(img1);title('Left image');hold on;
plot(pts1(:,1),pts1(:,2),'ro');
subplot(1,2,2);
imshow(img2);title('Right image');hold on;
plot(pts2(:,1),pts2(:,2),'go');


%% HW3-b
% Find the fundamental matrix form given two feature point sets using the
% normalized eight-point algorithm
Fundamental_matrix = calculate_fundamental_matrix(pts1, pts2);


% Find the homography matrix for each left and right camera to project two
% images on a common plane
[Homography_left, Homography_right] = estimateUncalibratedRectification(Fundamental_matrix, pts1, pts2, size(img1));


%% HW3-c
% Rectifiy each image
[Rectified_img_left, Rectified_img_right] = rectify_stereo_images(img1, img2, Homography_left, Homography_right);


% Visualize rectified images
figure;
subplot(2,2,1);
imshow(Rectified_img_left);title('Rectified Left image');hold on;
subplot(2,2,2);
imshow(Rectified_img_right);title('Rectified Right image');hold on;
subplot(2,2,[3,4]);
imshow(stereoAnaglyph(Rectified_img_left, Rectified_img_right));title('Stereo Anaglyph');


%% HW3-d
% Generate a disparity map from the two rectified images
% You may change the window_size and max_disparity
window_size = 5;
max_disparity = 60;

gray_img1 = im2double(rgb2gray(Rectified_img_left));
gray_img2 = im2double(rgb2gray(Rectified_img_right));


% left_path = [data_path,'left.jpg'];
% right_path = [data_path,'right.jpg'];
% left_img = imread(left_path);
% right_img = imread(right_path);
% s1 = size(left_img)
% s2 = size(right_img)
% gray_img1 = im2double(rgb2gray(left_img));
% gray_img2 = im2double(rgb2gray(right_img));

% [Disparity_map, cv] = calculate_disparity_map(gray_img1, gray_img2, window_size, max_disparity);
% cv2 = imfilter(cv, fspecial('average', window_size), 'symmetric');
% cv3 = zeros(size(cv));
% for k=1:max_disparity
%     cv3(:,:,k) = medfilt2(cv(:,:,k), [window_size, window_size], 'symmetric');
% end
% [~, Disparity_map2] = max(cv2,[],3);
% [~, Disparity_map3] = max(cv3,[],3);
% %Visualize the disparity map
% figure;imagesc(Disparity_map);colorbar;
% figure;imagesc(Disparity_map2);colorbar;
% figure;imagesc(Disparity_map3);colorbar;
