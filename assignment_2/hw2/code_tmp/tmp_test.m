img = imread('../data/bird.bmp');
tic;
B = imfilter(img, filter, 'conv', 'symmetric');
toc;
tic;
output = my_imfilter_v1(img, filter);
toc;
tic;
output2 = my_imfilter(img, filter);
toc;

diff = find(B ~= output);
for d = 1 : size(diff)
    disp([B(diff(d)), output(diff(d))]);
end
diff2 = find(B ~= output2);
for d = 1 : size(diff2)
    disp([B(diff2(d)), output2(diff2(d))]);
end

