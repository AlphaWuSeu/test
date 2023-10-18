function A = cshift(B,option)
  
% circular shift matrix B by two pixel (columns and/or rows) to get A
% 
% option: 1-8 directions
%
%                        1  2  3
%                        4     5
%                        6  7  8
%
% e.g. 7 is TOWARDS the bottom direction; 8 is TOWARDS bottom right

[M,N] = size(B);  
  
if (option == 1)
  
  A1 = [B(3:M,:); B(1:2,:)];
  A = [A1(:,3:N) A1(:,1:2)];
  
elseif (option == 2)
  
  A = [B(3:M,:); B(1:2,:)];
  
elseif (option == 3)
  
  A1 = [B(3:M,:); B(1:2,:)];
  A = [A1(:,N-1:N) A1(:,1:N-2)];
  
elseif (option == 4)
  
  A = [B(:,3:N) B(:,1:2)];
  
elseif (option == 5)
  
  A = [B(:,N-1:N) B(:,1:N-2)];
  
elseif (option == 6)
  
  A1 = [B(:,3:N) B(:,1:2)];
  A = [A1(M-1:M,:); A1(1:M-2,:)];
  
elseif (option == 7)
  
  A = [B(M-1:M,:); B(1:M-2,:)];
  
elseif (option == 8)
  
  A1 = [B(:,N-1:N) B(:,1:N-2)];
  A = [A1(M-1:M,:); A1(1:M-2,:)];

end;