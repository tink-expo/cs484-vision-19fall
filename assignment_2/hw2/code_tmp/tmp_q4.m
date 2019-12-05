img = im2single(imread('../questions/RISDance.jpg'));
% Each element is (W X H) value of resized img.
img_pixels = linspace(0.25 * 1e+6, 8 * 1e+6, 10);
% Each element is (W) value of filter.
filt_sizes = 3 : 2 : 15;
filt_pixels = zeros(numel(filt_sizes), 1);
filts = cell(numel(filt_sizes));
for fidx = 1 : numel(filt_sizes)
    filts{fidx} = fspecial('average', filt_sizes(fidx));
    filt_pixels(fidx) = numel(filts{fidx});
end

etimes = zeros(numel(img_pixels), numel(filt_sizes));
img_actual_pixels = zeros(numel(img_pixels), 1);
for pidx = 1 : numel(img_pixels)
    img_h = round(sqrt(img_pixels(pidx) / 2));
    img_actual_pixels(pidx) = 2 * img_h * img_h;
    resized_img = imresize(img, [img_h, 2 * img_h]);
    for fidx = 1 : numel(filt_sizes)
        t = clock;
        imfilter(resized_img, filts{fidx});
        etimes(pidx, fidx) = etime(clock, t) * 1000;
    end
end

% Plot X:filt_pixels, Y:img_actual_pixels, Z:etimes

[X, Y] = meshgrid(filt_pixels, img_actual_pixels);
disp(etimes);
figure(1);
surf(X, Y, etimes, 'FaceAlpha', 0.5);
xlabel('Number of pixels in filter');
ylabel('Number of pixels in image');
zlabel('Elapsed time (ms)');
saveas(gcf, 'surf.jpg');