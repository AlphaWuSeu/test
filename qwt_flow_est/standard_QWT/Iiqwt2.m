function y = Iiqwt2(w)

%
% Inverse Quaternion Wavelet Transform (IQWT) (decomposed to max level possible)
%
% Output: see FSfarras.m, dualfilt1.m (Ivan Selensnick's filters)
%      
% Input: 
%
%   *** input the analysis filters (Faf,af)! NOT the synthesis filters (Fsf,sf)...
%   w{1..2}{1..2} : 2-D wavelet transform of x (see Idwt2.m)
%
% Example:
%   
%   [Faf,Fsf] = FSfarras;
%   [af,sf] = dualfilt1;
%   w = Iqwt2(x,Faf,af);
%   y = Iiqwt2(w,Fsf,sf);
%
% by William Chan (4/7/05)
% 
% 

y = zeros(size(w{1}{1}));

[Faf,Fsf] = FSfarras;
[af,sf] = dualfilt1;

H{1} = Faf{1}(:,1);
H{2} = Faf{2}(:,1);

h{1} = af{1}(:,1);
h{2} = af{2}(:,1);

for m = 1:2
   for n = 1:2
      
      [a,b] = size(w{m}{n});
      w_temp = w{m}{n}(1:a/2,1:b/2);
      y_temp = Iidwt2(w_temp,h{m},h{n});
      
      w{m}{n}(1:a/2,1:b/2) = y_temp;
      y = y + Iidwt2(w{m}{n},H{m},H{n},1);
 
   end;
end;	

% normalize
y = y/2;