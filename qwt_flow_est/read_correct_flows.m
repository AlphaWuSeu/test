function [D1,D2] = read_correct_flows(stem1)
  
stem_path = 'jbarron/CORRECT_FLOWS/';
infile = [stem_path stem1];

fid = fopen(infile,'r');
h = fread(fid,6,'float','ieee-be');

D_size = h(3)*h(4);
d1 = zeros(1,D_size);
d2 = zeros(1,D_size);

for k = 1:D_size
  
  d1(k) = fread(fid,1,'float','ieee-be');
  d2(k) = fread(fid,1,'float','ieee-be');
  
end;

D1 = flipud(reshape(d1,h(3),h(4))')';
D2 = flipud(reshape(d2,h(3),h(4))')';
%figure(10); quiver(D1,D2); %quiver(D1(1:4:h(4),1:4:h(3)),D2(1:4:h(4),1:4:h(3))); axis square; ...
%    axis tight;
%title('Downsampled Correct Disparity Flow (D1_c,D2_c)');

fclose(fid);


%size(D1)