function [a,b,c,d] = flip_group_coeff_signs(a,b,c,d,m)

if (m == 1)
  c = -c;
  d = -d;
elseif (m == 2)
  b = -b;
  d = -d;
elseif (m == 3)
  b = -b;
  c = -c;
end;