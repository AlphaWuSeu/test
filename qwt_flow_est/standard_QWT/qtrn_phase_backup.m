function [abs_q,phi,theta,psi,r] = qtrn_phase(a,b,c,d,m)
  
% Calculate the magnitude and 3 phase angles (in radians) 
% of a quaternion q, where q = a + i*b + j*c + k*d
%
% m: QWT subband (special case when m = 3, always singular case) 
%  
% abs_q: magnitude of quaternion, q 
% phi  : phase angle associated with direction i (in radians)  
% theta: phase angle associated with direction j (in radians)  
% psi  : phase angle associated with direction k (in radians) 
%   
% Created by (William) Chan, Wai Lam - 24 September, 2003
%
% Equations refer to (P.16-21) Thomas Bülow. Hypercomplex Spectral 
% SignalRepresentation for the Processing and Analysis of Images
%
% http://www.cis.upenn.edu/~thomasbl/publications.html  
  
abs_q = sqrt(a.^2 + b.^2 + c.^2 + d.^2);

if (abs_q == 0)
  
  %disp('abs_q = 0!');
  abs_q = 0;
  phi = 0;
  theta = 0;
  psi = 0;
  r = 0;
  
else

a = a/abs_q;
b = b/abs_q;
c = c/abs_q;
d = d/abs_q;

R_11 = a^2 + b^2 - c^2 - d^2;
R_13 = 2*(b*d + a*c);

R_22 = a^2 - b^2 + c^2 - d^2;
R_32 = 2*(c*d + a*b);

R_31 = 2*(b*d - a*c);
R_33 = a^2 - b^2 - c^2 + d^2;

R_23 = 2*(c*d-a*b);

r=sqrt(R_11^2+R_13^2);
%sqrt(R_22^2+R_32^2)

psi = real(-asin(2*(b*c-a*d))/2);
%if (imag(psi) ~= 0)
%  disp(sprintf('imaginary phase, b*c-a*d = %.3f', b*c-a*d));
%end;

th_psi = 0.045;
%if ((abs((abs(psi)-pi/4))<th_psi) | (m==3))% ambiguity/singular case

if (m == 3) % ambiguity/singular case

%  disp('SINGULAR case in phase calulation!');
  %phi = 0;
  %if (psi < 0) % psi = -pi/4
  %  R_23 = R_31;
  %else %psi = +pi/4
  %  R_23 = -R_31;
  %end;
  %theta = atan2(R_23,R_33)/2;
  
  %theta = atan2(-R_31,R_33)/2;
  %phi = 0;
  theta = 0;
  phi = atan2(-R_23,R_33)/2;
  
  
else
  
  phi = atan2(R_32,R_22)/2;
  theta = atan2(R_13,R_11)/2;
  
end

%th = 100000;
%(a_cal <= -a+th*eps)&(a_cal >= -a-th*eps)
%(b_cal <= -b+th*eps)&(b_cal >= -b-th*eps)
%(c_cal <= -c+th*eps)&(c_cal >= -c-th*eps)
%(d_cal <= -d+th*eps)&(d_cal >= -d-th*eps)

%th = 0.01;

%if (((a_cal <= -a+th*eps)&(a_cal >= -a-th*eps)) & ((b_cal <=
%-b+th*eps)&(b_cal >= -b-th*eps)) & ((c_cal <= -c+th*eps)&(c_cal >=
%-c-th*eps)) & ((d_cal <= -d+th*eps)&(d_cal >= -d-th*eps)))

% To prevent breaking down (sign(a_cal)==-sign(a)) when a ~ 0
%if ((abs(a)<eps/abs_q)&(abs(a+a_cal)<th))
%  a_cal = -a;
%end;
%if ((abs(b)<eps/abs_q)&(abs(b+b_cal)<th))
%  b_cal = -b;
%end;
%if ((abs(c)<eps/abs_q)&(abs(c+c_cal)<th))
%  c_cal = -c;
%end;
%if ((abs(d)<eps/abs_q)&(abs(d+d_cal)<th))
%  d_cal = -d;
%end;

phi_1 = phi;

a_cal_1 = real((cos(phi_1)*cos(psi)*cos(theta) + sin(phi_1)*sin(psi)*sin(theta)));
b_cal_1 = real((-cos(phi_1)*sin(psi)*sin(theta) + sin(phi_1)*cos(psi)*cos(theta)));
c_cal_1 = real((cos(phi_1)*cos(psi)*sin(theta) - sin(phi_1)*sin(psi)*cos(theta)));
d_cal_1 = real((cos(phi_1)*sin(psi)*cos(theta) + sin(phi_1)*cos(psi)*sin(theta)));

% Check if e^(i*phi)e^(j*theta)e^(k*psi) = -q
%if (((abs(a+a_cal)<th)&(sign(a_cal)==-sign(a))) &((abs(b+b_cal)<th)&(sign(b_cal)==-sign(b)))&((abs(c+c_cal)<th)&(sign(c_cal)==-sign(c)))&((abs(d+d_cal)<th)&(sign(d_cal)==-sign(d)))) 

%  r = 1;
  
%disp('hello');
if (phi >= 0)
  phi_2 = phi - pi;
else
  phi_2 = phi + pi;
end;

a_cal_2 = real((cos(phi_2)*cos(psi)*cos(theta) + sin(phi_2)*sin(psi)*sin(theta)));
b_cal_2 = real((-cos(phi_2)*sin(psi)*sin(theta) + sin(phi_2)*cos(psi)*cos(theta)));
c_cal_2 = real((cos(phi_2)*cos(psi)*sin(theta) - sin(phi_2)*sin(psi)*cos(theta)));
d_cal_2 = real((cos(phi_2)*sin(psi)*cos(theta) + sin(phi_2)*cos(psi)*sin(theta)));
  
error_1 = (a-a_cal_1)^2+(b-b_cal_1)^2+(c-c_cal_1)^2+(d-d_cal_1)^2;
error_2 = (a-a_cal_2)^2+(b-b_cal_2)^2+(c-c_cal_2)^2+(d-d_cal_2)^2;

if (error_1 >= error_2)
  phi = phi_2;
elseif (error_2 > error_1)
  phi = phi_1;
end;

%else
%    r = 0;
  
%end;

end; % end if (abs_q ~= 0)

%(d_cal <= -d+th*eps)&(d_cal >= -d-th*eps)













