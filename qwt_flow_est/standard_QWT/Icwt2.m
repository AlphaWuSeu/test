function w = Icwt2(x);

%
% Complex Wavelet Transform (CWT) (decomposed to max level possible)
%
% Input: see FSfarras.m, dualfilt1.m (Ivan Selensnick's filters)
%
% Output:
%   w{i=1..2}{j=1..2} : 2-D wavelet transform of x (see Idwt2.m)
%   i - 1: real 2: imaginary
%   j - 1: positive orientations 2: negative orientations
%
% Example:
%   
%   w = Icwt2(x);
%
% by William Chan (4/7/05)
% 
% 

% get QWT first
w_q = Iqwt2(x);

% rearrange QWT components to get CWT (addition/subtraction)
% see cplxdual2D.m by Ivan Selensnick

[w{1}{1}, w{2}{2}] = pm(w_q{1}{1}, w_q{2}{2});
[w{1}{2}, w{2}{1}] = pm(w_q{1}{2}, w_q{2}{1});
