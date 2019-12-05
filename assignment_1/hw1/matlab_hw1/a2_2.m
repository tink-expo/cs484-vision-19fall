I = double(imread('gigi.jpg'));

[m, n, c] = size(I);
for i=1:m
    for j=1:n
        for k=1:c
            I(i, j, k) = -10.0/255.0;
        end
    end
end

imshow(I);