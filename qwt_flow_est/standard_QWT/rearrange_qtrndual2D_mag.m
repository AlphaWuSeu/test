function w_r = rearrange_qtrndual2D_mag(w,J)
  
% Purpose: Re-arrange output format of 2-D QWT from qtrndual2D.m
%          to a typical wavelet transform format (magnitude-only)
% 
%   w{j}{i}{d1}{d2} - wavelet coefficients
%   J - level of decomposition
  
% calculate QWT magnitudes
w_mag{J+1} = sqrt(w{J+1}{1}{1}.^2+w{J+1}{1}{2}.^2+w{J+1}{2}{1}.^2+w{J+1}{2}{2}.^2); % LL subband

for l = 1:J
  for m = 1:3
    
    w_mag{l}{m} = sqrt(w{l}{1}{1}{m}.^2+w{l}{1}{2}{m}.^2+w{l}{2}{1}{m}.^2+w{l}{2}{2}{m}.^2);
    
  end;
end;

% re-arrange QWT coefficients
LL = w_mag{J+1};

for l = J:-1:1
  LH = w_mag{l}{1};
  HL = w_mag{l}{2};
  HH = w_mag{l}{3};
  LL = [LL LH; HL HH];
end;

w_r = LL;