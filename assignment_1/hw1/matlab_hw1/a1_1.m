A = imread('grizzlypeakg.png');
tic;
B = A <= 10;
A(B) = 0;
toc;