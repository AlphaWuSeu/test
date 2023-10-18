% draw_edge_rt.m
%
% Makes an image consisting of one edge formed by the "CCD" model
% Input is (r, theta) parameterization of the orthogonal intercept (from the
% center of the box) of the line.
% Output is normalized.
% The edge value is the area of the region including the origin.
%
% Usage : E = draw_edge_rt(r, th, N)
% r is the distance of the orthogonal intercept
% th is the angle (in degrees) of the orthogonal intercept
% N is the square sidelength (X is NxN)
% r=0 is the center of the box
% th is in degrees
%
% Written by : Justin Romberg
% Created : 3/20/2001

function E = draw_edge_rt(r, th, N)

  x = linspace(-N/2+1/2, N/2-1/2, N);
  y = linspace(N/2-1/2, -N/2+1/2, N);
  [X,Y] = meshgrid(x,y);
  
  R = r - X*cos(pi*th/180) - Y*sin(pi*th/180);
  TH = th*ones(N,N);
  
  E = edge_function_rt(R,TH);
  
