function im = draw_edge(beta,d,polarity,N)
  
% draw edge function for phase estimation program
%
% beta:       orientation (-90,90] degree only (see notes 7/8/04)
% d:          offset from origin
% polarity:   1 or 0 (1-normal convention, 0-outside(-90,90])
% N:          size of image block
%
% William Chan, 1/4/05
  
jump = 100; % intensity difference of the step edge
mn = 100;   % mean intensity between the two levels across edge
s = 1;      % smoothness parameter

if (polarity == 1)    
  
  im = draw_wedge_rt_smooth(d,beta,jump,mn,s,N);
  
elseif (polarity == 0)
  
  beta = beta-sign(beta)*180;
  im = draw_wedge_rt_smooth(d,beta,jump,mn,s,N);
  
else
  
  disp('wrong polarity');
  
end;
