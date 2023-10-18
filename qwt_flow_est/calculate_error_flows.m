function [D1_err, D2_err, D1_c, D2_c, D1_est, D2_est] = calculate_error_flows(D1_est, D2_est, D1_c, D2_c, N, M, N1, M1, js)

% purpose: compare the estimated disparity flows (D1_est,D2_est)
%          with the correct disparity flows (D1_c,D2_c)
%
% [N1,M1] - original image size (without borders)
%         - size equals to size(D1_c) and size(D2_c)
% [N,M]   - image size (including borders) 
% js      - current scale under analysis (flow display)
%
% Created by William Chan
% Date: November 13, 2005

[N_d_est, M_d_est] = size(D1_est);

% cut away borders from D1_est and D2_est
buf_N = round((N-N1)/2/2^js); 
buf_M = round((M-M1)/2/2^js);

D1_est = D1_est(buf_N+1:end-buf_N,buf_M+1:end-buf_M);
D2_est = D2_est(buf_N+1:end-buf_N,buf_M+1:end-buf_M);

% resize correct flows to the size of D1_est and D2_est
D1_c = imresize(D1_c,size(D1_est),'bilinear'); %resize_correct_flows(D1_c,N_d_est,M_d_est);
D2_c = imresize(D2_c,size(D2_est),'bilinear'); %resize_correct_flows(D2_c,N_d_est,M_d_est);

D1_err = D1_c - D1_est;
D2_err = D2_c - D2_est;