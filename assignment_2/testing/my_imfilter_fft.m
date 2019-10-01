function output = my_imfilter_fft(img, filter)

[fh, fw] = size(filter);
if mod(fh, 2) ~= 1 || mod(fw, 2) ~= 1
    output = "Error Message";
    return
end

ph = (fh - 1) / 2;
pw = (fw - 1) / 2;
fft_img = padarray(img, [ph, pw], 'both', 'symmetric');

[h, w, c] = size(fft_img);

fft_filter = zeros(h, w);

fft_filter(1 : ph+1, 1 : pw+1) =...
    filter(fh-ph : fh, fw-pw : fw);

fft_filter(h+1-ph : h, 1 : pw+1) =...
    filter(1 : ph, fw-pw : fw);

fft_filter(1 : ph+1, w+1-pw : w) =...
    filter(fh-ph : fh, 1 : pw);

fft_filter(h+1-ph : h, w+1-pw : w) =...
    filter(1 : ph, 1 : pw);

output = zeros(h, w, c);
for z = 1 : c
    output(:, :, z) = ifft2(fft2(fft_img(:, :, z)) .* fft2(fft_filter));
end

output = output(ph+1 : h-ph, pw+1 : w-pw, :);

if isinteger(img)
    output = round(output);
end
output = cast(output, 'like', img);