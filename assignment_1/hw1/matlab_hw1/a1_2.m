A = imread('grizzlypeak.jpg');
total_fast = 0;
for cnt=1:1000
    B = A;
    % Start measurement for 1 img.
    t = clock;
    L = B <= 10;
    B(L) = 0;
    % End measurement and accumulate to total_fast.
    total_fast = total_fast + etime(clock, t);
end

total_slow = 0;
for cnt=1:1000
    B = A;
    % Start measurement for 1 img.
    t = clock;
    [m1, n1, c1] = size(B);
    for i=1:m1
        for j=1:n1
            for k=1:c1
                if B(i, j, k) <= 10
                    B(i, j, k) = 0;
                end
            end
        end
    end
    % End measurement and accumulate to total_slow.
    total_slow = total_slow + etime(clock, t);
end

disp(total_fast); disp(total_slow);
disp(total_slow / total_fast);