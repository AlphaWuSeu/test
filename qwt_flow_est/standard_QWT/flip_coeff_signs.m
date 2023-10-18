function q_coeff = flip_coeff_signs(q_coeff,beta,pc)

% written on: 22 December 2004
%
% by William Chan

% part of reading mat/edge_shift_final_allangles
%
% purpose:  flip signs of coefficients for algorithm
% (due to design of LP filters (1-sided Hilbert transform)
% not consistent with derivation of algorithm)
%
% beta: interval of beta where coefficients are collected

if (pc == 0) % parent coefficient  
  
  for n = 1:length(beta)
    
    q_coeff{n}{1}(:,3) = -q_coeff{n}{1}(:,3);
    q_coeff{n}{1}(:,4) = -q_coeff{n}{1}(:,4);
    
    q_coeff{n}{2}(:,2) = -q_coeff{n}{2}(:,2);
    q_coeff{n}{2}(:,4) = -q_coeff{n}{2}(:,4);
    
    q_coeff{n}{3}(:,2) = -q_coeff{n}{3}(:,2);
    q_coeff{n}{3}(:,3) = -q_coeff{n}{3}(:,3);
    
  end;
  
elseif (pc == 1) % child coefficient (4 blocks)
  
  for k = 1:4
  
    for n = 1:length(beta)
    
    q_coeff{k}{n}{1}(:,3) = -q_coeff{k}{n}{1}(:,3);
    q_coeff{k}{n}{1}(:,4) = -q_coeff{k}{n}{1}(:,4);
    
    q_coeff{k}{n}{2}(:,2) = -q_coeff{k}{n}{2}(:,2);
    q_coeff{k}{n}{2}(:,4) = -q_coeff{k}{n}{2}(:,4);
    
    q_coeff{k}{n}{3}(:,2) = -q_coeff{k}{n}{3}(:,2);
    q_coeff{k}{n}{3}(:,3) = -q_coeff{k}{n}{3}(:,3);
    
    end;
    
  end;
    
end;
