% qtrndual2D_plots
% DISPLAY 2D WAVELETS OF qtrndual2D.M

J = 4;
L = 1.5*2^(J+1);
N = L/2^J;
[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
x = zeros(L,4*L);
w = qtrndual2D(x, J, Faf, af);
w{J}{1}{1}{1}(ceil(N/2),ceil(N/2+2*N)) = 1;
w{J}{1}{2}{1}(ceil(N/2),ceil(N/2+3*N)) = 1;
w{J}{2}{1}{1}(ceil(N/2),ceil(N/2+0*N)) = 1;
w{J}{2}{2}{1}(ceil(N/2),ceil(N/2+1*N)) = 1;

%w{J}{1}{1}{2}(ceil(N/2),ceil(N/2+1*N)) = 1;
%w{J}{1}{2}{2}(ceil(N/2),ceil(N/2+0*N)) = 1;
%w{J}{2}{1}{2}(ceil(N/2),ceil(N/2+3*N)) = 1;
%w{J}{2}{2}{2}(ceil(N/2),ceil(N/2+2*N)) = 1;

%w{J}{1}{1}{3}(ceil(N/2),ceil(N/2+0*N)) = 1;
%w{J}{1}{2}{3}(ceil(N/2),ceil(N/2+1*N)) = 1;
%w{J}{2}{1}{3}(ceil(N/2),ceil(N/2+2*N)) = 1;
%w{J}{2}{2}{3}(ceil(N/2),ceil(N/2+3*N)) = 1;

y = iqtrndual2D(w, J, Fsf, sf);
y = [y sqrt(y(:,1:L).^2+y(:,L+[1:L]).^2+y(:,2*L+[1:L]).^2+y(:,3*L+[1:L]).^2)];
figure
clf
imagesc(y);
%title('2D Dual-Tree Quaternionic Wavelets')
axis image
axis off
%colormap(gray(128)); 
colormap(jet);
%print -djpeg95 cplxdual2D_plots