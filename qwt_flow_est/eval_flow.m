% Evaluate optic flow estimate, using Fleet and Jepson's (1990) angular
% error measures
%
% Usage: [phif,stf,phic,stc,EEf,EEc] = eval_flow (Vx, Vy, Cx, Cy);
%	Vx	horizontal component of full velocity
%	Vy	vertical component of full velocity
%	Cx	horizontal component of desired flow
%	Cy	vertical component of desired flow
%	phif	mean angular error (full velocity)
%	stf	standard deviation of angular error (full velocity)
%	phic	mean angular error (component velocity)
%	stc	standard deviation of angular error (component velocity)


function [phif,stf,phic,stc,EEf,EEc] = eval_flow (Vx, Vy, Cx, Cy)

[sy1 sx1] = size(Cx);
[sy sx] = size(Vx);
if ((sx~=sx1) | (sy~=sy1))
	error ('Sizes don''t match');
end


		%%%%%%%%%%%%
		% Evaluate %
		%%%%%%%%%%%%
% Full Velocity
EEf = acos((Vx.*Cx+Vy.*Cy+1)./sqrt(1+Vx.^2+Vy.^2)./sqrt(1+Cx.^2+Cy.^2));
Ef = EEf(~isnan(EEf)).*(180/pi);
phif = mean(Ef);
stf = std(Ef);
c = length(Ef)/sx/sy*100;

% Component Velocity
AUX1 = sqrt(Vx.^2+Vy.^2);
Nx = Vx./AUX1;
Ny = Vy./AUX1;
EEc = asin((Nx.*Cx+Ny.*Cy-AUX1)./sqrt(1+AUX1.^2)./sqrt(1+Cx.^2+Cy.^2));
Ec = EEc(~isnan(EEc)).*(180/pi);
phic = mean(Ec);
stc = std(Ec);




