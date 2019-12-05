show_img("RISHLibrary2.jpg");

function [] = show_img(file_name)

img = imread('../questions/' + file_name);
img = im2single( rgb2gray(img) );
h = imshow(img);
hold on;

C = corner(img, 1000);
for i = 1 : size(C, 1)
    plot(C(i, 1), C(i, 2), '.', 'Color', [1, 0, 0]);
end
hold off;
saveas( h, file_name );

end