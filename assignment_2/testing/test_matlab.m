img = imread('bird.bmp');
filter = fspecial('motion', 20, 45);
B = imfilter(img, filter, 'conv', 'symmetric');
output = my_imfilter_fft(img, filter);

diff = find(B ~= output);
for d = 1 : size(diff)
    disp([B(diff(d)), output(diff(d))]);
end

