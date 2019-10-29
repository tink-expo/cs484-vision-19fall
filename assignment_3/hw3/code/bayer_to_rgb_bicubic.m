%% HW3-a
% Generate the rgb image from the bayer pattern image using linear and
% bicubic interpolation.
function rgb_img = bayer_to_rgb_bicubic(bayer_img)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Your code here
    g_kernel = (1 / 256) *...
        [   0,   0,   0,  1,   0,   0,   0;...
            0,   0,  -9,   0,  -9,   0,   0;...
            0,  -9,   0,  81,   0,  -9,   0;...
            1,   0,  81, 256,  81,   0,   1;...
            0,  -9,   0,  81,   0,  -9,   0;...
            0,   0,  -9,   0,  -9,   0,   0;...
            0,   0,   0,  1,   0,   0,   0];
    rb_kernel = (1 / 256) *...
      [   1,   0,  -9, -16,  -9,   0,   1;...
          0,   0,   0,   0,   0,   0,   0;...
         -9,   0,  81, 144,  81,   0,  -9;...
         -16,   0, 144, 256, 144,   0, -16;...
         -9,   0,  81, 144,  81,   0,  -9;...
      	  0,   0,   0,   0,   0,   0,   0;...
          1,   0,  -9, -16,  -9,   0,   1];
    
    % Since it is a bayer image, imfilter with symmetric option wouldn't
    % work. So pad the image manually, extract each bayer channels,
    % and crop later.
    [kh, kw] = size(g_kernel);
    padarray(bayer_img, [kh, kw], 'both', 'symmetric');
    
    [h, w] = size(bayer_img);
    ind = reshape(1:h*w, h, w);
    r_ind = ind(1:2:end, 1:2:end);
    b_ind = ind(2:2:end, 2:2:end);
    gr_ind = ind(1:2:end, 2:2:end);
    gb_ind = ind(2:2:end, 1:2:end);
    
    channel_r = zeros(h, w);
    channel_r(r_ind(:)) = bayer_img(r_ind(:));
    channel_b = zeros(h, w);
    channel_b(b_ind(:)) = bayer_img(b_ind(:));
    channel_g = zeros(h, w);
    channel_g(gr_ind(:)) = bayer_img(gr_ind(:));
    channel_g(gb_ind(:)) = bayer_img(gb_ind(:));
    
    channel_r = imfilter(channel_r, rb_kernel);
    channel_g = imfilter(channel_g, g_kernel);
    channel_b = imfilter(channel_b, rb_kernel);
    rgb_img = cat(3, channel_r, channel_g, channel_b);
    
    rgb_img = rgb_img(kh+1 : h-kh, kw+1 : w-kw, :);
    rgb_img = uint8(rgb_img);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
end
