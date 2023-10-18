% qtrndual3D_plots
% DISPLAY 3D WAVELETS OF QTRNDUAL3D.M
%
% Created by William Chan - 3 November 2003

%figure(2);
clear all;
close all;

[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
J = 4;
L = 2*2^(J+1);
N = L/2^J;
x = zeros(L,L,L);
[w1,w2,w3] = qtrndual3D(x, J, Faf, af);
w1{J}{2}{1}{2}{7}(N/2,N/2,N/2) = 1;
%w{J}{2}{2}{1}{7}(N/2,N/2,N/2) = 1;
%w{J}{2}{2}{2}{7}(N/2,N/2,N/2) = 1;
%w{J}{1}{2}{1}{7}(N/2,N/2,N/2) = 1;
y = iqtrndual3D(w1,w2,w3, J, Fsf, sf);

yr = y;
subplot(121);
v = 1:L;
S = 0.0010;
p1 = patch(isosurface(v,v,v,yr,S));
isonormals(v,v,v,yr,p1);
set(p1,'FaceColor','red','EdgeColor','none'); 
hold on
p2 = patch(isosurface(v,v,v,yr,-S));
isonormals(v,v,v,yr,p2);
set(p2,'FaceColor','blue','EdgeColor','none'); 
hold off
daspect([1 1 1]);
view(-30,30); 
camlight;
lighting phong
grid
axis([10 40 10 40 10 40])
set(gca,'fontsize',7)
title('3-D WAVELET ISOSURFACE (REAL PART)')
set(gcf,'paperposition',[0.5 0.5 0 0]+[0 0 3 3])
%print -djpeg95 cplxdual3D_plots_1
%print -depsc cplxdual3D_plots_1
yr = y;

w1{J}{2}{1}{2}{7}(N/2,N/2,N/2) = 0;
w1{J}{2}{2}{1}{7}(N/2,N/2,N/2) = 1;
%w{J}{1}{1}{1}{7}(N/2,N/2,N/2) = 1;
%w{J}{2}{1}{2}{7}(N/2,N/2,N/2) = -1;
%w{J}{2}{2}{2}{7}(N/2,N/2,N/2) = 1;
%w{J}{1}{1}{2}{7}(N/2,N/2,N/2) = 1;
y = iqtrndual3D(w1,w2,w3, J, Fsf, sf);

yi = y;
subplot(122);
v = 1:L;
S = 0.0010;
p1 = patch(isosurface(v,v,v,yi,S));
isonormals(v,v,v,yi+1,p1);
set(p1,'FaceColor','red','EdgeColor','none'); 
hold on
p2 = patch(isosurface(v,v,v,yi,-S));
isonormals(v,v,v,y,p2);
set(p2,'FaceColor','blue','EdgeColor','none'); 
hold off
daspect([1 1 1]);
view(-30,30); 
camlight;
lighting phong
grid
axis([10 40 10 40 10 40])
set(gca,'fontsize',7)
title('3-D WAVELET ISOSURFACE (IMAGINARY PART)')
set(gcf,'paperposition',[0.5 0.5 0 0]+[0 0 3 3])
%print -djpeg95 cplxdual3D_plots_2
%print -depsc cplxdual3D_plots_2
yi = y;





