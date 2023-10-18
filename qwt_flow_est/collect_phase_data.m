function [mag_array,theta_1_a,theta_2_a,r_a,theta_1_b,theta_2_b,theta_1_a_t,theta_2_a_t] = collect_phase_data(w_a,w_b,w_a_t,J,N)
  
% w_a,w_b,w_a_t are output of qtrndual2D.m (QWT coefficients)
%
% this program is just a part of register_images.m

for jj = 1:J
  for m = 1:3

    S = N/(2^jj);
    r_a{jj}{m} = zeros(S,S);
    mag_array{jj}{m} = zeros(S,S);
    theta_1_a{jj}{m} = zeros(S,S);
    theta_2_a{jj}{m} = zeros(S,S);
    theta_1_b{jj}{m} = zeros(S,S);
    theta_2_b{jj}{m} = zeros(S,S);
    theta_1_a_t{jj}{m} = zeros(S,S);
    theta_2_a_t{jj}{m} = zeros(S,S);
    
  end; % m = 1:3
end; % jj = 1:J

for jj = 1:J  
  for m = 1:3
    
    a = w_a{jj}{1}{1}{m};
    b = -w_a{jj}{2}{1}{m};
    c = -w_a{jj}{1}{2}{m};
    d = w_a{jj}{2}{2}{m};
    
    [a,b,c,d] = flip_group_coeff_signs(a,b,c,d,m);
    
    a_t = w_a_t{jj}{1}{1}{m};
    b_t = -w_a_t{jj}{2}{1}{m};
    c_t = -w_a_t{jj}{1}{2}{m};
    d_t = w_a_t{jj}{2}{2}{m};
    
    [a_t,b_t,c_t,d_t] = flip_group_coeff_signs(a_t,b_t,c_t,d_t,m);
    
    % collect phase data in mag_array, theta_1_a and theta_2_a arrays
    % collect translated phase data in theta_1_a_t and theta_2_a_t arrays
    [mag_array{jj}{m},theta_1_a{jj}{m},theta_2_a{jj}{m},theta_3_a,r_a{jj}{m}] = qtrn_phase(a,b,c,d,1);
    [abs_q,theta_1_a_t{jj}{m},theta_2_a_t{jj}{m},theta_3,r] = qtrn_phase(a_t,b_t,c_t,d_t,1);
    
    % collect phase data for B
    a = w_b{jj}{1}{1}{m};
    b = -w_b{jj}{2}{1}{m};
    c = -w_b{jj}{1}{2}{m};
    d = w_b{jj}{2}{2}{m};
    
    [a,b,c,d] = flip_group_coeff_signs(a,b,c,d,m);
    [abs_q,theta_1_b{jj}{m},theta_2_b{jj}{m},theta_3_b,r] = qtrn_phase(a,b,c,d,1);
    
    
  end; % m = 1:3  
end; % jj = 1:J