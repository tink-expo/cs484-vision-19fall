img = im2single(imread('../data/plane.bmp'));
imwrite(img, 'original_img.jpg', 'quality', 95);
format rational
lpf = [1/9, 1/9, 1/9; 1/9, 1/9, 1/9; 1/9, 1/9, 1/9]
hpf = [-1/9, -1/9, -1/9; -1/9, 8/9, -1/9; -1/9, -1/9, -1/9]
lpf_img = imfilter(img, lpf, 'conv');
hpf_img = imfilter(img, hpf, 'conv');
figure(1); imshow(lpf_img);
figure(2); imshow(hpf_img + 0.5);
figure(3); imshow(img);

imwrite(lpf_img, 'lpf_img.jpg', 'quality', 95);
imwrite(hpf_img + 0.5, 'hpf_img.jpg', 'quality', 95);

