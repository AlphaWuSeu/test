% Function to read an image sequence
% Supported: Fleet's binary format and SUN rasterfiles
%
% Usage: X = read_sequence (stem, middle_frame, st, [sx, sy]);
%	stem	common stem of filenames, e.g. "yosemite/yosemite256."
%       mid     middle_frame number of middle frame [10]
%	st	temporal span [5]
%       fn      frame number
%	sx,sy	spatial dimensions, only provided for the binary format

function X = read_sequence (stem1, fn, sx, sy)
  
if (nargin<3)
	bin_flag = 0;
else
	bin_flag = 1;
end

if (bin_flag)
  
	%for t=1:st
		fid = fopen ([stem1 '.' num2str(fn)], 'r');

		% THERE IS NO HEADER IN TREE DATA
		X = fread(fid,[sx,sy],'uchar');
		X = X';
		fclose(fid);

	%end
else
  
    % rubic data is a little strange (with 288 bytes header)
    if (~isempty(findstr(stem1,'rubic')))
        hr = 72;
    else
        hr = 8;
    end;
    
	% Load First Frame
	name_in = [stem1 '.' num2str(fn)];
	fid = fopen(name_in,'r');
	h = fread(fid,hr,'int32','ieee-be');
	X = fread(fid,[h(2) h(3)],'uchar');
	%X = reshape(X,h(2),h(3));
	
	fclose(fid);
	X = X';
	
end;

%imagesc(X); axis image; colormap(gray);