function w = irearrange_qwt_coeff(w_r)
  
% function w = rearrange_qwt_coeff(w_r)
%  
% Want to rearrange w_r such that the qwt coefficients are in the format
% of all scales tiled in one big image contains the corresponding subband
% coefficients 
%
% *** (from output of qtrndual2D.m back to Iqwt2.m) ***
% usage: 
%          w = Iqwt2(x);
%          w_r = rearrange_qwt_coeff(w);
%          w_new = irrearrange_qwt_coeff(w_r);
%          x_new = Iiqwt2(w_new);
%          max(max(abs(x_new-x)))  
% 
% Written by William Chan (3/16/2005)
 
S = 2*size(w_r{1}{1}{1}{1},1);
L = log2(S);  
  
for m = 1:2
  for n = 1:2
    w{m}{n} = zeros(S,S);
  end;
end;

w{1}{1}(1,1) = w_r{L+1}{1}{1};
w{2}{1}(1,1) = w_r{L+1}{2}{1};
w{1}{2}(1,1) = w_r{L+1}{1}{2};
w{2}{2}(1,1) = w_r{L+1}{2}{2};

for jj = 1:L
  
      k = L-jj+1;
      J = 2^(k-1);
      
      % LH subband
      si = 1; ei = J; sj = J+1; ej = 2*J;
      w{2}{2}(si:ei,sj:ej)=-w_r{jj}{1}{1}{1};
      w{2}{1}(si:ei,sj:ej)=-w_r{jj}{2}{1}{1};
       w{1}{2}(si:ei,sj:ej)=w_r{jj}{1}{2}{1};
      w{1}{1}(si:ei,sj:ej)=w_r{jj}{2}{2}{1};
      
      % HL subband
      si = J+1; ei = 2*J; sj = 1; ej = J;
      w{2}{2}(si:ei,sj:ej)=-w_r{jj}{1}{1}{2};
      w{2}{1}(si:ei,sj:ej)=w_r{jj}{2}{1}{2};
      w{1}{2}(si:ei,sj:ej)=-w_r{jj}{1}{2}{2};
      w{1}{1}(si:ei,sj:ej)=w_r{jj}{2}{2}{2};
      
      % HH subband
      si = J+1; ei = 2*J; sj = J+1; ej = 2*J;
      w{2}{2}(si:ei,sj:ej)=w_r{jj}{1}{1}{3};
      w{2}{1}(si:ei,sj:ej)=-w_r{jj}{2}{1}{3};
      w{1}{2}(si:ei,sj:ej)=-w_r{jj}{1}{2}{3};
      w{1}{1}(si:ei,sj:ej)=w_r{jj}{2}{2}{3};
      
end;
