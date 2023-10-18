function [qw1, qw2, qw3] = cplx_to_qtrn3D(cw,J)

% 3D Quaternion Dual-Tree Discrete Wavelet Transform
% (obtain 3D QWT coefficients from 3D CWT)
%
% USAGE:
%   [qw1, qw2, qw3] = cplx_to_qtrn3D(cw,J)
% INPUT:
%   J - number of stages
%   cw - output parameter from cplxdual3D.m
% OUPUT:
%   qw1{j}{m}{n}{p}{d} - quaternionic wavelet coefficients
%       j = 1..J, m = 1..2, n = 1..2, p = 1..2, d = 1..7
%   qw1{J+1}{m}{n}{d} - lowpass coefficients
%       m = 1..2, n = 1..2, p = 1..2, d = 1..7
%   same for qw2 and qw3
%  
% Note: redundancy of 3D QWT (this implementation) is 3 times
%       3D CWT
%  
% Created by William Chan - 2 November 2003

qw1=cw;

for j = 1:J
  for m = 1:7
    
    % real part
    [qw1{j}{1}{1}{1}{m} qw1{j}{1}{2}{2}{m}] = pm(cw{j}{1}{1}{1}{m}, cw{j}{1}{2}{2}{m});
    [qw1{j}{2}{1}{2}{m} qw1{j}{2}{2}{1}{m}] = pm(cw{j}{2}{1}{2}{m}, cw{j}{2}{2}{1}{m});
    % complex part
    [qw1{j}{2}{2}{2}{m} qw1{j}{2}{1}{1}{m}] = pm(cw{j}{2}{2}{2}{m}, cw{j}{2}{1}{1}{m});
    [qw1{j}{1}{2}{1}{m} qw1{j}{1}{1}{2}{m}] = pm(cw{j}{1}{2}{1}{m}, cw{j}{1}{1}{2}{m});
    
  end
end
 
qw2=cw;

for j = 1:J
  for m = 1:7
    
    % real part
    [qw2{j}{1}{1}{1}{m} qw2{j}{2}{1}{2}{m}] = pm(cw{j}{1}{1}{1}{m}, cw{j}{2}{1}{2}{m});
    [qw2{j}{1}{2}{2}{m} qw2{j}{2}{2}{1}{m}] = pm(cw{j}{1}{2}{2}{m}, cw{j}{2}{2}{1}{m});
    % complex part
    [qw2{j}{2}{2}{2}{m} qw2{j}{1}{2}{1}{m}] = pm(cw{j}{2}{2}{2}{m}, cw{j}{1}{2}{1}{m});
    [qw2{j}{2}{1}{1}{m} qw2{j}{1}{1}{2}{m}] = pm(cw{j}{2}{1}{1}{m}, cw{j}{1}{1}{2}{m});
    
  end
end

qw3 = cw;
  
for j = 1:J
  for m = 1:7
    
    % real part
    [qw3{j}{1}{1}{1}{m} qw3{j}{2}{2}{1}{m}] = pm(cw{j}{1}{1}{1}{m}, cw{j}{2}{2}{1}{m});
    [qw3{j}{1}{2}{2}{m} qw3{j}{2}{1}{2}{m}] = pm(cw{j}{1}{2}{2}{m}, cw{j}{2}{1}{2}{m});
    % complex part
    [qw3{j}{2}{2}{2}{m} qw3{j}{1}{1}{2}{m}] = pm(cw{j}{2}{2}{2}{m}, cw{j}{1}{1}{2}{m});
    [qw3{j}{2}{1}{1}{m} qw3{j}{1}{2}{1}{m}] = pm(cw{j}{2}{1}{1}{m}, cw{j}{1}{2}{1}{m});
    
  end
end





