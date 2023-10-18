function [T1_w, T2_w] = wrap_quaternion_phase(T1,T2,Dmap1,Dmap2,W1,W2)
  
% wrap values in T1 (theta_1) and T2 (theta_2) by (W1,W2) to the closest values in (Dmap1,Dmap2) 
% T1,T2,Dmap1,Dmap2,W1,W2 can be all matrices
  

ind_f_e1 = (rem(floor((T1-Dmap1)./W1),2)==0); % all even wraps for theta_1
ind_f_o1 = (rem(floor((T1-Dmap1)./W1),2)~=0); % all odd wraps for theta_1

ind_f_e2 = (rem(floor((T2-Dmap2)./W2),2)==0); % all even wraps for theta_2
ind_f_o2 = (rem(floor((T2-Dmap2)./W2),2)~=0); % all odd wraps for theta_2


Rf_T1 = T1 - floor((T1-Dmap1)./W1).*W1;
Rc_T1 = T1 - ceil((T1-Dmap1)./W1).*W1;
% if divisible
if (length(W1) == 1)
    Rc_T1(rem((T1-Dmap1),W1)==0) = Rf_T1(rem((T1-Dmap1),W1)==0) - W1;
else
    Rc_T1(rem((T1-Dmap1),W1)==0) = Rf_T1(rem((T1-Dmap1),W1)==0) - W1(rem((T1-Dmap1),W1)==0);
end;

Rf_T2 = T2 - floor((T2-Dmap2)./W2).*W2;
Rc_T2 = T2 - ceil((T2-Dmap2)./W2).*W2;
% if divisible
if (length(W2) == 1)
    Rc_T2(rem((T2-Dmap2),W2)==0) = Rf_T2(rem((T2-Dmap2),W2)==0) - W2;
else
    Rc_T2(rem((T2-Dmap2),W2)==0) = Rf_T2(rem((T2-Dmap2),W2)==0) - W2(rem((T2-Dmap2),W2)==0);
end;

% ind_f_e1 = (~ind_f_o1)
A1 = Rf_T1.*ind_f_e1 + Rc_T1.*(~ind_f_e1);
A2 = Rf_T2.*ind_f_e2 + Rc_T2.*(~ind_f_e2);

B1 = Rf_T1.*ind_f_o1 + Rc_T1.*(~ind_f_o1);
B2 = Rf_T2.*ind_f_o2 + Rc_T2.*(~ind_f_o2);

ind = (abs(A1-Dmap1)+abs(A2-Dmap2)) < (abs(B1-Dmap1)+abs(B2-Dmap2));
T1_w = A1.*ind + B1.*(~ind);
T2_w = A2.*ind + B2.*(~ind);

