img = imread('bird.bmp');
filter = fspecial('prewitt');
disp(class(filter));
B = imfilter(img, filter, 'conv', 'symmetric');

[filter_h, filter_w] = size(filter);
[img_h, img_w, img_c] = size(img); disp(size(img));
if mod(filter_h, 2) ~= 1 || mod(filter_w, 2) ~= 1
    output = "Error Message";
    return
end

% fft_output = zeros(img_h, img_w, img_c);
% for c = 1 : img_c
%     fft_output(:,:,c) = ifft2(fft2(img(:,:,c), 2*img_h-1, 2*img_w-1) .* fft2(filter, 2*filter_h-1, 2*filter_w-1));
% end

for c = 1 : img_c
    [t_x, t_m, t_fs] = my_padarrays(img(:,:,c), filter, 'reflect');
    fft_output_single = ifft2(fft2(t_x) .* fft2(t_m));
    fft_output(:,:,c) = fft_output_single;
end

disp(size(fft_output));

pad_h = (filter_h - 1) / 2;
pad_w = (filter_w - 1) / 2;
target_img = padarray(img, [pad_h, pad_w], 'symmetric', 'both');
output = zeros(img_h, img_w, img_c);

% for conv
filter = rot90(filter);
filter = rot90(filter);

for target_center_i = pad_h + 1 : pad_h + img_h
    for target_center_j = pad_w + 1 : pad_w + img_w
        for c = 1 : img_c
            target = target_img(...
                target_center_i - pad_h : target_center_i + pad_h,...
                target_center_j - pad_w : target_center_j + pad_w,...
                c);
            output(...
                target_center_i - pad_h,...
                target_center_j - pad_w,...
                c) = sum(sum(filter .* double(target)));
        end
    end
end


if isinteger(img)
    output = round(output);
end
output = cast(output, 'like', img);


diff = find(B ~= round(output));
for d = 1 : size(diff)
    disp([B(diff(d)), output(diff(d))]);
end

function [x, m, fsize] = my_padarrays(x, m, shape)
% Pad arrays to make them the same size and allow for boundary effects

xsize = size(x);
msize = size(m);

switch shape
    
    case 'wrap'
        fsize = xsize;
        % ensure x no smaller than m
        if any(msize > xsize)  && ~isempty(x)
            x = repmat(x, ceil(msize ./ size(x)));
            xsize = size(x);
        end
        % pad m with zeros
        if any(msize < xsize)  % test, as user may have optimised already
            m = exindex(m, 1:xsize(1), 1:xsize(2), {0});
        end
        % recentre m so that y(1,1) corresponds to mask centred on x(1,1)
        mc = 1 + floor(msize/2);
        me = mc + xsize - 1;
        m = exindex(m, mc(1):me(1), mc(2):me(2), 'circular');
    
    case 'full'
        fsize = xsize + msize - 1;  % enough room for no overlap
        x = exindex(x, 1:fsize(1), 1:fsize(2), {0});
        m = exindex(m, 1:fsize(1), 1:fsize(2), {0});
    
    case 'valid'
        fsize = xsize - msize + 1;
        % pad m with zeros (don't test first, as likely to be needed)
        m = exindex(m, 1:xsize(1), 1:xsize(2), {0});
        % shift m so that y(1,1) corresponds to mask just inside x
        me = msize + xsize - 1;
        m = exindex(m, msize(1):me(1), msize(2):me(2), 'circular');

    case 'same'
        fsize = xsize;
        mmid = floor(msize/2);
        xsize = xsize + mmid;   % border to avoid edge effects
        x = exindex(x, 1:xsize(1), 1:xsize(2), {0});
        m = exindex(m, 1:xsize(1), 1:xsize(2), {0});
        % recentre m so that y(1,1) corresponds to mask centred on x(1,1)
        mc = 1 + mmid;
        me = mc + xsize - 1;
        m = exindex(m, mc(1):me(1), mc(2):me(2), 'circular');
        
    case 'reflect'
        fsize = xsize;
        xsize = xsize + msize - 1;   % border to avoid edge effects
        xc = 1 - floor((msize-1)/2);
        xe = xc + xsize - 1;
        x = exindex(x, xc(1):xe(1), xc(2):xe(2), 'symmetric');
        m = exindex(m, 1:xsize(1), 1:xsize(2), {0});
        % recentre m so that y(1,1) corresponds to mask centred on x(1,1)
        me = msize + xsize - 1;
        m = exindex(m, msize(1):me(1), msize(2):me(2), 'circular');

    otherwise
        error('conv_fft2:badshapeopt', 'Unrecognised shape option: %s', shape);
end
end

