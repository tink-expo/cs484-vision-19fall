function output = my_imfilter(img, filter)

intput_image = img;

% Get the row & column size of input image and filter in order to admit
% multi size picture
[intput_row, intput_col] = size(intput_image(:,:,1));
[filter_row, filter_col] = size(filter);

% Pad image with zeros (amount = minimum need of filter = half of row and
% column
pad_input_image = padarray(intput_image, [(filter_row - 1)/2, (filter_col - 1)/2]);

output = zeros(intput_row, intput_col, 3);

for layer = 1:size(intput_image, 3) % ensure to be OK when input is gray image
    % make all filter_row*filter_col size patch of input image be columns
    columns = im2col(pad_input_image(:,:,layer), [filter_row, filter_col]);
    
    % transpose the filter in order to make it convolution (but not correlation)
    filter2 = transpose(filter(:));
    
    % filter the image
    filterd_columns = filter2 * double(columns);
    
    % recover from columns to image form
    output(:,:,layer) = col2im(filterd_columns, [1, 1], [intput_row, intput_col]);
end

if isinteger(img)
    output = round(output);
end
output = cast(output, 'like', img);