A = [1, 2, 3; 4, 5, 6; 7, 8, 9];
B = zeros(3);
B(1, :, :) = [1, 10, 100];
B(2, :, :) = 10 * B(1, :, :);
B(3, :, :) = 100 * B(1, :, :);
C = [1, 2, 3; 4, 5, 6; 7, 8, 9];
CR = [5, 6, 4; 8, 9, 7; 2, 3, 1];
D = [1e+5, 1e+4, 1e+3; 1e+2, 1e+1, 1; 1e-1, 1e-2, 1e-3];
TA = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
TF = [1e+1, 1, 1e-1, 1e-2, 1e-3];
PA = padarray(TA, [0, 2], 'both', 'symmetric');
% disp(PA);
% PF = [1e-1, 1e-2, 1e-3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1e+1, 1];
% R = round(ifft2(fft2(PA) .* fft2(PF)), 3);
% format long
%vdisp(R(3:12));
% disp(PF);
% disp(my_imfilter(TA, TF));
% disp(my_imfilter_fft(TA, TF));

% format long
disp(round(ifft(fft(PA) .* fft(PF)), 3));
disp(round(if_test(PA, PF), 3));

function output = if_test(img, filter)
    output = img;
    [h, w] = size(img);
    for i = 0 : h-1
        for j = 0 : w-1
            sum = 0;
            for a = 0 : h-1
                for b = 0 : w-1
                    % disp([a + 1, b + 1, mod(i-a, h) + 1, mod(j-b, w) + 1]);
                    sum = sum + img(a + 1, b + 1) * filter(mod(i-a, h) + 1, mod(j-b, w) + 1);
                end
            end
            output(i+1, j+1) = sum;
        end
    end
end
