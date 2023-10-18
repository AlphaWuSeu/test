function w = qtrndual2D(x, J, Faf, af)

% Dual-Tree Quaternionic 2D Discrete Wavelet Transform
%
% USAGE:
%   w = qtrndual2D(x, J, Faf, af)
% INPUT:
%   x - 2-D array
%   J - number of stages
%   Faf{i}: first stage filters for tree i
%   af{i}:  filters for remaining stages on tree i
% OUTPUT:
%   w{j}{c1}{c2}{s} - wavelet coefficients
%       j = 1..J (scale)
%       c1 = 1,2; c2 = 1,2 
%       (4 combinations between c1 and c2: 11 12 21 22, 
%        equals 4 components of quaternion wavelets)  
%       s = 1,2,3 (subband)
%   w{J+1}{m}{n} - lowpass coefficients
%       m = 1,2; n = 1,2 
% EXAMPLE:
%   x = rand(256);
%   J = 5;
%   [Faf, Fsf] = FSfarras;
%   [af, sf] = dualfilt1;
%   w = qtrndual2D(x, J, Faf, af);
%   y = iqtrndual2D(w, J, Fsf, sf);
%   err = x - y;
%   max(max(abs(err)))
%
% WAVELET SOFTWARE AT POLYTECHNIC UNIVERSITY, BROOKLYN, NY
%
% Modified by: (William) Chan, Wai Lam, Rice University

% normalization
x = x/2;

for m = 1:2
    for n = 1:2
        [lo w{1}{m}{n}] = afb2D(x, Faf{m}, Faf{n});
        for j = 2:J
            [lo w{j}{m}{n}] = afb2D(lo, af{m}, af{n});
        end
        w{J+1}{m}{n} = lo;
    end
end

% THIS PART IS FOR COMPLEX WAVELETS
%for j = 1:J
%    for m = 1:3
%        [w{j}{1}{1}{m} w{j}{2}{2}{m}] = pm(w{j}{1}{1}{m},w{j}{2}{2}{m});
%        [w{j}{1}{2}{m} w{j}{2}{1}{m}] = pm(w{j}{1}{2}{m},w{j}{2}{1}{m});
%    end
%end

