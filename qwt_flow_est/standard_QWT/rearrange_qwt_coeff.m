function w_r = rearrange_qwt_coeff(w)
  
% function w_r = rearrange_qwt_coeff(w)
%  
% Want to rearrange w such that the qwt coefficients are in the format:
% w_r{1..J}{1..3} contains the corresponding subband coefficients
%
% *** (from output of Iqwt2.m to qtrndual2D.m) ***
%
% usage: 
%          w = Iqwt2(x);
%          w_r = rearrange_qwt_coeff(w);
%          w_new = irrearrange_qwt_coeff(w_r);
%          x_new = Iiqwt2(w_new);
%          max(max(abs(x_new-x)))  
%
% 
% Written by William Chan (3/16/2005)
 
S = size(w{1}{1},1);
L = log2(S);  
  
w_r{L+1}{1}{1} = w{1}{1}(1,1);
w_r{L+1}{2}{1} = w{2}{1}(1,1);
w_r{L+1}{1}{2} = w{1}{2}(1,1);
w_r{L+1}{2}{2} = w{2}{2}(1,1);

for jj = 1:L
  
  k = L-jj+1;
  J = 2^(k-1);
  
  % need this special arrangement to get same results as qtrndual2D.m
  
  % LH subband
  si = 1; ei = J; sj = J+1; ej = 2*J;
  w_r{jj}{1}{1}{1} = -w{2}{2}(si:ei,sj:ej);
  w_r{jj}{2}{1}{1} = -w{2}{1}(si:ei,sj:ej);
  w_r{jj}{1}{2}{1} = w{1}{2}(si:ei,sj:ej);
  w_r{jj}{2}{2}{1} = w{1}{1}(si:ei,sj:ej);

  % HL subband
  si = J+1; ei = 2*J; sj = 1; ej = J;
  w_r{jj}{1}{1}{2} = -w{2}{2}(si:ei,sj:ej);
  w_r{jj}{2}{1}{2} = w{2}{1}(si:ei,sj:ej);
  w_r{jj}{1}{2}{2} = -w{1}{2}(si:ei,sj:ej);
  w_r{jj}{2}{2}{2} = w{1}{1}(si:ei,sj:ej);
  
  % HH subband
  si = J+1; ei = 2*J; sj = J+1; ej = 2*J;
  w_r{jj}{1}{1}{3} = w{2}{2}(si:ei,sj:ej);
  w_r{jj}{2}{1}{3} = -w{2}{1}(si:ei,sj:ej);
  w_r{jj}{1}{2}{3} = -w{1}{2}(si:ei,sj:ej);
  w_r{jj}{2}{2}{3} = w{1}{1}(si:ei,sj:ej);
  
end;


