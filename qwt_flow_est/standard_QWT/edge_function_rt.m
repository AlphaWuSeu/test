% edge_function_rt.m
%
% Calculates the edge function using the (r,theta) equations.
% Usage : alpha = edge_function_rt(R, TH)
% R=0 is the center of the box
% TH is in degrees
%
% Written by : Justin Romberg
% Created : 3/28/2001

function alpha = edge_function_rt(R, TH)

if (length(R(:)) ~= length(TH(:)))
  error('R and TH must be the same length');
end

alpha = zeros(size(R));
TH2 = mod(TH,90);
it = find(TH2 >= 45);
TH2(it) = 90 - TH2(it);
THr = pi*TH2/180;

b1 = -1/2*(cos(THr)+sin(THr));
b2 = -1/2*(cos(THr)-sin(THr));
b3 = 1/2*(cos(THr)-sin(THr));
b4 = 1/2*(cos(THr)+sin(THr));

iz = find(R < b1);
alpha(iz) = 0;

i1 = find((R >= b1) & (R < b2));
alpha(i1) = 1/4 + ...
    (R(i1).^2 + R(i1).*(cos(THr(i1))+sin(THr(i1))) + 1/4) ./ ...
    (2*cos(THr(i1)).*sin(THr(i1))); 

i2 = find((R >= b2) & (R < b3));
alpha(i2) = 1/2 + R(i2)./cos(THr(i2));

i3 = find((R >= b3) & (R < b4));
alpha(i3) = 3/4 - tan(THr(i3))/4 - cot(THr(i3))/4 + ...
    (-R(i3).^2 + R(i3).*(cos(THr(i3))+sin(THr(i3))) + 1/4) ./ ...
    (2*cos(THr(i3)).*sin(THr(i3))); 

io = find(R >= b4);
alpha(io) = 1;

%keyboard