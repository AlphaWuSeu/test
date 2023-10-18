clear all;
close all;

addpath ../qwt_flow_est/standard_QWT; % need to add correct path to "standard_QWT" directory

% initialize parameters for register_images.m (see comment in register_images.m)
J = 5; % scale needs to be chosen depends on features present in image
mag_th = 5; % smaller threshold -> more coefficients set to zero
r_th = 0.4; % larger threshold -> more coefficients set to zero
js = 3; % scale needs to be chosen depends on features present in image
interp_option = 'bilinear'; 

% choose which image sequence to register
seq_choice = 'tree_trans'; % rubic | taxi | tree_div | tree_trans | square | sine | yosemite | sri_trees | heart | pentagon |edge

for k = 6 
    
    disp(['k = ',num2str(k)]);
    
    seq_n1 = k;
    seq_n2 = k+1;

[A,B,A_o,B_o,correct_flow_s,N1,M1] = pick_images(seq_choice,seq_n1,seq_n2);

[N,M] = size(A); % new image size after adjustment

figure(4); subplot(121); image(A); axis image; colormap(gray(256)); axis on;
title('Reference Image A');
subplot(122); image(B); axis image; colormap(gray(256)); axis on;
title('Target Image B');

tic;
[D1_est,D2_est] = register_images(A,B,J,mag_th,r_th,js,interp_option,N1,M1);
toc;

% convert to orientation suitable for plotting over image
%D1_plot(:,:,k) = fliplr(D1_est);
%D2_plot(:,:,k) = fliplr(-D2_est);


% read and compare correct flows
if (~isempty(correct_flow_s))
    [D1_c,D2_c] = read_correct_flows(correct_flow_s);
    
D1_c = D1_c*(seq_n2-seq_n1);
D2_c = D2_c*(seq_n2-seq_n1);

%% convert to orientation suitable for plotting over image
%D1_c = fliplr(D1_c);
%D2_c = fliplr(-D2_c);

[D1_err, D2_err, D1_c_r, D2_c_r, D1_est_r, D2_est_r] = calculate_error_flows(D1_est, D2_est, D1_c, D2_c, N, M, N1, M1, js);
% D1_est_r and D2_est_r are the same as D1_est and D2_est, except without the border
% D1_c_r and D2_c_r are resized to be the same as D1_est_r and D2_est_r

% calculate and display angular errors
[phif,stf,phic,stc,Ef,Ecfin] = eval_flow (D1_est_r, D2_est_r, D1_c_r, D2_c_r);
fprintf ('Angular error (full): %.4f deg (%.4f deg)\n', phif, stf) % not so good estimates cos algorithm only based on two images
avg_ang_err(k) = phif;
std_ang_err(k) = stf;
avg_err1(k) = mean((D1_est_r(:)-D1_c_r(:)).^2);
avg_err2(k) = mean((D2_est_r(:)-D2_c_r(:)).^2);
%avg_err1 = mean(abs(D1_est_r(:)-D1_c_r(:)));
%avg_err2 = mean(abs(D2_est_r(:)-D2_c_r(:)));

fprintf ('Average l_2 error (d_1,d_2): (%.4f, %.4f)\n', avg_err1(k), avg_err2(k)) % not so good estimates cos algorithm only based on two images

%close all;
[x,y] = size(D1_est_r);
[X,Y] = meshgrid(1:x,1:y);
figure(5); quiver(Y,X,D1_c_r,D2_c_r,'b'); axis image;
hold on; quiver(Y,X,D1_est_r,D2_est_r,'r'); hold off;
title('Correct Disparity Flow (Ground Truth)');

%[mean(mean(D1_est_r)) mean(mean(D1_c_r))]

D1_err(D1_est==0) = 0;
D2_err(D2_est==0) = 0;

% % plot error flows
figure(6); image(A_o); colormap(gray(256)); axis image; axis off;
title('Disparity Estimation Error');
hold on;
 [N2,M2] = size(D1_err);
[X,Y]=meshgrid([0:N2-1]*2^js+1,[0:M2-1]*2^js+1);  
quiver(Y,X,flipud(D1_err')',flipud(-D2_err')','b'); axis image; axis off; 
hold off;

% [N_err,M_err] = size(D1_err);
% % Calculate average error and percentage error (what is a good indicator/metric?)
% avg_err = sqrt(sum(sum(D1_err.^2+D2_err.^2)))/N_err/M_err
% per_err = avg_err/mean(mean(sqrt(D1_c.^2+D2_c.^2))) 

end;

%QWT_psnr;

end;

%save QWT_estimation_results_heart_2 D1_plot D2_plot;
%save QWT_estimation_results D1_est D2_est;