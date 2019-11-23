% % IsCorner = Harris > threshold & islocalmax(Harris) & islocalmax(Harris, 2);
% % 
% % [y_found, x_found] = find(IsCorner);
% % [~, sorted_i_found] = sort(Harris(IsCorner), 'descend');
% % 
% % % sorted_i = sorted_i_found(1:min(size(y_found, 1), 9000));
% % sorted_i = sorted_i_found(1:min(size(sorted_i_found, 1), 3000));
% % y = y_found(sorted_i);
% % x = x_found(sorted_i);
% 
% H = [1, 2, 3; 4, 5, 6; 7, 8, 9]
% L = mod(H, 2) == 0
% [y, x] = find(L)
% for i = 1:size(y,1)
%     if H(y(i), x(i)) < 3
%         L(y(i), x(i)) = false;
%     end
% end
% L
% [y, x] = find(L)
% [S, I] = sort(H(L))
% IF = I(1:2)
% yf = y(IF)
% xf = x(IF)

inds = [1, 3, 5];
adds = [0.1, 0.2, 0.3];
a = [1, 1, 1, 1, 1];
a(inds) = a(inds) + adds;
size(inds)
size(adds)
size(a)
a