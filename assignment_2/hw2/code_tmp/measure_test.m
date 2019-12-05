img = im2double(imread('../questions/RISDance.jpg'));
fw_iw = [3, 500; 3, 1000; 5, 500; 5, 1000; 7, 500; 7, 1000];
[num_cases, unused] = size(fw_iw);
results = zeros(num_cases, 3);
for i = 1 : num_cases
    fw = fw_iw(i, 1);
    iw = fw_iw(i, 2);
    filter = fspecial('average', fw);
    
    resized_img = imresize(img, [2*iw, iw]);
    t = clock;
    imfilter(resized_img, filter, 'symmetric');
    results(i, 1) = etime(clock, t);
    
    resized_img = imresize(img, [2*iw, iw]);
    t = clock;
    my_imfilter_v1(resized_img, filter);
    results(i, 2) = etime(clock, t);
    
    resized_img = imresize(img, [2*iw, iw]);
    t = clock;
    my_imfilter(resized_img, filter);
    results(i, 3) = etime(clock, t);
end
disp(results)