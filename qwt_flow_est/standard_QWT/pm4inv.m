function [a, b, c, d] = pm4inv(u, v, q, r)

% [u, v, q, r] = pm4(a, b, c, d);
% u = (a + b - c - d)/2;
% v = (a - b + c + d)/2; 
% q = (a + b - c + d)/2;
% r = (a + b + c - d)/2;

a = ( u + v + q + r)/2;
b = (-u - v + q + r)/2; 
c = (-u + v - q + r)/2;
d = (-u + v + q - r)/2;
