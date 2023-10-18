function [d1_merge,d2_merge] = estimate_disparity_4(theta_1_a,theta_2_a,mag_array, r_a,theta_1_b,theta_2_b,s1,s2,J,N,M,N1,M1,mag_th,r_th,interp_option)

% estimate disparity of image A and B from phase data
% (compared to estimate_disparity.m, this version combines/averages all subband estimates
% at coarse scale and use it the average to predict/wrap-around estimates in next finer scale)
%
% this is part of function register_images.m 

% initialization  
% mag_th = 4; % smaller threshold -> more coefficients set to zero
% r_th = 0.6; % larger threshold -> more coefficients set to zero
  
% interp_option = 'bilinear'; 

for jj = 1:J

  S = N/(2^jj);
  d1map_p{jj} = zeros(S,S); % predicted dmap from previous scale
  d2map_p{jj} = zeros(S,S);
  
  for m = 1:3

    d1{jj}{m} = zeros(S,S);
    d2{jj}{m} = zeros(S,S); 
    d1_merge{jj}{m} = zeros(S,S); % result after merging subbands
    d2_merge{jj}{m} = zeros(S,S); 
    
  end; % m = 1:3  
end; % jj = 1:J

% (2) estimate translation using local frequency data from (1)
% - find slope data using theta_1 and theta_1_t (similarly for theta_2)
% - collect data in s1 and s2 arrays
% - remember to unwrap
% - how to use magnitude data or other method to determine reliability
%   of slope estimate?

% multi-scale idea:
% - need to first make sure coarsest scale J has good estimate
% - *** merge/average subband estimates *** 
% - interpolate scale J estimate to obtain prediction map for 
%   scale J-1 (nearest neighbor/bilinear)
% - if prediction is outside range for scale J-1, set to zero or use
%   interpolated value.
% - if not, obtain initial estimate for J-1; wrap around until within
%   range of prediction (if not possible - how to determine?, set to
%   zero)
% - if within range, keep as estimate for J-1
% - repeat same procedure from J-1 to J-2, J-2 to J-3, etc.


% obtain estimate for scale J first (should be less likely to wrap around)
for m = 1:3
  
  d1{J}{m} = (theta_1_a{J}{m}-theta_1_b{J}{m})./s1{J}{m};
  d2{J}{m} = (theta_2_a{J}{m}-theta_2_b{J}{m})./s2{J}{m};

  ind = abs(d1{J}{m})>=0.25*2^J;
  [d1_c,d2_c] = wrap_quaternion_phase(d1{J}{m}(ind),d2{J}{m}(ind),0,0,pi./s1{J}{m}(ind),pi./s2{J}{m}(ind));
  d1{J}{m}(ind) = d1_c; 							  
  d2{J}{m}(ind) = d2_c; 							  
  
   ind = mag_array{J}{m} < max(max(mag_array{J}{m}))/mag_th;
   d1{J}{m}(ind) = 0;
   d2{J}{m}(ind) = 0;
  
   ind = r_a{J}{m} < r_th;
   d1{J}{m}(ind) = 0;
   d2{J}{m}(ind) = 0;
        
end;

for jj = J-1:-1:0
    
    % merge all 3 subband estimates in previous scale into a single estimate    
    % (d1_merge and d2_merge have "m" index just to make output easier to process
    % with a previously written .m file (combine_result.m)) In fact, d1_merge{2..J}{m}
    % are the same for all m=1,2,3. similary for d2_merge
       
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % merge/average subbands for all previous scales 

    % variables for merging subbands (to keep track of estimates from all previous subbands)
    [N2,M2] = size(d1{jj+1}{1});

    nonzero_c1 = zeros(N2,M2);
    nonzero_c2 = zeros(N2,M2);
    D1map = zeros(N2,M2);
    D2map = zeros(N2,M2);
    D1_new{jj+1} = zeros(N2,M2);
    D2_new{jj+1} = zeros(N2,M2);

    % interpolate maps at previous scales first

    for kk = J:-1:jj+1
    
        if (kk ~= jj+1)
        
            D1_new{kk} = interp_dmap(D1_new{kk},interp_option);
            D2_new{kk} = interp_dmap(D2_new{kk},interp_option);
               
        elseif (kk == jj+1)
    
           % merge subbands
             D1_new{kk} = d1{jj+1}{3} + d1{jj+1}{2};  
             ind = (d1{jj+1}{3}~=0)&(d1{jj+1}{2}~=0); % both non-zero      
             D1_new{kk}(ind) = (d1{jj+1}{3}(ind) + d1{jj+1}{2}(ind))/2;
%            ind = (mag_array{kk}{3} > mag_array{kk}{2});
%            D1_new{kk} = d1{kk}{3}.*ind + d1{kk}{2}.*(~ind);

            D2_new{kk} = d2{jj+1}{3} + d2{jj+1}{1};
            ind = (d2{jj+1}{3}~=0)&(d2{jj+1}{1}~=0); % both non-zero      
            D2_new{kk}(ind) = (d2{jj+1}{3}(ind) + d2{jj+1}{1}(ind))/2;
%              ind = (mag_array{kk}{3} > mag_array{kk}{1});
%              D2_new{kk} = d2{kk}{3}.*ind + d2{kk}{1}.*(~ind);

            % get rid of cases when diagonal subband estimate is zero
            % while one of the other subband estimate was zero-ed by
            % threshold.
            % I assume that in the case for "purely" horizontal or vertical
            % disparity, disparity in the other dimension will be close to 
            % zero but not exactly zero
            
            ind = ((d1{jj+1}{3}==0)&(d1{jj+1}{2}~=0))&((d2{jj+1}{3}==0)&(d2{jj+1}{1}==0)); 
            D1_new{kk}(ind) = 0; 

            ind = ((d2{jj+1}{3}==0)&(d2{jj+1}{1}~=0))&((d1{jj+1}{3}==0)&(d1{jj+1}{2}==0)); 
            D2_new{kk}(ind) = 0; 
            
            % also get rid of outliars in each scale
            buf_N = round((N-N1)/2/2^kk); 
            buf_M = round((M-M1)/2/2^kk);

            D_new_abs = sqrt(D1_new{kk}.^2+D2_new{kk}.^2);
            D_new_abs_center = sqrt(D1_new{kk}(buf_N+2:end-buf_N,buf_M+1:end-buf_M-1).^2+D2_new{kk}(buf_N+2:end-buf_N,buf_M+1:end-buf_M-1).^2);
            %ind_nonzero = (D_new_abs_center ~= 0);
            ind = abs(D_new_abs(:))>(mean(abs(D_new_abs_center(:)))+3*std(abs(D_new_abs_center(:))));
            %disp(['number of zeroed-out pixels: ', num2str(sum(ind))]);
            D1_new{kk}(ind) = 0;
            D2_new{kk}(ind) = 0;
           
        end;    
        
        % don't average over unreliable/small-magnitude estimates
        nonzero_c1 = nonzero_c1 + (D1_new{kk}~=0);
        nonzero_c2 = nonzero_c2 + (D2_new{kk}~=0);
        
        D1map = D1map + D1_new{kk}; % in terms of pixels
        D2map = D2map + D2_new{kk}; % in terms of pixels                    
        
    end;    
    
        ind1 = nonzero_c1~=0;
        ind2 = nonzero_c2~=0;
        D1map(ind1) = D1map(ind1)./nonzero_c1(ind1);
        D2map(ind2) = D2map(ind2)./nonzero_c2(ind2);

    d1_merge{jj+1}{1} = D1map;
    d2_merge{jj+1}{1} = D2map;

    if (jj ~= 0)
    
        % interpolation
        d1_temp = d1_merge{jj+1}{1};
        d1map_p{jj} = interp_dmap(d1_temp,interp_option);
        d2_temp = d2_merge{jj+1}{1};
        d2map_p{jj} = interp_dmap(d2_temp,interp_option);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % now, use interpolated estimates from previous scales to wrap-around current 
        % scale estimates
        
        for m = 1:3
    
            d1{jj}{m} = (theta_1_a{jj}{m}-theta_1_b{jj}{m})./s1{jj}{m};
            d2{jj}{m} = (theta_2_a{jj}{m}-theta_2_b{jj}{m})./s2{jj}{m};
    
            % - if not, obtain initial estimate for J-1; wrap around until within
            %   range of prediction (if not possible - how to determine?, set to
            %   zero)
            [d1{jj}{m},d2{jj}{m}] = wrap_quaternion_phase(d1{jj}{m},d2{jj}{m},d1map_p{jj},d2map_p{jj},pi./s1{jj}{m},pi./s2{jj}{m});

            ind = mag_array{jj}{m} < max(max(mag_array{jj}{m}))/mag_th;
            d1{jj}{m}(ind) = 0;
            d2{jj}{m}(ind) = 0;
		
            ind = r_a{jj}{m} < r_th;
            d1{jj}{m}(ind) = 0;
            d2{jj}{m}(ind) = 0;
                
            % - repeat same procedure from J-1 to J-2, J-2 to J-3, etc.               
      end;
    
    end; % jj ~= 0 
  
end;

% for the finest stage (jj == 1)


for jj = 1:J
        
    d1_merge{jj}{2} = d1_merge{jj}{1};
    d1_merge{jj}{3} = d1_merge{jj}{1};
    d2_merge{jj}{2} = d2_merge{jj}{1};
    d2_merge{jj}{3} = d2_merge{jj}{1};
    
end;    