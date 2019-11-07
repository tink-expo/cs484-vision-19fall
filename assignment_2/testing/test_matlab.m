img = imread('bird.bmp');
filter = fspecial('motion', 20, 45);
tic;
B = imfilter(img, filter, 'conv', 'symmetric');
toc;
tic;
output = my_imfilter_fft(img, filter);
toc;
tic;
output2 = my_imfilter(img, filter);
toc;

diff = find(B ~= output);
for d = 1 : size(diff)
    disp([B(diff(d)), output(diff(d))]);
end

