function y = iqtrndual3D(w1,w2,w3, J, Fsf, sf)

% inverse 3D quaternionic Dual-Tree Discrete Wavelet Transform
%
% USAGE:
%   function y = iqtrndual3D(w1,w2,w3, J, Fsf, sf)
% INPUT:
%   J - number of stages
%   Fsf - synthesis filter for last stage
%   sf - synthesis filters for preceeding stages
% OUTPUT:
%   y - output array
% See qtrndual3D
%  
% Created by William Chan - 3 November 2003
  
% obtain complex wavelets from qtrn wavelets
[cw1,cw2,cw3] = qtrn_to_cplx3D(w1,w2,w3,J);

% inverse complex wavelet transform
y1 = icplxdual3D(cw1, J, Fsf, sf);
y2 = icplxdual3D(cw2, J, Fsf, sf);
y3 = icplxdual3D(cw3, J, Fsf, sf);

y = y1+y2+y3;

% normalization
y = y/sqrt(3);
