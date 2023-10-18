function [D1_est,D2_est] = register_images(A,B,J,mag_th,r_th,js,interp_option,N1,M1)
  
% function [D1_est,D2_est] = register_images(A,B)
%
% purpose: to register two images A and B, plot the estimated disparity flow
%
% A         - reference image
% B         - target image
% J         - level of decomposition (largest block under analysis, or largest possible
%             disparity we want to estimate 2^J)
% mag_th    - threshold to eliminate unreliable disparity estimates based on 
%             QWT coefficient magnitude (smaller threshold -> more coefficients set to zero)
% r_th      - threshold to eliminate unreliable disparity estimates based on 
%             QWT phase calculation reliability (larger threshold -> more coefficients set to zero)
% js        - scale to display arrow (one arrow for every image block of size 2^js x 2^js pixels)
% interp_option 
%           - for function interp_dmap.m ('bilinear' or 'nearest') 
%           - method for scale-to-scale disparity estimate interpolation 
% 
%
% [D1_est,D2_est] - estimated disparity flow diagram data
%
% Created by William Chan (4/28/2005)
  
% (1) estimate local frequencies/slopes for each scale (coefficients)
% (2) estimate translation using local frequency data from (1)
% (3) plot estimated disparity flow using "quiver" command
  
% intialization 
% - need to know initial image size
% - QWT decomposition (determine level J first)
% - initialize mag_array, theta_1_a{1..J}{1..3} and theta_2_a{1..J}{1..3} arrays
% - initialize s1{1..J}{1..3} and s2{1..J}{1..3} arrays
% - initialize translation maps d1{1..J}{1..3} and d2{1..J}{1..3} arrays
  
[N,M] = size(A);
% J = 5;%round(log2(N/8)); % want at least 8x8 QWT coefficients in coarsest scale

% (1) estimate local frequencies/slopes for each scale (coefficients)
% - manually translate reference image A to get A_t
% - obtain QWT of A and A_t (w_a and w_a_t), also for B (w_b)
% - collect phase data in all scales for A,A_t,B
% - estimate local frequency/slope from collected data

% manually translate reference image A to obtain A_t with known shifts
t_step_ref = 1;
A_t = A;%zeros(size(A));
A_t(1:N-t_step_ref,1:M-t_step_ref) = A(t_step_ref+1:N,t_step_ref+1:M);

[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
w_a = qtrndual2D(A,J,Faf,af);
w_b = qtrndual2D(B,J,Faf,af);
w_a_t = qtrndual2D(A_t,J,Faf,af);

% collect phase data
[mag_array,theta_1_a,theta_2_a,r_a,theta_1_b,theta_2_b,theta_1_a_t,theta_2_a_t] = collect_phase_data(w_a,w_b,w_a_t,J,N);

% estimate local frequency/slope
[s1,s2] = estimate_local_freq_4(theta_1_a,theta_2_a,theta_1_a_t,theta_2_a_t,t_step_ref,J,N);
  

% (2) estimate translation using local frequency data from (1)
% - find slope data using theta_1 and theta_1_t (similarly for theta_2)
% - collect data in s1 and s2 arrays
% - remember to unwrap
% - how to use magnitude data or other method to determine reliability
%   of slope estimate?

[d1,d2] = estimate_disparity_4(theta_1_a,theta_2_a,mag_array,r_a,theta_1_b,theta_2_b,s1,s2,J,N,M,N1,M1,mag_th,r_th,interp_option);

% (3) plot estimated disparity flow using "quiver" command
% - obtain QWT of B
% - for each scale, estimate translation of B compared to A
%   to obtain 2 maps (d1 and d2) of translation magnitudes 
%   (one for each direction)

% final adjustment (reliability of phase angles based on magnitude)
d1_plot = d1;
d2_plot = d2;
    
% jj = J-1;
% [N,M] = size(d1_plot{jj}{1});
% m_s = 2;
% n_s = 2;
% n_e = N-1;
% m_e = M-1;
% 
% [X,Y]=meshgrid(n_s:n_e,m_s:m_e); 
% figure(1);
% for m = 1:3
%   
%   subplot(3,3,m);
%   
%   % plot only 2:n_e,2:m_e because of boundary effect on slope estimation
%   % (manual translation)
%   
%   quiver(X,Y,flipud(-d2_plot{jj}{m}(n_s:n_e,m_s:m_e)),flipud(d1_plot{jj}{m}(n_s:n_e,m_s:m_e))); ...
%       axis image; axis square; axis on; title(['m = ',num2str(m),' subband']);
%   
%   subplot(3,3,m+3);
%   imagesc(r_a{jj}{m}(n_s:n_e,m_s:m_e)); axis image; colormap(gray);
% 
%   subplot(3,3,m+6);
%   imagesc(mag_array{jj}{m}(n_s:n_e,m_s:m_e)); axis image; colormap(gray);
%   
% end;

combine_result_3; 

% this adjustment is for plotting quiver flow by itself
D2_est = d1_flip';
D1_est = d2_flip';

% this adjustment is for plotting quiver flow on top of image
%D1_est = flipud(d2_flip)';
%D2_est = flipud(-d1_flip)';