function [cw1,cw2,cw3] = qtrn_to_cplx3D(qw1,qw2,qw3,J)

% 3D Quaternion Dual-Tree Discrete Wavelet Transform
% (obtain 3D CWT coefficients back from 3D QWT)
%
% USAGE:
%   [cw1,cw2,cw3] = qtrn_to_cplx3D(qw1,qw2,qw3,J)
%
% INPUT:
%   J - number of stages
%   qw1{j}{m}{n}{p}{d} - quaternionic wavelet coefficients
%       j = 1..J, m = 1..2, n = 1..2, p = 1..2, d = 1..7
%   qw1{J+1}{m}{n}{d} - lowpass coefficients
%       m = 1..2, n = 1..2, p = 1..2, d = 1..7
%   same for qw2 and qw3
%  
% Note: redundancy of 3D QWT (this implementation) is 3 times
%       3D CWT
%
% OUTPUT:
%   cw1{j}{m}{n}{p}{d} - quaternionic wavelet coefficients
%       j = 1..J, m = 1..2, n = 1..2, p = 1..2, d = 1..7
%   cw1{J+1}{m}{n}{d} - lowpass coefficients
%       m = 1..2, n = 1..2, p = 1..2, d = 1..7
%   same for cw2 and cw3 (redundancy = 3)
%  
% Created by William Chan - 2 November 2003

cw1=qw1;

for j = 1:J
  for m = 1:7
    
    % real part
    [cw1{j}{1}{1}{1}{m} cw1{j}{1}{2}{2}{m}] = pm(qw1{j}{1}{1}{1}{m}, qw1{j}{1}{2}{2}{m});
    [cw1{j}{2}{1}{2}{m} cw1{j}{2}{2}{1}{m}] = pm(qw1{j}{2}{1}{2}{m}, qw1{j}{2}{2}{1}{m});
    % complex part
    [cw1{j}{2}{2}{2}{m} cw1{j}{2}{1}{1}{m}] = pm(qw1{j}{2}{2}{2}{m}, qw1{j}{2}{1}{1}{m});
    [cw1{j}{1}{2}{1}{m} cw1{j}{1}{1}{2}{m}] = pm(qw1{j}{1}{2}{1}{m}, qw1{j}{1}{1}{2}{m});
    
  end
end
 
cw2=qw2;

for j = 1:J
  for m = 1:7
    
    % real part
    [cw2{j}{1}{1}{1}{m} cw2{j}{2}{1}{2}{m}] = pm(qw2{j}{1}{1}{1}{m}, qw2{j}{2}{1}{2}{m});
    [cw2{j}{1}{2}{2}{m} cw2{j}{2}{2}{1}{m}] = pm(qw2{j}{1}{2}{2}{m}, qw2{j}{2}{2}{1}{m});
    % complex part
    [cw2{j}{2}{2}{2}{m} cw2{j}{1}{2}{1}{m}] = pm(qw2{j}{2}{2}{2}{m}, qw2{j}{1}{2}{1}{m});
    [cw2{j}{2}{1}{1}{m} cw2{j}{1}{1}{2}{m}] = pm(qw2{j}{2}{1}{1}{m}, qw2{j}{1}{1}{2}{m});
    
  end
end

cw3 = qw3;
  
for j = 1:J
  for m = 1:7
    
    % real part
    [cw3{j}{1}{1}{1}{m} cw3{j}{2}{2}{1}{m}] = pm(qw3{j}{1}{1}{1}{m}, qw3{j}{2}{2}{1}{m});
    [cw3{j}{1}{2}{2}{m} cw3{j}{2}{1}{2}{m}] = pm(qw3{j}{1}{2}{2}{m}, qw3{j}{2}{1}{2}{m});
    % complex part
    [cw3{j}{2}{2}{2}{m} cw3{j}{1}{1}{2}{m}] = pm(qw3{j}{2}{2}{2}{m}, qw3{j}{1}{1}{2}{m});
    [cw3{j}{2}{1}{1}{m} cw3{j}{1}{2}{1}{m}] = pm(qw3{j}{2}{1}{1}{m}, qw3{j}{1}{2}{1}{m});
    
  end
end





