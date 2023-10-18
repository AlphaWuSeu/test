%close all;
% sorry; in 

% scale to display
% js = J-3; (js is an input parameter in register_images.m)
[N2,M2] = size(d1{js}{1});

m = 3; % m = 3,2,1 estimates are all the same, since they are already merged

D1map = d1{js}{m};
D2map = d2{js}{m};



f = 2^(js-2);

n_s = 1; n_e = N2;
m_s = 1; m_e = M2;

% rotation stage
%n_s = ceil(40/f); n_e = ceil(N2-3/f);
%m_s = ceil(2/f); m_e = ceil(M2-1/f);

% rubik's cube
%n_s = ceil(20/f); n_e = ceil(52/f);
%m_s = ceil(11/f); m_e = ceil(52/f);

% ultradata original region
%n_s = ceil(20/2^js); n_e = ceil(N2-20/2^js);
%m_s = 1; m_e = M2;

% edge
%n_s = ceil(16/2^js+1); n_e = ceil(N2-16/2^js-1);
%m_s = ceil(16/2^js+1); m_e = ceil(M2-16/2^js-1);

[X,Y]=meshgrid(n_s:n_e,m_s:m_e); 

d2_flip = flipud(-D2map(n_s:n_e,m_s:m_e));
d1_flip = flipud(D1map(n_s:n_e,m_s:m_e));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get rid of out-lyers (need to adjust this for different scales, also depend on disparity)
% ind = abs(d1_flip(:))>(mean(abs(d1_flip(:)))+3*std(abs(d1_flip(:))));
% disp(['number of zeroed-out pixels: ', num2str(sum(ind))]);
% d1_flip(ind) = 0;
% 
% ind = abs(d2_flip(:))>(mean(abs(d2_flip(:)))+3*std(abs(d2_flip(:))));
% disp(['number of zeroed-out pixels: ', num2str(sum(ind))]);
% d2_flip(ind) = 0;

% buf_N = round((N-N1)/2/2^js); 
% buf_M = round((M-M1)/2/2^js);
% 
% d_flip_abs = sqrt(d1_flip.^2+d2_flip.^2);
% d_flip_abs_center = sqrt(d1_flip(buf_N+2:end-buf_N,buf_M+1:end-buf_M-1).^2+d2_flip(buf_N+2:end-buf_N,buf_M+1:end-buf_M-1).^2);
% %ind_nonzero = (d_flip_abs_center ~= 0);
% ind = abs(d_flip_abs(:))>(mean(abs(d_flip_abs_center(:)))+3*std(abs(d_flip_abs_center(:))));
% disp(['number of zeroed-out pixels: ', num2str(sum(ind))]);
% d1_flip(ind) = 0;
% d2_flip(ind) = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure(2);
quiver(Y,X,d2_flip',d1_flip'); axis image; axis on; 
title('Raw Estimated Disparity Plot');
% 
figure(3); image(A((n_s-1)*2^js+1:n_e*2^js,(m_s-1)*2^js+1:m_e*2^js)); ...
     colormap(gray(256)); axis image; axis off;
%title('Estimated Disparity Plot (over reference image A)');
 
 hold on;
 [X,Y]=meshgrid(1:2^js:(n_e-n_s+1)*2^js,1:2^js:(m_e-m_s+1)*2^js); 
 quiver(Y,X,flipud(d2_flip)',flipud(-d1_flip)',2,'r'); axis image; axis off; 
 hold off;