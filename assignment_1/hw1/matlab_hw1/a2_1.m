I = imread('gigi.jpg');
% For pixels with original value smaller than 20, 
% below operation clamps them to 0.
I = I - 20;
imshow(I);