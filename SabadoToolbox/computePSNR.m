function [globalPsnr,averagePsnr] = computePSNR(filename1,filename2,w, h, param5, param6, param7, param8)
%COMPUTEPSNR - Compute the PSNR of two YUV files.
%    [globalPsnr,averagePsnr] = computePSNR(filename1,filename2,w, h)
%    computes the global and the average psnr of all luminance frames in 
%    the files filename1 and filename2, of size w x h. The bitdepth is
%    considered as 8 bits per sample, and the sequences are read as YUV
%    4:2:0.
%
%    [globalPsnr,averagePsnr] = computePSNR(filename1,filename2,w, h,
%                               nframes) computes the global and the 
%    average psnr of the first nframes luminance frames in the files 
%    filename1 and filename2, of size (w x h). 
%
%    [globalPsnr,averagePsnr] = computePSNR(filename1,filename2,w, h,
%                               nframes,luma_only) computes the global and 
%    the average psnr of the first nframes frames in the files filename1 
%    and filename2, of size (w x h). The parameter luma_only indicates
%    whether only the luminance frames are considered (1) or if the 
%    chrominance components are considered as well (0 - default).
%
%    [globalPsnr,averagePsnr] = computePSNR(filename1,filename2,w, h,
%                               nframes, luma_only, bitdepth)
%    computes the global and the average psnr of the first nframes frames 
%    in the files filename1 and filename2, of size w x h, using the 
%    specified bitdepth.
%
%    [globalPsnr,averagePsnr] = computePSNR(filename1,filename2,w, h,
%                               nframes, luma_only, 
%                               [bitdepth1 bitdepth2 target_bitdepth])
%    computes the global and the average psnr of the first nframes frames 
%    in the files filename1 and filename2, of size w x h, using bitdepth1 
%    for the first sequence, bitdepth2 for the second sequence and 
%    computing the PSNR at the target_bitdepth.
%
%    [globalPsnr,averagePsnr] = computePSNR(filename1,filename2,w, h,
%                               nframes, luma_only, bitdepth,isYUV444)
%    computes the global and the average psnr of the first nframes frames 
%    in the files filename1 and filename2, of size w x h, using the 
%    specified bitdepth. The parameter isYUV444 specifies if the 
%    chrominance component have the same size as the luminance component 
%    (1) or a quarter the size of the luminance component (0 - default).
%
%    Eduardo Peixoto F. Silva.
%    eduardopfs@gmail.com
%

%Minimum number of parameters: 4.
if (nargin <4)
    error('Not enough input parameters.')        
end
if (nargin == 4)
    nframes = 0;
    luma_only = 1;
    bitdepth1 = 8;
    bitdepth2 = 8;
    bitdepth_target = 8;
    isYUV444 = 0;
end
if (nargin == 5)
    nframes = param5;
    luma_only = 1;
    bitdepth1 = 8;
    bitdepth2 = 8;
    bitdepth_target = 8;
    isYUV444 = 0;
end
if (nargin == 6)
    nframes = param5;
    luma_only = param6;
    bitdepth1 = 8;
    bitdepth2 = 8;
    bitdepth_target = 8;
    isYUV444 = 0;
end
if (nargin == 7)
    nframes = param5;
    luma_only = param6;
    if (numel(param7) == 1)
        bitdepth1 = param7;
        bitdepth2 = param7;
        bitdepth_target = param7;        
    elseif (numel(param7) == 3)
        bitdepth1 = param7(1);
        bitdepth2 = param7(2);
        bitdepth_target = param7(3);
    else
        error('The bitdepth should have either 1 or 3 elements.')
    end
    isYUV444 = 0;
end
if (nargin == 8)
    nframes = param5;
    luma_only = param6;
    if (numel(param7) == 1)
        bitdepth1 = param7;
        bitdepth2 = param7;
        bitdepth_target = param7;        
    elseif (numel(param7) == 3)
        bitdepth1 = param7(1);
        bitdepth2 = param7(2);
        bitdepth_target = param7(3);
    else
        error('The bitdepth should have either 1 or 3 elements.')
    end    
    isYUV444 = param8;
end
if (nargin > 8)
    disp('Too many input parameters.')
    return
end



%%%%%%%%%%%%%%%%%%%%%%%%%
%Changes the datatype according to the bitdepth.
if (bitdepth1 < 8)
    disp('Changing the first bitdepth to 8.')
    bitdepth1 = 8;
    datatype1 = 'uint8=>double';
elseif (bitdepth1 == 8)
    datatype1 = 'uint8=>double';
elseif (bitdepth1 <= 16)
    datatype1 = 'uint16=>double';
elseif (bitdepth1 <= 32)
    datatype1 = 'uint32=>double';
else
    disp('Changing the first bitdepth to 32.')
    bitdepth1 = 32;
    datatype1 = 'uint32=>double';
end

%Changes the datatype according to the bitdepth.
if (bitdepth2 < 8)
    disp('Changing the second bitdepth to 8.')
    bitdepth2 = 8;
    datatype2 = 'uint8=>double';
elseif (bitdepth2 == 8)
    datatype2 = 'uint8=>double';
elseif (bitdepth2 <= 16)
    datatype2 = 'uint16=>double';
elseif (bitdepth2 <= 32)
    datatype2 = 'uint32=>double';
else
    disp('Changing the second bitdepth to 32.')
    bitdepth2 = 32;
    datatype2 = 'uint32=>double';
end

%Computes the two scale factors.
scale_factor1 = 2^(bitdepth_target - bitdepth1);
scale_factor2 = 2^(bitdepth_target - bitdepth2);
max_value_output = 2^bitdepth_target - 1;


%%%%%%%%%%%%%%%%%%%%%%%%%
%Open the first file.
[fid1,message] = fopen(filename1,'r');

%Exits the function if the file cannot be open.
if (fid1 == -1)
    error(message)
end

%Open the second file.
[fid2,message] = fopen(filename2,'r');

%Exits the function if the file cannot be open.
if (fid2 == -1)
    error(message)
end

%%%%%%%%%%%%%%%%%%%%%%%%%
%Computes the number of elements for the luminance and chrominance
%components.
n_elements_luma = w*h;
if (isYUV444 == 1)
    n_elements_chroma = w*h;
else
    n_elements_chroma = w*h/4;
end
total_n_elements = n_elements_luma + 2* n_elements_chroma;

%%%%%%%%%%%%%%%%%%%%%%%%
%Computes the number of elements to be considered.
if (luma_only == 1)
    n_elements = n_elements_luma;
else
    n_elements = n_elements_luma + 2 * n_elements_chroma;
end

%Computes (2^bitdepth - 1)^2.
peak_value_2 = (2^bitdepth_target - 1)^2;

%Disable the matlab warning.
warning off MATLAB:divideByZero

square_diff = zeros(nframes,1);
psnr_var    = zeros(nframes,1);    

stop_loop = 0;
n_frames_read = 0;
while (stop_loop == 0)
    [A1,count1] = fread(fid1,total_n_elements,datatype1);
    [A2,count2] = fread(fid2,total_n_elements,datatype2);
    
    if ((count1 ~= total_n_elements) || (count2 ~= total_n_elements))
        stop_loop = 1;
    else
        %Scales and crops the data.
        A1 = round(scale_factor1 * A1);
        A1(A1 > max_value_output) = max_value_output;
        A2 = round(scale_factor2 * A2);
        A2(A2 > max_value_output) = max_value_output;
        
        %Computes the PSNR.
        n_frames_read = n_frames_read + 1;
        square_diff(n_frames_read,1) = sum(sum( (A1(1:n_elements) - A2(1:n_elements) ).^2 ));
        psnr_var(n_frames_read,1)    = 10 * log10 ( (peak_value_2 * n_elements)/(square_diff(n_frames_read,1)) );
        if (n_frames_read == nframes)
            stop_loop = 1;
        end        
    end
end

%Closes the files streams.
fclose(fid1);
fclose(fid2);

%Computes the average and global psnrs of the frames read so far.
averagePsnr = sum(psnr_var(1:n_frames_read))/n_frames_read;
sq_diff = sum(square_diff(1:n_frames_read));
globalPsnr = 10 * log10 ( (peak_value_2 * n_frames_read * n_elements)/(sq_diff) ); 

    



