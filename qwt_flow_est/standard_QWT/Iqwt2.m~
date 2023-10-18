function w = Iqwt2(x)

%
% Quaternion Wavelet Transform (QWT) (decomposed to max level possible)
%
% Input: see FSfarras.m, dualfilt1.m (Ivan Selensnick's filters)
%
% Output:
%   w{1..2}{1..2} : 2-D wavelet transform of x (see Idwt2.m)
%
% Example:
%   
%   [Faf,Fsf] = FSfarras;
%   [af,sf] = dualfilt1;
%   w = Iqwt2(x,Faf,af);
%
% by William Chan (4/7/05)
% 
% 

% normalize
x = x/2;

[Faf,Fsf] = FSfarras;
[af,sf] = dualfilt1;

H{1} = Faf{1}(:,1);
H{2} = Faf{2}(:,1);

h{1} = af{1}(:,1);
h{2} = af{2}(:,1);

for m = 1:2
   for n = 1:2
      
      w{m}{n} = Idwt2(x,H{m},H{n},1); %compute wavelet transform
		[a,b] = size(w{m}{n});
		w_temp = Idwt2(w{m}{n}(1:a/2,1:b/2),h{m},h{n});
		w{m}{n}(1:a/2,1:b/2) = w_temp;
   
   end;
end;	
