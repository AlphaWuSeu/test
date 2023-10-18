function A = interp_dmap(B,option)
  
% interpolate B to get A (twice the size of B)
  
[M,N] = size(B);  
A = zeros(2*M,2*N);  

if (strcmp(option,'nearest'))
  
  for m = 1:2*M
    for n = 1:2*N
      
      A(m,n) = B(ceil(m/2),ceil(n/2));
      
    end;
  end;
  
else % if (strcmp(option,'bilinear')) bilinear (by default)
  
  % first do a nearest-neighbor interpolation
  for m = 1:2*M
    for n = 1:2*N
      
      A(m,n) = B(ceil(m/2),ceil(n/2));
      
    end;
  end;
  
  mask1 = repmat([1 0; 0 0],M,N);
  mask2 = repmat([0 1; 0 0],M,N);
  mask3 = repmat([0 0; 1 0],M,N);
  mask4 = repmat([0 0; 0 1],M,N);
  
  % bilinearly interpolate for pixel 1's
  A11 = A.*mask1;
  A12 = cshift(A,7).*mask1;
  A13 = cshift(A,5).*mask1;
  A14 = cshift(A,8).*mask1;
  A1 = (0.75)^2*A11 + 0.75*0.25*(A12 + A13) + (0.25)^2*A14;
  
  % bilinearly interpolate for pixel 2's
  A21 = A.*mask2;
  A22 = cshift(A,7).*mask2;
  A23 = cshift(A,4).*mask2;
  A24 = cshift(A,6).*mask2;
  A2 = (0.75)^2*A21 + 0.75*0.25*(A22 + A23) + (0.25)^2*A24;
  
  % bilinearly interpolate for pixel 3's
  A31 = A.*mask3;
  A32 = cshift(A,2).*mask3;
  A33 = cshift(A,5).*mask3;
  A34 = cshift(A,3).*mask3;
  A3 = (0.75)^2*A31 + 0.75*0.25*(A32 + A33) + (0.25)^2*A34;
  
  % bilinearly interpolate for pixel 4's
  A41 = A.*mask4;
  A42 = cshift(A,1).*mask4;
  A43 = cshift(A,2).*mask4;
  A44 = cshift(A,4).*mask4;
  A4 = (0.75)^2*A41 + 0.75*0.25*(A42 + A43) + (0.25)^2*A44;
  
  A = A1+A2+A3+A4;
    
end;