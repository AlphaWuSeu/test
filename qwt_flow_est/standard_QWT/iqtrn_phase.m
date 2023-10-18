function [a,b,c,d] = iqtrn_phase(abs_q,phi,theta,psi)
  
% Calculate the 4 parts of a quaternion q, where 
% q = a + i*b + j*c + k*d, from the magnitude and 3 phase 
% angles (in radians)
%  
% q = abs_q*e^(i*phi)*e^(j*theta)*e^(k*psi)  
%  
% abs_q: magnitude of quaternion, q 
% phi  : phase angle associated with direction i (in radians)  
% theta: phase angle associated with direction j (in radians)  
% psi  : phase angle associated with direction k (in radians) 
%
% Created by (William) Chan, Wai Lam - 24 September, 2003
  
a = real(abs_q.*(cos(phi).*cos(psi).*cos(theta) + sin(phi).*sin(psi).*sin(theta)));
b = real(abs_q.*(-cos(phi).*sin(psi).*sin(theta) + sin(phi).*cos(psi).*cos(theta)));
c = real(abs_q.*(cos(phi).*cos(psi).*sin(theta) - sin(phi).*sin(psi).*cos(theta)));
d = real(abs_q.*(cos(phi).*sin(psi).*cos(theta) + sin(phi).*cos(psi).*sin(theta)));

