function [w1,w2,w3] = qtrndual3D(x, J, Faf, af)

% 3D quaternionic Dual-Tree Discrete Wavelet Transform
%
% USAGE:
%   [w1,w2,w3] = qtrndual3D(x, J, Faf, af)
% INPUT:
%   x - 3D array
%   J - number of stages
%   Faf - first stage filters
%   af - filters for remaining stages
% OUPUT:
%   w{j}{m}{n}{p}{d} - wavelet coefficients
%       j = 1..J, m = 1..2, n = 1..2, p = 1..2, d = 1..7
%   w{J+1}{m}{n}{d} - lowpass coefficients
%       m = 1..2, n = 1..2, p = 1..2, d = 1..7
%  
% Note: there are w1,w2,w3 because of the 3 times redundancy
%       of 3D QWT, as compared to 3D CWT
%
% Created by William Chan - 3 November 2003

% normalization
x = x/sqrt(3);  
  
% first obtain complex wavelets
cw = cplxdual3D(x, J, Faf, af); 

% obtain quaternionic wavelets
[w1,w2,w3] = cplx_to_qtrn3D(cw,J);
