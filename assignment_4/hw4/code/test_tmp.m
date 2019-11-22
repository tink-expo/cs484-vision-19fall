a = [4, 6, 10, -3; 7, 1, 5, 8; 2, 3, 9, -2];
[rs, cs] = find(a < 0)
vals = a(a < 0)
[b, i] = sort(vals, 'descend')
r2 = rs(i(1:1))
c2 = cs(i(1:1))