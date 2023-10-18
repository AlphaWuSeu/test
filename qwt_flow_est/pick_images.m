function [A,B,A_o,B_o,correct_flow_s,N1,M1] = pick_images(seq_choice,seq_n1,seq_n2)

% see usage in test_register_images.m

file_s = '';
file_ext = '';
correct_flow_s = '';    

% read image files and correct flows
% (specify file directory for each image, and correct_flow filename (if exist))

switch (seq_choice)
    case 'rubic'
        file_s = 'jbarron/RUBIC_DATA/rubic';
        correct_flow_s = '';    
    case 'taxi'
        file_s = 'jbarron/TAXI_DATA/taxi';
        correct_flow_s = '';
    case 'sri_trees'
        file_s = 'jbarron/SRI_TREES_DATA/trees';
        correct_flow_s = '';
    case 'tree_div'
        file_s = 'jbarron/TREE_DATA/DIV/new2binarytreed';
        correct_flow_s = 'correct2_div20';    
    case 'tree_trans'
        file_s = 'jbarron/TREE_DATA/TRANS/new2binarytreet';
        correct_flow_s = 'correct2_trans20';    
    case 'square'
        file_s = 'jbarron/SQUARE_DATA/new_sq2';
        correct_flow_s = 'correct_square2';    
    case 'sine'
        file_s = 'jbarron/SINE_DATA/mysineB-6';
        correct_flow_s = 'correct_mysineB';    
    case 'yosemite'
        file_s = 'jbarron/YOSEMITE_DATA/yosemite256';
        correct_flow_s = 'new_correct_yos';            
    case 'ultrasound'
        correct_flow_s = '';
    case 'heart'
        file_s = 'new_images/heart';
        file_ext = '.tiff';
    case 'sflowg'
        file_s = 'new_images/sflowg';
        file_ext = '.png';
    case 'pentagon'
        file_s = 'new_images/';        
        file_ext = '.bmp';
    case 'unwarp'
        file_s = 'new_images/';        
        file_ext = '.jpg';
end;    

switch (seq_choice) 
    case {'tree_div','tree_trans'}
        A1 = read_sequence(file_s,seq_n1,150,150);
        B1 = read_sequence(file_s,seq_n2,150,150);
    
        [N1,M1] = size(A1); % original image size
        A1 = A1(2:N1,1:M1-1);
        B1 = B1(2:N1,1:M1-1);
        [N1,M1] = size(A1); % original image size
        S = 160; % specify image size for register_images.m
           
    case {'ultrasound'} 
        load ../yueyong_ultrasound/yueyong_ultradata;
        A1 = ultradata(:,:,seq_n1);
        B1 = ultradata(:,:,seq_n2);

        [N1,M1] = size(A1); % original image size
        S = 320; % specify image size
    case {'heart'}
        
        if (seq_n1 < 10)
            seq_n1_str = ['.00',num2str(seq_n1)];
        else
            seq_n1_str = ['.0',num2str(seq_n1)];
        end;
        if (seq_n2 < 10)
            seq_n2_str = ['.00',num2str(seq_n2)];
        else
            seq_n2_str = ['.0',num2str(seq_n2)];                    
        end;
            
        file_1 = [file_s,'/',seq_choice,seq_n1_str,file_ext];
        file_2 = [file_s,'/',seq_choice,seq_n2_str,file_ext];

        A1 = double(imread(file_1));
        B1 = double(imread(file_2));
        
        [N1,M1] = size(A1); % original image size
        S = round(N1/32)*32;%2^ceil(log2(max(N1,M1))); % specify image size
                
    case {'pentagon'}

        A1 = double(imread('new_images/pentagon_left.bmp'));
        B1 = double(imread('new_images/pentagon_right.bmp'));
        
        [N1,M1] = size(A1); % original image size
        S = 2^ceil(log2(max(N1,M1))); % specify image size

    case {'edge'}

        A1 = double(imread('new_images/edge_model/edge_45_d0.bmp'));
        B1 = double(imread('new_images/edge_model/edge_45_d0_5.bmp'));
        
        [N1,M1] = size(A1); % original image size
        S = 160;
    
    case {'unwarp'}

        A1 = double(imread('new_images/unwarp640-L.jpg'));
        B1 = double(imread('new_images/unwarp640-R.jpg'));
        
        [N1,M1] = size(A1); % original image size
        S = 640; % specify image size        
        
    otherwise
        A1 = read_sequence(file_s,seq_n1);
        B1 = read_sequence(file_s,seq_n2);
    
        [N1,M1] = size(A1); % original image size
        S = 2^ceil(log2(max(N1,M1))); % specify image size
end;    

% register_images.m assumes image dyadic! (make input images dyadic)
% add black background

A_o = A1;
B_o = B1;
A = A1;
B = B1;
[N,M] = size(A1);
if (N < S)
  A1 = [repmat(A1(1,:),ceil((S-N)/2),1); A1; repmat(A1(N,:),floor((S-N)/2),1)];
  B1 = [repmat(B1(1,:),ceil((S-N)/2),1); B1; repmat(B1(N,:),floor((S-N)/2),1)];
  A = A1;
  B = B1;
end;
[N,M] = size(A);
if (M < S)
  A1 = [repmat(A1(:,1),1,ceil((S-M)/2)) A1 repmat(A1(:,M),1,floor((S-M)/2))];
  B1 = [repmat(B1(:,1),1,ceil((S-M)/2)) B1 repmat(B1(:,M),1,floor((S-M)/2))];
  A = A1;
  B = B1;  
end;