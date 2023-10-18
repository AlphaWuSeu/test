function q_coeff = flip_single_coeff_signs(q_coeff,m)

if (m == 1)
  q_coeff(3) = -q_coeff(3);
  q_coeff(4) = -q_coeff(4);
elseif (m == 2)
  q_coeff(2) = -q_coeff(2);
  q_coeff(4) = -q_coeff(4);
elseif (m == 3)
  q_coeff(2) = -q_coeff(2);
  q_coeff(3) = -q_coeff(3);
end;