function w = draw_wedge_rt_smooth(r, th, h, mn, s, N, profile);
%draw_wedge_rt_smooth.m
% 
%  Draws a wedge at the specified orientation and mean/height with specified
%   smoothness parameter
%  Usage : w = draw_wedge_rt_smooth(r, th, h, mn, s, N, profile)
%  r - distance
%  th - angle (in degrees)
%  h - jump height (difference in intensity between 2 regions)
%  mn - mean (of intensity)
%  s - smoothness parm (width in pixels of profile transition) (s>=1)
%  N - blocksize
%  profile (optional) - describes shape of edge profile function. If not
%                       specified, the default in edgeProfileFunction is used.
%
% Created by Mike Wakin - 04 January 2002

if (s<=1) 
  % Still use the averaging method
  w = h*draw_edge_rt(r, th, N); 
  w = w - mean(w(:)) + mn;
  return;
end

% See notes p.65 for a diagram

xPrime = r*cos(deg2rad(th));
yPrime = r*sin(deg2rad(th));
m = tan(deg2rad(th+90));

tanTheta = tan(deg2rad(th));

xHat = zeros(N);
for jj = 1:N
  xHat(:,jj) = jj-(N+1)/2;
end
yHat = zeros(N);
for ii = 1:N
  yHat(ii,:) = (N+1)/2-ii;
end

xStar = (yHat-yPrime+m*xPrime-tanTheta*xHat)/(m-tanTheta);
yStar = m*xStar+yPrime-m*xPrime;

distsToEdge = sqrt((xHat-xStar).^2+(yHat-yStar).^2);
if (nargin < 7)
  w = abs(h/2)*edgeProfileFunction(distsToEdge,s);
else
  w = abs(h/2)*edgeProfileFunction(distsToEdge,s,profile);
end

above = (yHat>(m*xHat+yPrime-m*xPrime));

if (0>(yPrime-m*xPrime))
  % Origin is "above"
  w = sign(h)*w.*above - sign(h)*w.*(1-above);
else
  % Origin is "below"
  w = -sign(h)*w.*above + sign(h)*w.*(1-above);
end

w = w - mean(w(:)) + mn;
return;


%if (s>1)
%  centerX = N/2;
%  centerY = N/2;
%  intersectX = centerX + sqrt(r*r/(1+(tan(deg2rad(th)))^2));
%  intersectY = centerY + tan(deg2rad(th))*(intersectX-centerX);
%  distsToEdge = zeros(size(w));
%  for ii = 1:N
%    yCoord = N-ii+1;
%    for jj = 1:N
%      xCoord = jj;
%      newY = yCoord-centerY;
%      newX = xCoord-centerX;
%      newD = translate_d_parms(newX,newY,r,deg2rad(th+90));
%      distsToEdge(ii,jj) = newD;
%    end
%  end
%  w = abs(h/2)*sign(w).*edgeProfileFunction(distsToEdge,s);
%end
%






